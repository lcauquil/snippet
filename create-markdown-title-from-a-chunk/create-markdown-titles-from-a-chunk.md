---
title: "Create markdown headers from a chunk"
author: "Laurent Cauquil"
date: "22/10/2020"
output: 
  html_document:
    keep_md: yes
---



## Create one header in a chunk

```r
cat(sprintf("### Header level 3"))
```

### Header level 3

<Br><Br>

## Create several headers in a chunk with a loop

### Data.frame: content of each section

```r
library(stringi)

set.seed(12345) ## reproducibility
input <- data.frame(
  name = 1:3,
  text = stri_rand_lipsum(3),  ## create 3 lorem ipsum paragraph
  stringsAsFactors = FALSE)

## data
input
```

```
##   name
## 1    1
## 2    2
## 3    3
##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    text
## 1 Lorem ipsum dolor sit amet, semper arcu sed sed non pellentesque rutrum. Tempor curabitur in taciti gravida ut interdum iaculis arcu consectetur. Dictum et erat. Vestibulum luctus ridiculus luctus metus ad ex, bibendum eget at. Maximus nisl quisque ante posuere aptent cubilia. Tellus sed aliquam suspendisse arcu et dapibus. Aenean ultricies, primis sit nulla. Condimentum, sed phasellus viverra nullam primis fringilla efficitur. Sit et gravida metus duis, mauris elementum non mus dictumst neque litora sapien. Venenatis suspendisse suscipit ligula at aliquet dapibus enim cras. Interdum feugiat blandit integer viverra ante augue habitasse amet proin. Erat penatibus sit dictum, pellentesque ante. Dictum imperdiet litora suscipit venenatis nec leo vel quis, penatibus.
## 2                                                                                                   Mattis ligula netus nec nec. Quisque hendrerit pellentesque tincidunt cubilia sed nunc! Suscipit vitae lorem tellus per ac arcu consequat ornare et ut. Lectus, ullamcorper vestibulum duis ante quis senectus enim ipsum. Libero, auctor amet ac ac et libero fames aenean class. Mi quam blandit pellentesque orci risus efficitur sodales arcu cubilia inceptos diam. Ante netus primis class pretium auctor. Phasellus netus, libero. Donec congue ac. Mus sed quis fusce sagittis sed sit ac risus dis rutrum mattis inceptos! Elit ut ac posuere hac commodo non. Aliquam nec hac vulputate velit faucibus sed, donec vivamus eu. Congue et sed nulla leo ut suscipit tempor metus imperdiet.
## 3                        Convallis in donec curabitur nulla viverra at lectus. Sed in blandit aenean ullamcorper varius, accumsan, at, vitae lacus. Turpis erat enim montes mauris nibh etiam tortor, tellus quis semper tincidunt phasellus luctus eros. Eros nascetur tincidunt sed, nec a velit cras sodales phasellus ac in, nascetur porta. Augue dignissim varius, duis conubia vehicula, arcu auctor posuere primis in quisque eleifend. Porttitor habitasse ex, ultrices, porta tellus orci sed aliquet. Amet, amet dolor vitae turpis nam semper eget posuere. Orci urna pretium, sociosqu porttitor malesuada mi. Enim sociis pellentesque. Lorem imperdiet mattis pellentesque accumsan pretium praesent luctus sit aptent sed aliquet morbi. Curabitur nec ipsum vel ipsum ante, tempor eu.
```

### Output pattern for all sections

```r
template <- "## This is paragraph n°%s
%s

**Number of characters**: `%1i`

" ## don't forget to add end of line
## format output
template
```

```
## [1] "## This is paragraph n°%s\n%s\n\n**Number of characters**: `%1i`\n\n"
```

### Create sections

```r
## asis:    avoid knitr to add another output template
## sprintf: avoid R to add other characters such as quotes
for (i in seq(nrow(input))) {
  current <- input[i, ]
  cat(sprintf(template, ## pattern
              current$name, ## number of the section
              current$text, ## text of the section
              nchar(stri_rand_lipsum(3)[i])))  ## return number of characters for each section
}
```

## This is paragraph n°1
Lorem ipsum dolor sit amet, semper arcu sed sed non pellentesque rutrum. Tempor curabitur in taciti gravida ut interdum iaculis arcu consectetur. Dictum et erat. Vestibulum luctus ridiculus luctus metus ad ex, bibendum eget at. Maximus nisl quisque ante posuere aptent cubilia. Tellus sed aliquam suspendisse arcu et dapibus. Aenean ultricies, primis sit nulla. Condimentum, sed phasellus viverra nullam primis fringilla efficitur. Sit et gravida metus duis, mauris elementum non mus dictumst neque litora sapien. Venenatis suspendisse suscipit ligula at aliquet dapibus enim cras. Interdum feugiat blandit integer viverra ante augue habitasse amet proin. Erat penatibus sit dictum, pellentesque ante. Dictum imperdiet litora suscipit venenatis nec leo vel quis, penatibus.

**Number of characters**: `717`

## This is paragraph n°2
Mattis ligula netus nec nec. Quisque hendrerit pellentesque tincidunt cubilia sed nunc! Suscipit vitae lorem tellus per ac arcu consequat ornare et ut. Lectus, ullamcorper vestibulum duis ante quis senectus enim ipsum. Libero, auctor amet ac ac et libero fames aenean class. Mi quam blandit pellentesque orci risus efficitur sodales arcu cubilia inceptos diam. Ante netus primis class pretium auctor. Phasellus netus, libero. Donec congue ac. Mus sed quis fusce sagittis sed sit ac risus dis rutrum mattis inceptos! Elit ut ac posuere hac commodo non. Aliquam nec hac vulputate velit faucibus sed, donec vivamus eu. Congue et sed nulla leo ut suscipit tempor metus imperdiet.

**Number of characters**: `732`

## This is paragraph n°3
Convallis in donec curabitur nulla viverra at lectus. Sed in blandit aenean ullamcorper varius, accumsan, at, vitae lacus. Turpis erat enim montes mauris nibh etiam tortor, tellus quis semper tincidunt phasellus luctus eros. Eros nascetur tincidunt sed, nec a velit cras sodales phasellus ac in, nascetur porta. Augue dignissim varius, duis conubia vehicula, arcu auctor posuere primis in quisque eleifend. Porttitor habitasse ex, ultrices, porta tellus orci sed aliquet. Amet, amet dolor vitae turpis nam semper eget posuere. Orci urna pretium, sociosqu porttitor malesuada mi. Enim sociis pellentesque. Lorem imperdiet mattis pellentesque accumsan pretium praesent luctus sit aptent sed aliquet morbi. Curabitur nec ipsum vel ipsum ante, tempor eu.

**Number of characters**: `419`

