#!/usr/bin/env Rscript
rm(list=ls())
setwd(dir = "/home/rstudio/data/scripts/run all analyses/2 PCA on ss/")


FP <- read.table(text=(gsub("#", "FP", readLines("./projectname_fp.csv"))),sep='\t',row.names = 1,skip=1,header=T,stringsAsFactors= F)
FP2<-FP[,-c(1,2)]


# - Merging variable and individuals factor map
# Adapted from ggFactoPlot.R - Plotting the output of FactoMineR's PCA using ggplot2, credit to benmarwick: https://gist.github.com/benmarwick/2139672
list.of.packages <- c("FactoMineR", "ggplot2", "scales", "grid", "plyr", "gridExtra", "ggrepel", "RColorBrewer")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(FactoMineR)
library(ggplot2)
library(scales)
library(grid)
library(plyr)
library(gridExtra)
library(ggrepel)
library(RColorBrewer)

# compute PCA
res.pca <- PCA(FP2, graph = FALSE)

# extract some parts for plotting
PC1 <- res.pca$ind$coord[,1]
PC2 <- res.pca$ind$coord[,2]
labs <- rownames(res.pca$ind$coord)
PCs <- data.frame(cbind(PC1,PC2))
rownames(PCs) <- labs

# Now do extract variables
vPC1 <- res.pca$var$coord[,1]
vPC2 <- res.pca$var$coord[,2]
vlabs <- rownames(res.pca$var$coord)
vPCs <- data.frame(cbind(vPC1,vPC2))
rownames(vPCs) <- vlabs
colnames(vPCs) <- colnames(PCs)

# two graphs side by side:
p <- ggplot() + theme_bw(base_size = 20)
p <- p +
  geom_text_repel(data=PCs, aes(x=PC1,y=PC2,label=rownames(PCs)), size=4, colour="dark red",segment.color=NA)
pv2 <- ggplot() + theme_bw(base_size = 20) 
angle <- seq(-pi, pi, length = 50) 
df <- data.frame(x = sin(angle), y = cos(angle)) 
pv2 <- pv2 + geom_path(aes(x, y), data = df, colour="grey70") 
pv2 <- pv2 + geom_text_repel(data=vPCs, aes(x=vPC1,y=vPC2,label=rownames(vPCs)), size=4,segment.color=NA) + xlab("PC1") + ylab("PC2")
pv2 <- pv2 + geom_segment(data=vPCs, aes(x = 0, y = 0, xend = vPC1*0.9, yend = vPC2*0.9), arrow = arrow(length = unit(1/2, 'picas')), color = "grey30")
# Now put them side by side
# grid.arrange(p,pv2,nrow=1)

# merging FP of same phenotypes and vectors --after a first plot has been made and results analysed
# enlarging vectors (may need tinkering):
vPCs2<-vPCs*3
pv3 <- p +
  geom_text_repel(data=vPCs2, aes(x=vPCs2$PC1,y=vPCs2$PC2,label=rownames(vPCs2)), size=4, colour="black", box.padding = unit(0.05, "lines"),segment.color=NA) +
  geom_segment(data=vPCs2, aes(x = 0, y = 0, xend = vPCs2$PC1, yend = vPCs2$PC2), arrow = arrow(length = unit(1/2, 'picas')), colour = "grey60") +
  theme(legend.justification=c(1, 0), legend.position=c(1, 0), legend.title =element_text(size = 15), legend.text =element_text(size = 12)  )
pv3

