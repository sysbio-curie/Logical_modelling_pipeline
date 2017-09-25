#!/usr/bin/env Rscript
rm(list=ls(all=TRUE)) 
setwd(dir = "/home/rstudio/data/scripts/run all analyses/5 Analyses of genetic interactions/")

list.of.packages <- c("ggplot2", "FactoMineR", "scales", "ggrepel", "cowplot")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# import data ----
a1<- read.table("./projectname_norm.xls", header = TRUE, sep="\t", row.names = 1, stringsAsFactors=FALSE)
a2<-a1[,-c(2:5,ncol(a1))]
colnames(a2)[2]<-"HS"
colnames(a2)<-gsub(".","-", colnames(a2),fixed = T)
rownames(a2)<-sub("^_","WT",rownames(a2),perl = F)
rownames(a2)<-sub("__","-",rownames(a2),perl = F)

b1 <- read.table("./projectname_probtraj_table.csv", header = TRUE, sep="\t", stringsAsFactors=FALSE)
b1 <- b1[,-ncol(b1)]
b2 <- b1[,!grepl("Err.*",colnames(b1))]
colnames(b2) <- gsub("\\.\\.","-",gsub("\\.$","", gsub("\\.nil\\.","HS", gsub("^Prob.","", colnames(b2)))))
b3 <- as.data.frame(t(b2[,4:ncol(b2)]))
b4 <- as.data.frame(t(b3[ order(-b3[,ncol(b3)]), ]))
# b5 <- colnames(b4[,1:4])


# PCA on genetic interactions ----
# Adapted from ggFactoPlot.R - Plotting the output of FactoMineR's PCA using ggplot2, credit to benmarwick
# https://gist.github.com/benmarwick/2139672
library(FactoMineR)
library(ggplot2)
library(ggrepel)

# - all phenotypes
# a3<-a2
# - only single phenotypes
a3<-a2[,!grepl("-", colnames(a2),fixed=T)]
# - only most probable phenotypes
IntPhe<-c("TYPE",colnames(b4[,1:4]))
a5<-a2[,IntPhe]

## Single phenotypes
# compute PCA
res.pca <- PCA(a3, quali.sup=1, graph = F)

# extract some parts for plotting
PC1 <- res.pca$ind$coord[,1]-res.pca$ind$coord["WT",1]
PC2 <- res.pca$ind$coord[,2]-res.pca$ind$coord["WT",2]
labs <- rownames(res.pca$ind$coord)
PCs <- data.frame(cbind(PC1,PC2))
rownames(PCs) <- labs
# PCs["WT",]

# extract variables
vPC1 <- res.pca$var$coord[,1]
vPC2 <- res.pca$var$coord[,2]
vlabs <- rownames(res.pca$var$coord)
vPCs <- data.frame(cbind(vPC1,vPC2))
rownames(vPCs) <- vlabs
colnames(vPCs) <- colnames(PCs)

# using categories on PCA
PCcat<-merge(PCs, res.pca$call$quali.sup$quali.sup, by="row.names")
rownames(PCcat) <- PCcat$Row.names
PCcat$Row.names <- NULL

# plotting:
cols <- c("DOUBLE"="grey80","SINGLE"="dark red","WT"="orange", "repel"=NA)
vPCs2<-vPCs*6

