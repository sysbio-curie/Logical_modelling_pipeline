rm(list=ls(all=TRUE)) 
setwd(dir = "~/data/scripts/3 Displaying asymptotic solutions/")

a1 <- read.table("./ginsimout_probtraj_table.csv", header = TRUE, sep="\t", stringsAsFactors=FALSE)
a1 <- a1[,-ncol(a1)]
a2 <- a1[,!grepl("Err.*",colnames(a1))]
colnames(a2) <- gsub("\\.\\.","-",gsub("\\.$","", gsub("\\.nil\\.","HS", gsub("^Prob.","", colnames(a2)))))
# colnames(a2) <- sub("..","--",colnames(a2),fixed = T)

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
  ylab("Phenotype probablity") 

# focusing on some variables (generally the ones with higher final probabilities)
a6<-a5[,1:7]
temporal<- ggplot(a6, aes(x=Time)) + 
  geom_path(aes(y = a6[,"Apoptosis-CellCycleArrest"], color=("Apoptosis-CellCycleArrest")),size=2) + 
  geom_path(aes(y = a6[,"Migration-Metastasis-Invasion-EMT-CellCycleArrest"], color=("Migration-Metastasis-Invasion-EMT-CellCycleArrest")),size=2) + 
  geom_path(aes(y = a6[,"HS"], color=("HS")),size=2) + 
  geom_path(aes(y = a6[,"EMT-CellCycleArrest"], color=("EMT-CellCycleArrest")),size=2) + 
  ylab("Phenotype probablity") + 
  scale_color_discrete(name="Phenotypes",breaks=c("Apoptosis-CellCycleArrest","Migration-Metastasis-Invasion-EMT-CellCycleArrest","HS","EMT-CellCycleArrest")) +
  theme(legend.justification=c(0.97, 0.97), legend.position=c(0.97, 0.97))

png("Phenotypes_probability_time_evolution.png", width = 800, height = 800, res = 120)
temporal
dev.off()

# pie chart of last time tick ----
library(ggplot2)
# library(scales)

pie_data<-as.data.frame(t(a5[299,4:7]))
pie_data$ord<-rownames(pie_data)
# if you want to order sectors in the pie chart, by name
# pie_data <- within(pie_data, ord <- factor(ord, levels=c("Apoptosis-CellCycleArrest","Migration-Metastasis-Invasion-EMT-CellCycleArrest","HS","EMT-CellCycleArrest")))

pie<-ggplot(pie_data,aes(x="", y=V299,fill=ord,order= ord))+ 
  geom_bar(width=1,stat = "identity")+
  coord_polar("y")+
  geom_text(aes(label = percent(V299)), size=5,position = position_stack(vjust = .5)) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) +
  theme(axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title= element_blank(),
        panel.grid=element_blank(),
        legend.position = "bottom",legend.title = element_blank() )
# pie

png("Phenotypes_probability_pie_chart.png", width = 800, height = 800, res = 120)
pie
dev.off()

