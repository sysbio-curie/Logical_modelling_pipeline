#!/usr/bin/env Rscript
rm(list=ls(all=TRUE)) 
#setwd(dir = "/home/rstudio/data/scripts/run all analyses/3 Displaying asymptotic solutions/")

list.of.packages <- c("ggplot2", "reshape2", "scales")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

a1 <- read.table("./projectname_probtraj_table.csv", header = TRUE, sep="\t", stringsAsFactors=FALSE)
a1 <- a1[,-ncol(a1)]
a2 <- a1[,!grepl("Err.*",colnames(a1))]
colnames(a2) <- gsub("\\.\\.","-",gsub("\\.$","", gsub("\\.nil\\.","HS", gsub("^Prob.","", colnames(a2)))))

a3 <- as.data.frame(t(a2[,4:ncol(a2)]))
a4 <- as.data.frame(t(a3[ order(-a3[,ncol(a3)]), ]))
a5 <- cbind(a2[,1:3],a4)

# temporal evolution ----
library(ggplot2)
library(reshape2)

# general look of the data
a7<- melt(a5[,-c(2,3)],id=c("Time"))
ggplot(a7, aes(x=Time,y=value,color=variable)) + 
  geom_line() + 
  ylab("Phenotype probablity") +
  theme(legend.position="none")

a8<- melt(a5[,c(1,4:7)],id=c("Time"))
ggplot(a8, aes(x=Time,y=value,color=variable)) + 
  geom_line() + 
  ylab("Phenotype probablity")+
  theme(legend.justification=c(1,1), legend.position=c(1,1))


# pie chart of last time tick ----
library(ggplot2)
library(scales)

pie_data<-as.data.frame(t(a5[nrow(a5),4:7]))
pie_data$ord<-rownames(pie_data)

pie<-ggplot(pie_data,aes(x="", y=pie_data[,1],fill=ord,order= ord))+ 
  geom_bar(width=1,stat = "identity")+
  coord_polar("y")+
  geom_text(aes(label = percent(pie_data[,1])), size=5,position = position_stack(vjust = .5)) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) +
  theme(axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title= element_blank(),
        panel.grid=element_blank(),
        legend.position = "bottom",legend.title = element_blank() )
pie
