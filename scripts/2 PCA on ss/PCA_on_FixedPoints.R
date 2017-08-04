rm(list=ls())
setwd(dir = "~/data/scripts/2 PCA on ss/")
# comment when appropiate:
# option a) for .FP files (MaBoSS on Cygwin used with PlMaBoSS_2.0.pl
FP <- read.table(text=(gsub("#", "FP", readLines("./ginsimout.FP"))),sep='\t',row.names = 1,skip=2,header=T,stringsAsFactors= F)
FP2<-FP[,-c(1)]

# option b) for _fp.csv files (MaBoSS on UNIX and MaBoSS on Cygwin used withOUT PlMaBoSS_2.0.pl)
# FP <- read.table(text=(gsub("#", "FP", readLines("./ginsimout_fp.csv"))),sep='\t',row.names = 1,skip=1,header=T,stringsAsFactors= F)
# FP2<-FP[,-c(1,2)]


# - Default FactoMineR graphs
# if(!require(FactoMineR)) {
#   install.packages("FactoMineR"); 
#   require(FactoMineR)}
# result <- PCA(FP2)

# - Merging variable and individuals factor map
# Adapted from ggFactoPlot.R - Plotting the output of FactoMineR's PCA using ggplot2, credit to benmarwick: https://gist.github.com/benmarwick/2139672
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
grid.arrange(p,pv2,nrow=1)

# merging FP of same phenotypes and vectors --after a first plot has been made and results analysed
# enlarging vectors (may need tinkering):
vPCs2<-vPCs*3
pv3 <- p +
  geom_text_repel(data=vPCs2, aes(x=vPCs2$PC1,y=vPCs2$PC2,label=rownames(vPCs2)), size=4, colour="black", box.padding = unit(0.05, "lines"),segment.color=NA) +
  geom_segment(data=vPCs2, aes(x = 0, y = 0, xend = vPCs2$PC1, yend = vPCs2$PC2), arrow = arrow(length = unit(1/2, 'picas')), colour = "grey60") +
  theme(legend.justification=c(1, 0), legend.position=c(1, 0), legend.title =element_text(size = 15), legend.text =element_text(size = 12)  )
pv3

# merging FP of same phenotypes and vectors --after a first plot has been made and results analysed
# enlarging vectors:
vPCs2<-vPCs*5
# adding Phenotypes once we have studied the results:
PCs$Pheno<-"HS"
PCs$Pheno[2:5]<-"Apoptosis"
PCs$Pheno[6:7]<-"EMT"
PCs$Pheno[8:9]<-"Metastasis"

centroids <- aggregate(cbind(PC1,PC2)~Pheno,PCs,mean)
theta <- seq(-pi, pi, length = 200)
circ_hs <- data.frame(
  xv = centroids[centroids$Pheno=="HS",2] + .7 * cos(theta), 
  yv = centroids[centroids$Pheno=="HS",3] + .5 * sin(theta),
  Pheno=centroids[centroids$Pheno=="HS",1])
circ_apop <- data.frame(
  xv = centroids[centroids$Pheno=="Apoptosis",2] + 1.2 * cos(theta), 
  yv = centroids[centroids$Pheno=="Apoptosis",3] + 1.5 * sin(theta),
  Pheno=centroids[centroids$Pheno=="Apoptosis",1])
circ_emt <- data.frame(
  xv = centroids[centroids$Pheno=="EMT",2] + 1 * cos(theta), 
  yv = centroids[centroids$Pheno=="EMT",3] + .7 * sin(theta),
  Pheno=centroids[centroids$Pheno=="EMT",1])
circ_metas <- data.frame(
  xv = centroids[centroids$Pheno=="Metastasis",2] + 1 * cos(theta), 
  yv = centroids[centroids$Pheno=="Metastasis",3] + .7 * sin(theta),
  Pheno=centroids[centroids$Pheno=="Metastasis",1])

p2 <- ggplot() + theme_bw(base_size = 20) + 
  geom_polygon(data = circ_hs, aes(x = xv, y = yv,colour=Pheno,fill=Pheno),size = 1, alpha=0.1) + 
  geom_polygon(data = circ_apop, aes(x = xv, y = yv,colour=Pheno,fill=Pheno),size = 1, alpha=0.1) +
  geom_polygon(data = circ_emt, aes(x = xv, y = yv,colour=Pheno,fill=Pheno),size = 1, alpha=0.1) +
  geom_polygon(data = circ_metas, aes(x = xv, y = yv,colour=Pheno,fill=Pheno),size = 1, alpha=0.1) +
  geom_text_repel(data=PCs, aes(x=PC1,y=PC2,label=rownames(PCs),colour=Pheno), size=4,segment.color=NA) +
  scale_colour_brewer(palette = "Set1", guide = FALSE) +
  scale_fill_brewer(palette = "Set1","Phenotypes") +
  xlab(paste("PC1 ",round(res.pca$eig[1,2],digits = 2),"%",sep = "")) +
  ylab(paste("PC2 ",round(res.pca$eig[2,2],digits = 2),"%",sep = "")) +
  theme(axis.title.x = element_text(size = 15),axis.title.y = element_text(size = 15))

# adding vectors to have one single graph:
pv <- p2 +
  geom_text_repel(data=vPCs2, aes(x=vPCs2$PC1,y=vPCs2$PC2,label=rownames(vPCs2)), size=4, colour="black", box.padding = unit(0.05, "lines"),segment.color=NA) +
  geom_segment(data=vPCs2, aes(x = 0, y = 0, xend = vPCs2$PC1, yend = vPCs2$PC2), arrow = arrow(length = unit(1/2, 'picas')), colour = "grey60") +
  theme(legend.justification=c(1, 0), legend.position=c(1, 0), legend.title =element_text(size = 15), legend.text =element_text(size = 12)  )
pv

png("PCA_epistasis.png",width=800,height=720,res=100)
pv
dev.off()
