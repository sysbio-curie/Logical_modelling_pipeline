rm(list=ls(all=TRUE)) 
setwd(dir = "~/data/scripts/5 Analyses of genetic interactions/")
# import data ----
a1<- read.table("./ginsimout_norm.xls", header = TRUE, sep="\t", row.names = 1, stringsAsFactors=FALSE)
a2<-a1[,-c(2:5,ncol(a1))]
colnames(a2)[2]<-"HS"
colnames(a2)<-gsub(".","-", colnames(a2),fixed = T)
rownames(a2)<-sub("^_","WT",rownames(a2),perl = F)
rownames(a2)<-sub("__","-",rownames(a2),perl = F)

# PCA on genetic interactions ----
# Adapted from ggFactoPlot.R - Plotting the output of FactoMineR's PCA using ggplot2, credit to benmarwick
# https://gist.github.com/benmarwick/2139672
library(FactoMineR)
library(ggplot2)
library(ggrepel)

# - all phenotypes
# a3<-a2
# - only single phenotypes
# a3<-a2[,!grepl("-", colnames(a2),fixed=T)]

# following two options are specific to Cohen et al's model
# - 4 combined phenotypes
pattern <- c("^TYPE","^Apoptosis-CellCycleArrest$","^Migration-Metastasis-Invasion-EMT-CellCycleArrest$","^HS$","^EMT-CellCycleArrest$")
a3 <- a2[,(grep(paste(pattern,collapse="|"), colnames(a2), value=TRUE))]
# - single phenotypes + 4 combined phenotypes
# pattern <- c("^Apoptosis-CellCycleArrest$","^Migration-Metastasis-Invasion-EMT-CellCycleArrest$","^HS$","^EMT-CellCycleArrest$")
# a3<-cbind(a2[,!grepl("-", colnames(a2),fixed=T)],a2[,(grep(paste(pattern,collapse="|"), colnames(a2), value=TRUE))])
# a3<- a3[, !duplicated(colnames(a3))]

# compute PCA
res.pca <- PCA(a3, quali.sup=1)

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
PCcat[(PCcat$TYPE=="SINGLE" & (PCcat$PC1>1 | PCcat$PC2>1 | PCcat$PC1 <= -1 | PCcat$PC2<= -1)),]
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
  scale_y_continuous(limits=c(-6, 6)) +
  ylab("PC2_WTcentered") + xlab("PC1_WTcentered") 
p

# - following is to make the figure of Cohen et al's single phenotypes:
# doing legend:
D<-subset(PCcat, TYPE=="DOUBLE")
S<-subset(PCcat, TYPE=="SINGLE")
W<-subset(PCcat, TYPE=="WT")
S2<-S[-3]
Slabel<- subset(S2, PC1>1 | PC2>1 | PC1 <= -1 | PC2<= -1)
PCcat[(PCcat$TYPE=="SINGLE" & (PCcat$PC1>1 | PCcat$PC2>1 | PCcat$PC1 <= -1 | PCcat$PC2<= -1)),]
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
  scale_y_continuous(limits=c(-6, 6)) +
  ylab("PC2_WTcentered") + xlab("PC1_WTcentered") + 
  theme(axis.title.x = element_text(size = 15, vjust=-.2, hjust = .82),axis.title.y = element_text(size = 15, vjust=0.3),legend.justification=c(0.97, 0.97), legend.position=c(0.97, 0.97))
p

p2<-ggplot()+ theme_bw(base_size = 20) +
  geom_point(aes(x=PCcat3[PCcat3$TYPE=="DOUBLE",][1,]$PC1,y=PCcat3[PCcat3$TYPE=="DOUBLE",][1,]$PC2, colour="DOUBLE"),size=4)+
  scale_colour_manual(name="Mutants",values=cols) +
  scale_x_continuous(limits=c(35), breaks = c(35)) +
  scale_y_continuous(limits=c(-6, 6)) +
  coord_fixed(ratio = 1) +
  theme(legend.position="none",axis.title.x = element_blank(), axis.title.y = element_blank(),axis.ticks.y = element_blank(),axis.text.y=element_blank(),plot.margin = unit(c(1,1,1,-10), "lines"))
p2
p3<-ggplot()+ theme_bw(base_size = 20) +
  geom_point(aes(x=PCcat3[PCcat3$TYPE=="DOUBLE",][2,]$PC1,y=PCcat3[PCcat3$TYPE=="DOUBLE",][2,]$PC2, colour="DOUBLE"),size=4)+
  scale_colour_manual(name="Mutants",values=cols) +
  scale_x_continuous(limits=c(17), breaks = c(17)) +
  scale_y_continuous(limits=c(-6, 6)) +
  coord_fixed(ratio = 1) +
  theme(legend.position="none",axis.title.x = element_blank(), axis.title.y = element_blank(),axis.ticks.y = element_blank(),axis.text.y=element_blank(),plot.margin = unit(c(1,1,1,-3), "lines"))
