##########################################################
#####    Save 3D rgl plot with a precise orientation
##########################################################

## New session (Ctrl + Shift + F10)
library(rgl)
plot3d(iris) 

## don't zoom
## Move the plot to the best orientation

## Save plot parameters in a list
pp <- par3d(no.readonly=TRUE)

## Save list in a file
dput(pp, file="save 3D rgl plot/View_spec.R", control = "all")

## In a new session (Ctrl + Shift + F10)
library(rgl)

## Recall parameters from file
pp <- dget("save 3D rgl plot/View_spec.R")

## plot
plot3d(iris)
par3d(pp)

## Save the plot
## rgl.snapshot: png
rgl.snapshot("save 3D rgl plot/plot_name.png", fmt = "png")
