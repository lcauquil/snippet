##########################################################
#####    Taxonomic comparison with metacoder
##########################################################

## New session (Ctrl + Shift + F10)

## packages
pacman::p_load(tidyverse,
               here,
               readODS,
               data.tree,
               metacoder,
               cowplot) ## plot_grid()


path <- here("data_taxonomy.ods")

#######################################
## Atlas_sister
Atlas_sister <- read_ods(path = path,
                         sheet = "Sample_A")
Atlas_sister <- Atlas_sister[1:9]
colnames(Atlas_sister) <- c("Taxon_ID", "count", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "species")
Atlas_sister$Taxon_ID <- paste0("ID_", Atlas_sister$Taxon_ID)
Atlas_sister$Genus[Atlas_sister$Genus == "Clostridioides"] <- "Clostridium"