p3
dev.off()

# - following is to make the figure of Cohen et al's complex phenotypes:
radius<-1

# looking for highlight certain epistatic pairs: AKT2 gain of function with SNAI1, SNAI2 and TWIST1 gain of functions and NICD gain of function with SMAD, SNAI1 and TGFbeta gain of functions
# SNAI1_oe__AKT2_oe, SNAI2_oe__AKT2_oe, TWIST1_oe__AKT2_oe, SMAD_oe__NICD_oe, SNAI1_oe__NICD_oe, TGFbeta_oe__NICD_oe
pattern<-c("SNAI1_oe-AKT2_oe", "SNAI2_oe-AKT2_oe", "TWIST1_oe-AKT2_oe", "NICD_oe-SMAD_oe", "SMAD_oe-NICD_oe", "SNAI1_oe-NICD_oe", "TGFbeta_oe-NICD_oe")
epistatic_pairs <- PCcat[grepl(paste0(pattern,collapse = "|"), rownames(PCcat)),]
epistatic_pairs$col<-"grey40"
pattern<-c("^TGFbeta_oe$","^NICD_oe$","^SMAD_oe$")
S<-unique(rbind(PCcat[PCcat$TYPE=="SINGLE" & (PCcat$PC1>radius | PCcat$PC1 <= -radius) & (PCcat$PC2>radius | PCcat$PC2<= -radius),],PCcat[grepl(paste0(pattern,collapse = "|"), rownames(PCcat)),]))
S$col<-"dark red"
S_epis<-rbind(S,epistatic_pairs)

p<-ggplot()+ theme_bw(base_size = 20) +
  geom_point(aes(x=PCcat[PCcat$TYPE=="DOUBLE",]$PC1,y=PCcat[PCcat$TYPE=="DOUBLE",]$PC2, colour="DOUBLE"),size=4)+
  geom_point(aes(x=PCcat[PCcat$TYPE=="SINGLE",]$PC1,y=PCcat[PCcat$TYPE=="SINGLE",]$PC2, colour="SINGLE"),size=4)+
  geom_text_repel(data=vPCs2, aes(x=vPCs2$PC1,y=vPCs2$PC2,label=c("HS","Apoptosis\n--CellCycleArrest","EMT\n--CellCycleArrest","Migration--Metastasis\n--Invasion--EMT\n--CellCycleArrest")), size=5, colour="black",segment.color=NA)+
  geom_text_repel(data=S_epis, aes(x=S_epis$PC1,y=S_epis$PC2,label=rownames(S_epis)), size=4.7, colour=S_epis$col,min.segment.length = unit(0, "lines"))+
    geom_segment(data=vPCs2, aes(x = 0, y = 0, xend = vPCs2$PC1, yend = vPCs2$PC2), arrow = arrow(length = unit(1/2, 'picas')), color = "grey30") +
  geom_point(aes(x=PCcat[PCcat$TYPE=="WT",]$PC1,y=PCcat[PCcat$TYPE=="WT",]$PC2, colour="WT"),size=4) +
  scale_colour_manual(name="Mutants",values=cols) +
  ylab("PC2_WTcentered") + xlab("PC1_WTcentered") +
  theme(axis.title.x = element_text(size = 15),axis.title.y = element_text(size = 15),legend.justification=c(0.97, 0.97), legend.position=c(0.97, 0.97))
p

png("PCA_on_genetic_interactions_CombinedPhe.png", width = 12, height = 10, units = 'in', res = 400)
p
dev.off()

# cowplot
library(cowplot)
png("PCA_on_genetic_interactions_PurePhe.png", width = 12, height = 10, units = 'in', res = 400)
plot_grid(p,p3,p2, ncol = 3, align = 'h',rel_widths = c(5,1,1))
dev.off()

# Histogram on genetic interactions per phenotypes ----
library(ggplot2)
library(scales)

a4<-a2[,-c(1)]
WT<-a4[which(rownames(a4)=="WT"),]
  
ratio<-scale(as.matrix(a4), center=FALSE, scale=as.matrix(WT))
ratio<-as.data.frame(ratio[order(rownames(ratio)), ])
ratio_1<-scale(as.matrix(a4+1), center=FALSE, scale=as.matrix(WT+1))
ratio_1<-as.data.frame(ratio_1[order(rownames(ratio_1)), ])