# - general look of the phenotypes: 
# doing legend:
D<-subset(PCcat, TYPE=="DOUBLE")
S<-subset(PCcat, TYPE=="SINGLE")
W<-subset(PCcat, TYPE=="WT")
S2<-S[-3]
Slabel<- subset(S2, PC1>1 | PC2>1 | PC1 <= -1 | PC2<= -1)
# PCcat[(PCcat$TYPE=="SINGLE" & (PCcat$PC1>1 | PCcat$PC2>1 | PCcat$PC1 <= -1 | PCcat$PC2<= -1)),]
D2<-D[-which.max(D$PC1),]
D2<-D2[-which.max(D2$PC1),]
PCcat2<-PCcat[!(tail(sort(PCcat$PC1),2)[1]==PCcat$PC1 | tail(sort(PCcat$PC1),2)[2]==PCcat$PC1),]
PCcat3<-PCcat[tail(sort(PCcat$PC1),2)[1]==PCcat$PC1 | tail(sort(PCcat$PC1),2)[2]==PCcat$PC1,]
p<-ggplot()+ theme_bw(base_size = 20) +
  geom_point(aes(x=PCcat2[PCcat2$TYPE=="DOUBLE",]$PC1,y=PCcat2[PCcat2$TYPE=="DOUBLE",]$PC2, colour="DOUBLE"),size=4)+
  geom_point(aes(x=PCcat2[PCcat2$TYPE=="SINGLE",]$PC1,y=PCcat2[PCcat2$TYPE=="SINGLE",]$PC2, colour="SINGLE"),size=4)+
  geom_text_repel(data=vPCs2, aes(x=vPCs2$PC1,y=vPCs2$PC2,label=rownames(vPCs2)), size=5, colour="black",segment.color=NA)+
  geom_text_repel(aes(x=PCcat2[(PCcat2$TYPE=="SINGLE" & (PCcat2$PC1>1 | PCcat2$PC2>1 | PCcat2$PC1 <= -1 | PCcat2$PC2<= -1)),]$PC1,y=PCcat2[(PCcat2$TYPE=="SINGLE" & (PCcat2$PC1>1 | PCcat2$PC2>1 | PCcat2$PC1 <= -1 | PCcat2$PC2<= -1)),]$PC2,label=rownames(PCcat2[(PCcat2$TYPE=="SINGLE" & (PCcat2$PC1>1 | PCcat2$PC2>1 | PCcat2$PC1 <= -1 | PCcat2$PC2<= -1)),])), size=4.7, colour="dark red",segment.color=NA) +
  geom_segment(data=vPCs2, aes(x = 0, y = 0, xend = vPCs2$PC1, yend = vPCs2$PC2), arrow = arrow(length = unit(1/2, 'picas')), color = "grey30") +
  geom_point(aes(x=PCcat2[PCcat2$TYPE=="WT",]$PC1,y=PCcat2[PCcat2$TYPE=="WT",]$PC2, colour="WT"),size=4) +
  scale_colour_manual(name="Mutants",values=cols) +
  # scale_y_continuous(limits=c(-6, 6)) +
  theme(legend.justification=c(1,1), legend.position=c(1,1),plot.title = element_text(hjust = 0.5)) +
  labs(title="Single phenotypes", x= "PC1_WTcentered", y = "PC2_WTcentered")
  # ylab("PC2_WTcentered") + xlab("PC1_WTcentered") 
p

## Most probable phenotypes
# compute PCA
res.pca2 <- PCA(a5, quali.sup=1, graph = F)

# extract some parts for plotting
PC1 <- res.pca2$ind$coord[,1]-res.pca2$ind$coord["WT",1]
PC2 <- res.pca2$ind$coord[,2]-res.pca2$ind$coord["WT",2]
labs <- rownames(res.pca2$ind$coord)
PCs <- data.frame(cbind(PC1,PC2))
rownames(PCs) <- labs
# PCs["WT",]

# extract variables
vPC1 <- res.pca2$var$coord[,1]
vPC2 <- res.pca2$var$coord[,2]
vlabs <- rownames(res.pca2$var$coord)
vPCs <- data.frame(cbind(vPC1,vPC2))
rownames(vPCs) <- vlabs
colnames(vPCs) <- colnames(PCs)

# using categories on PCA
PCcat<-merge(PCs, res.pca2$call$quali.sup$quali.sup, by="row.names")
rownames(PCcat) <- PCcat$Row.names
PCcat$Row.names <- NULL

# plotting:
cols <- c("DOUBLE"="grey80","SINGLE"="dark red","WT"="orange", "repel"=NA)
vPCs2<-vPCs*6

