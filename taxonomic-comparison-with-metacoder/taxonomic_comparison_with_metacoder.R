##########################################################
#####    Taxonomic comparison with metacoder
##########################################################

## New R session (Ctrl + Shift + F10)

## packages
pacman::p_load(tidyverse,
               here,
               readODS,
               data.tree,
               metacoder,
               cowplot) ## plot_grid()

## check number of sheets in file
nb_sh <- get_num_sheets_in_ods("taxonomic-comparison-with-metacoder/data_taxonomy.ods")

#######################################
## import data
tmp <- list()
for (i in seq_len(nb_sh))
{
  ## read each sheet
  tmp[[i]] <- read_ods(path = "taxonomic-comparison-with-metacoder/data_taxonomy.ods", sheet = i)
  ## add colnames
  colnames(tmp[[i]]) <- c("Taxon_ID", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "species")
}


########################################
## full taxonomy
reduce(tmp,rbind) %>% 
  distinct() %>% 
  arrange(Kingdom, Phylum, Class, Order, Family, Genus, species) -> full_tax

####################
## Meta_data (i.e. samples)
meta_data <- data.frame(sample = list_ods_sheets(path = "taxonomic-comparison-with-metacoder/data_taxonomy.ods"),
                        stringsAsFactors = F)


## Table 0/1 presence
otu_table_bin <- data.frame(row.names = full_tax$Taxon_ID)

for (i in seq_along(meta_data[,1]))
{
  otu_table_bin[,i] <- ifelse(full_tax$Taxon_ID %in% tmp[[i]]$Taxon_ID, 1, 0)
}
colnames(otu_table_bin) <- c("Sample_A","Sample_B", "Sample_C", "Sample_D", "Control")

## check 
apply(otu_table_bin, 2, sum)

## join OTU_table and taxonomy
## taxon_ID as row.names to have common variable
otu_table_bin <- rownames_to_column(data.frame(otu_table_bin), var = "Taxon_ID")
full_tax$Taxon_ID <- as.character(full_tax$Taxon_ID)
tmp_bin <- left_join(otu_table_bin, full_tax)


## metacoder object
obj_bin <- parse_tax_data(tmp_bin,
                          class_cols = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "species"),
                          named_by_rank = TRUE)


## Get per-taxon counts
obj_bin$data$tax_abund <- calc_taxon_abund(obj_bin, "tax_data")

obj_bin <- filter_taxa(obj_bin, taxon_names %in% c("Bacteria"), subtaxa = TRUE) 

## 0/1 presence
for (i in 2:6)
{
  obj_bin$data$tax_abund[[i]] <- ifelse(obj_bin$data$tax_abund[[i]] > 0, 1, 0)
}

comparisons <- list(c("Control", "Sample_A"),
                    c("Control", "Sample_B"),
                    c("Control", "Sample_C"),
                    c("Control", "Sample_D"))

## Compare following comparisons
plot_compare <- function(obj)
{
  p <- list()
  for (i in seq_along(comparisons))
  {
    obj$data$diff_table <- compare_groups(
      obj,
      data = "tax_abund",
      cols = comparisons[[i]],
      groups = comparisons[[i]],
      ## trick to identify all possibilities
      ## 0 = none in common
      ## 1 = only in Control
      ## 2 = only in Sample
      ## 3 = present in both
      func = function(x, y)
        (1 * sum(any(x))) + (2 * sum(any(y))))
    
    ## same tree orientation
    set.seed(12345)
    
    ## plot tree
    p[[i]] <- heat_tree(
      obj,
      make_node_legend = FALSE,
      make_edge_legend = FALSE,
      node_label = taxon_names,
      node_label_size_range = c(0.01, 0.02),
      node_size_range = c(0.01, 0.01),
      node_color = ifelse(
        obj$data$diff_table[[4]] == 0, 'grey', ## none in common
        ## absent
        ifelse(
          obj$data$diff_table[[4]] == 1, 'red',## only in Control
          ## mock only
          ifelse(obj$data$diff_table[[4]] == 2, 'blue',     ## only in Sample
                                                'green'))), ## present in both
      
      
      layout = "davidson-harel",
      initial_layout = "reingold-tilford",
      title = paste0(comparisons[[i]][1], " vs ", comparisons[[i]][2])
    )
    
  }
  return(p)
}

## p = list of the 4 comparison plots
p <- plot_compare(obj_bin)

## combine 4 plots in one frame
plot_grid(plotlist = p,
          ncol = 2)

## save in PDF format
ggsave2("taxonomic-comparison-with-metacoder/comparison_trees.pdf")