## draw histograms
pdf("Epistasis_ratio_phenotypes_histograms.pdf",onefile=T)
# HS
ag<-ggplot_build(ggplot(ratio, aes(x = HS)) + geom_histogram())
col <- rep("grey", 30)
col[findInterval((ratio[(which(rownames(ratio)=="WT")),])$HS, ag$data[[1]]$xmin)]<-"dark red"
ggplot(ratio, aes(x = HS)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = "Homeostatic phenotype ratio mutant / WT", y = "Percentage")

# Invasion/EMT/CellCycleArrest -- is 0 in WT
# ag<-ggplot_build(ggplot(ratio, aes(x = Invasion.EMT.CellCycleArrest)) + geom_histogram())
# col <- rep("grey", 30)
# col[findInterval((ratio[(which(rownames(ratio)=="WT")),])$Invasion.EMT.CellCycleArrest, ag$data[[1]]$xmin)]<-"dark red"
# ggplot(ratio, aes(x = Invasion.EMT.CellCycleArrest)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = "Invasion/EMT/CellCycleArrest phenotype ratio mutant / WT", y = "Percentage")

# Apoptosis.CellCycleArrest
ag<-ggplot_build(ggplot(ratio, aes(x = Apoptosis.CellCycleArrest)) + geom_histogram())
col <- rep("grey", 30)
col[findInterval((ratio[(which(rownames(ratio)=="WT")),])$Apoptosis.CellCycleArrest, ag$data[[1]]$xmin)]<-"dark red"
ggplot(ratio, aes(x = Apoptosis.CellCycleArrest)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = "Apoptosis/CellCycleArrest phenotype ratio mutant / WT", y = "Percentage")

# Migration/Metastasis/Invasion/EMT/CellCycleArrest
ag<-ggplot_build(ggplot(ratio, aes(x = Migration.Metastasis.Invasion.EMT.CellCycleArrest)) + geom_histogram())
col <- rep("grey", 30)
col[findInterval((ratio[(which(rownames(ratio)=="WT")),])$Migration.Metastasis.Invasion.EMT, ag$data[[1]]$xmin)]<-"dark red"
ggplot(ratio, aes(x = Migration.Metastasis.Invasion.EMT.CellCycleArrest)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + labs(x = "Migration/Metastasis/Invasion/EMT/CellCycleArrest phenotype ratio mutant / WT", y = "Percentage")
# finding % of WT bin:
bb<-ggplot_build(ggplot(ratio, aes(x = Migration.Metastasis.Invasion.EMT.CellCycleArrest)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))))
bb$data[[1]]$y[[findInterval((ratio[(which(rownames(ratio)=="WT")),])$Migration.Metastasis.Invasion.EMT.CellCycleArrest, ag$data[[1]]$xmin)]]*100
bb$data[[1]]$y[[1]]*100

metastasis<-ratio[,"Migration.Metastasis.Invasion.EMT.CellCycleArrest",drop=FALSE]
metastasis[rownames(metastasis)=="NICD_oe-AKT2_oe",]
ratio[rownames(ratio)=="NICD_oe-AKT2_oe",]
ratio[rownames(ratio)=="SNAI1_ko-AKT2_oe",]


# EMT.CellCycleArrest
ag<-ggplot_build(ggplot(ratio, aes(x = EMT.CellCycleArrest)) + geom_histogram())
col <- rep("grey", 30)
col[findInterval((ratio[(which(rownames(ratio)=="WT")),])$EMT.CellCycleArrest, ag$data[[1]]$xmin)]<-"dark red"
ggplot(ratio, aes(x = EMT.CellCycleArrest)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = "EMT/CellCycleArrest phenotype ratio mutant / WT", y = "Percentage")

dev.off()

# Close up on Migration.Metastasis.Invasion.EMT.CellCycleArrest top positive and negative ----
bb<-ggplot_build(ggplot(ratio, aes(x = Migration.Metastasis.Invasion.EMT.CellCycleArrest)) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))))
metastasis_hist<-bb$data[[1]]

toppos<-ratio[ratio$Migration.Metastasis.Invasion.EMT.CellCycleArrest>3,]
toppos$node<-rownames(toppos)
ggplot(toppos, aes(x = node, fill=node)) + geom_histogram(stat="count",col="white") +theme(legend.position="none")

top0<-ratio[ratio$Migration.Metastasis.Invasion.EMT.CellCycleArrest==0,]
top0$node<-rownames(top0)
ggplot(top0, aes(x = node, fill=node)) + geom_histogram(stat="count",col="white") + theme(axis.text.x = element_text(angle = 90, hjust = 1),legend.position="none") + labs(x = "Logical combinations that abolish Migration.Metastasis.Invasion.EMT.CellCycleArrest phenotype",y = "Total counts")