# - general look of the phenotypes: 
# doing legend:
D<-subset(PCcat, TYPE=="DOUBLE")
S<-subset(PCcat, TYPE=="SINGLE")
W<-subset(PCcat, TYPE=="WT")
S2<-S[-3]
Slabel<- subset(S2, PC1>1 | PC2>1 | PC1 <= -1 | PC2<= -1)
# PCcat[(PCcat$TYPE=="SINGLE" & (PCcat$PC1>1 | PCcat$PC2>1 | PCcat$PC1 <= -1 | PCcat$PC2<= -1)),]
D2<-D[-which.max(D$PC1),]
D2<-D2[-which.max(D2$PC1),]
PCcat2<-PCcat[!(tail(sort(PCcat$PC1),2)[1]==PCcat$PC1 | tail(sort(PCcat$PC1),2)[2]==PCcat$PC1),]
PCcat3<-PCcat[tail(sort(PCcat$PC1),2)[1]==PCcat$PC1 | tail(sort(PCcat$PC1),2)[2]==PCcat$PC1,]
p2<-ggplot()+ theme_bw(base_size = 20) +
  geom_point(aes(x=PCcat2[PCcat2$TYPE=="DOUBLE",]$PC1,y=PCcat2[PCcat2$TYPE=="DOUBLE",]$PC2, colour="DOUBLE"),size=4)+
  geom_point(aes(x=PCcat2[PCcat2$TYPE=="SINGLE",]$PC1,y=PCcat2[PCcat2$TYPE=="SINGLE",]$PC2, colour="SINGLE"),size=4)+
  geom_text_repel(data=vPCs2, aes(x=vPCs2$PC1,y=vPCs2$PC2,label=rownames(vPCs2)), size=5, colour="black",segment.color=NA)+
  geom_text_repel(aes(x=PCcat2[(PCcat2$TYPE=="SINGLE" & (PCcat2$PC1>1 | PCcat2$PC2>1 | PCcat2$PC1 <= -1 | PCcat2$PC2<= -1)),]$PC1,y=PCcat2[(PCcat2$TYPE=="SINGLE" & (PCcat2$PC1>1 | PCcat2$PC2>1 | PCcat2$PC1 <= -1 | PCcat2$PC2<= -1)),]$PC2,label=rownames(PCcat2[(PCcat2$TYPE=="SINGLE" & (PCcat2$PC1>1 | PCcat2$PC2>1 | PCcat2$PC1 <= -1 | PCcat2$PC2<= -1)),])), size=4.7, colour="dark red",segment.color=NA) +
  geom_segment(data=vPCs2, aes(x = 0, y = 0, xend = vPCs2$PC1, yend = vPCs2$PC2), arrow = arrow(length = unit(1/2, 'picas')), color = "grey30") +
  geom_point(aes(x=PCcat2[PCcat2$TYPE=="WT",]$PC1,y=PCcat2[PCcat2$TYPE=="WT",]$PC2, colour="WT"),size=4) +
  scale_colour_manual(name="Mutants",values=cols) +
  # scale_y_continuous(limits=c(-6, 6)) +
  theme(legend.justification=c(1,1), legend.position=c(1,1),plot.title = element_text(hjust = 0.5)) +
  labs(title="Most probable phenotypes", x= "PC1_WTcentered", y = "PC2_WTcentered")
  # ylab("PC2_WTcentered") + xlab("PC1_WTcentered") 
p2
dev.off()

# Histogram on genetic interactions per phenotypes ----
library(ggplot2)
library(scales)

a4<-a2[,-c(1)]
WT<-a4[which(rownames(a4)=="WT"),]

ratio<-scale(as.matrix(a4), center=FALSE, scale=as.matrix(WT))
ratio<-as.data.frame(ratio[order(rownames(ratio)), ])

pdf("Epistasis_ratio_phenotypes_histograms_most_probable.pdf",onefile=T)
# phe<-colnames(b4[,1:4])
# for (i in phe){
for (i in colnames(b4[,1:4])){
  # print(i)
  ag<-ggplot_build(ggplot(ratio, aes(x =  ratio[,i])) + geom_histogram())
  col <- rep("grey", 30)
  col[findInterval((ratio[(which(rownames(ratio)=="WT")),])[,i], ag$data[[1]]$xmin)]<-"dark red"
  print(ggplot(ratio, aes(x = ratio[,i])) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = paste0(i," phenotype ratio mutant / WT"), y = "Percentage"))
}
dev.off()

