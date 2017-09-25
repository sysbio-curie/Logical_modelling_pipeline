#!/usr/bin/env Rscript
rm(list=ls(all=TRUE)) 
setwd(dir = "/home/rstudio/data/scripts/run all analyses/7 Analyses of logical gates/")

# import data ----
a1<-read.table("./projectname.xls", header = TRUE, sep="\t", row.names = 1, stringsAsFactors=FALSE)
a2<-a1[,-c(2:7,ncol(a1))]
colnames(a2)[2]<-"HS"
rownames(a2)<-sub("^_WT","WT",rownames(a2),perl = F)
rownames(a2)<-sub("__projectname","",rownames(a2),perl = F)

b1<-read.delim("./projectname_dist_mutants_Hamming.txt", header = T)
rownames(b1)<-b1$FP_ID
cols<-c(1:3,5:36,ncol(b1))
b2<-b1[,-c(cols)]
b3<-b2[-c(1:9),]
b3$Dist_to_WT<-as.numeric(levels(b3$Dist_to_WT))[b3$Dist_to_WT]

c1 <- read.table("./projectname_probtraj_table.csv", header = TRUE, sep="\t", stringsAsFactors=FALSE)
c1 <- c1[,-ncol(c1)]
c2 <- c1[,!grepl("Err.*",colnames(c1))]
colnames(c2) <- gsub("\\.\\.","-",gsub("\\.$","", gsub("\\.nil\\.","HS", gsub("^Prob.","", colnames(c2)))))
c3 <- as.data.frame(t(c2[,4:ncol(c2)]))
c4 <- as.data.frame(t(c3[ order(-c3[,ncol(c3)]), ]))
c5 <- colnames(c4[,1:4])

# Analyses on stable states ----
library(ggplot2)
library(scales)

b4<-unique(b3)
## overall stable states:
ggplot(b4, aes(y = COUNT,x=Dist_to_WT)) + geom_point() + scale_x_continuous(breaks=seq(0,12,1)) + labs(x = "Distance to closest WT stable state",y = "Total counts") + theme(panel.grid.minor.x = element_blank())
## analysing counts and Dist_to_WT of all the stables of all the mutants
# allSS<-b4[c(1:3)]
# allSSsum<-aggregate(COUNT ~ Dist_to_WT, data = allSS, sum)
# allSSsum$Percentage <- round(allSSsum$COUNT / sum(allSSsum$COUNT) * 100,4)
# allSSsum

## unique stable states:
ggplot(b4, aes(x = Dist_to_WT)) + geom_histogram(stat="count",bins = 30, col="white") + labs(x = "Distance to closest WT stable state of unique stable states",y = "Counts")+ theme(panel.grid.minor = element_blank()) + scale_x_continuous(breaks=seq(0,12,1))
# ggplot(b4, aes(x = Dist_to_WT)) + geom_histogram(stat="count",bins = 30, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + scale_x_continuous(breaks=seq(0,12,1)) + labs(x = "Distance to closest WT stable state of unique stable states",y = "Percentage")+ theme(panel.grid.minor = element_blank())
# uniqueSSsum<-as.data.frame(table(b4$Dist_to_WT))
# uniqueSSsum$Percentage <- round(uniqueSSsum$Freq / sum(uniqueSSsum$Freq) * 100,4)
# uniqueSSsum

## looking at the WT stable states by closest to mutants stable states
b5<-as.data.frame(table(b3$Closest_WT))
b5<-b5[-c(nrow(b5)),]
ggplot(b5, aes(Var1,Freq)) + geom_bar(stat = "identity") + labs(x = "WT stable states",y = "Counts")
# ggplot(b5, aes(Var1,Freq)) + geom_bar(stat="identity",col="white",aes(y = (b5$Freq)/sum(b5$Freq))) + scale_y_continuous(labels=percent) + labs(x = "WT stable states",y = "Percentage")
dev.off()

# Histogram on genetic interactions ----
library(ggplot2)
library(scales)

a4<-a2[,-c(1)]
colnames(a4)<-gsub(".","-",colnames(a4),fixed = T)
WT<-a4[which(rownames(a4)=="WT"),]
ratio<-scale(as.matrix(a4), center=FALSE, scale=as.matrix(WT))
ratio<-as.data.frame(ratio[order(rownames(ratio)), ])
# ratio_1<-scale(as.matrix(a4+1), center=FALSE, scale=as.matrix(WT+1))
# ratio_1<-as.data.frame(ratio_1[order(rownames(ratio_1)), ])
# resta<- as.data.frame(sweep(as.matrix(a4),2,as.matrix(WT)))

## draw histograms of ratio (mutant / WT)
pdf("Logical_gates_ratio_histograms_phenotypes_most_probable.pdf",onefile=T)
for (i in c5){
  # print(i)
  ag<-ggplot_build(ggplot(ratio, aes(x =  ratio[,i])) + geom_histogram())
  col <- rep("grey", 30)
  col[findInterval((ratio[(which(rownames(ratio)=="WT")),])[,i], ag$data[[1]]$xmin)]<-"dark red"
  print(ggplot(ratio, aes(x = ratio[,i])) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = paste0(i," phenotype ratio logical gate mutant / WT"), y = "Percentage"))
        # print(ggplot(ratio, aes(x = ratio[,i])) + geom_histogram(bins = 30, fill=col, col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent,breaks = pretty_breaks(10)) + scale_x_continuous(labels=comma,breaks = pretty_breaks(10)) +labs(x = paste0(i," phenotype ratio mutant / WT"), y = "Percentage"))
}
dev.off()

