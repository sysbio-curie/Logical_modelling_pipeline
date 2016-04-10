rm(list=ls())
setwd("C:/Users/Arnau/Documents/Cancer/manuscrits/protocol manuscript/Hamming distance/")

ratio <- read.delim("./hist_ratio.txt")
log2 <- read.delim("./hist_log2.txt")
log10 <- read.delim("./hist_log10.txt")

require(ggplot2)
require(scales)

## Histogram
# Metastasis
ggplot(ratio, aes(x = Metastasis)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")
ggplot(log10, aes(x = Metastasis)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency by log10", y = "log10 Percent")
ggplot(log2, aes(x = Metastasis)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")

# nil
ggplot(ratio, aes(x = nil)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")
ggplot(log10, aes(x = nil)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")
ggplot(log2, aes(x = nil)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")

# Apoptosis
p<-ggplot(ratio, aes(x = Apoptosis)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")
p
ggplot(log10, aes(x = Apoptosis)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")
ggplot(log2, aes(x = Apoptosis)) + geom_histogram(bins = 20, fill="grey", col="white",aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")

## Violin plot
# ratio_2 <- ratio[c(10:73)]
library(reshape2)
pheno <- c("Metastasis", "Apoptosis", "nil", "CellCycleArrest")
ratio_3 <- ratio[pheno]
ratio_4 <- melt(ratio_3)
ggplot(ratio_4, aes(x=factor(variable), value)) + 
  geom_hline(yintercept=1, colour='red') + 
  geom_violin() +
  labs(title = "Phenotype frequencies by ratio", y = "mutant/WT ratio", x= NULL)

log10_2 <- melt(log10[pheno])
ggplot(log10_2, aes(x=factor(variable), value)) + 
  geom_hline(yintercept=0, colour='red') + 
  geom_violin() +
#   geom_violin(adjust = .001) + # hi ha menys smoothening
  labs(title = "Phenotype frequencies by log10", y = "mutant/WT log10", x= NULL)

ggplot(log10_2, aes(x=factor(variable), y=value, fill = variable, colour = variable)) + 
  geom_hline(yintercept=0, colour='black') + 
  geom_violin(alpha=0.7, trim = TRUE, 
              width=.9, adjust = 0.55, # adjust: the bandwidth used is actually adjust*bw. This makes it easy to specify values like ‘half the default’ bandwidth
              scale = "area", # all violins have the same area (before trimming the tails)
              # width=1, adjust = 1, # adjust: the bandwidth used is actually adjust*bw. This makes it easy to specify values like ‘half the default’ bandwidth
#             scale = "count", # areas are scaled proportionally to the number of observations
#             scale = "width", # all violins have the same maximum width
            kernel="rectangular")+ # "gaussian", "rectangular", "triangular", "epanechnikov", "biweight", "cosine" or "optcosine",
#              kernel="optcosine")+ # "gaussian", "rectangular", "triangular", "epanechnikov", "biweight", "cosine" or "optcosine",
  scale_colour_manual(values = c("orange", "brown", "forestgreen", "blue")) + 
  scale_fill_manual(values = c("orange", "brown", "forestgreen", "blue")) +
#   theme(panel.grid.minor.x = element_line(colour = "red", linetype = "dotted")) +
  labs(title = "Phenotype frequencies by log10", y = "mutant/WT log10", x= NULL) + 
  theme(legend.position="none")

log2_2 <- melt(log2[pheno])
ggplot(log2_2, aes(x=factor(variable), y=value)) + 
  geom_hline(yintercept=0, colour='red') + 
  geom_violin()+
  labs(title = "Phenotype frequencies by log2", y = "mutant/WT log2", x= NULL)

ggplot(log2_2, aes(x=factor(variable), y=value, fill = variable, colour = variable)) + 
  geom_hline(yintercept=0, colour='black') + 
  geom_violin(alpha=0.7, width=.9, trim = TRUE, scale = "width", adjust = 0.5)+
  scale_colour_manual(values = c("orange", "brown", "forestgreen", "blue")) + 
  scale_fill_manual(values = c("orange", "brown", "forestgreen", "blue")) +
  labs(title = "Phenotype frequencies by log2", y = "mutant/WT log2", x= NULL)+ 
  theme(legend.position="none")

## Geom_bar different for pos and neg
dat <- log10_2
dat1 <- subset(dat,value >= 0)
dat2 <- subset(dat,value < 0)

# counts
ggplot() + 
  geom_hline(yintercept=0, colour='black')+ 
  geom_bar(data = dat1, alpha=0.7, aes(x=variable, y=value),stat = "identity", fill='blue') +
  geom_bar(data = dat2, alpha=0.7, aes(x=variable, y=value),stat = "identity", fill='brown') + 
  labs(title = "Phenotype counts", y = "log10 counts")

# frequencies
ggplot() + 
  geom_hline(yintercept=0, colour='black')+ 
  geom_bar(data = dat1, alpha=0.7, aes(x=variable, y=value/sum(value)),stat = "identity", fill='blue') +
  geom_bar(data = dat2, alpha=0.7, aes(x=variable, y=-value/sum(value)),stat = "identity", fill='brown') + 
  scale_y_continuous(labels=percent) + 
  labs(title = "Phenotype frequency", y = "log10 percent", x= NULL)

# hist (as.matrix(a), breaks = 100)
# hist (as.matrix(m))
# hist (as.matrix(ratio$Metastasis))
# hist (as.matrix(log2$Metastasis))
# hist (as.matrix(log10$Metastasis))
# hist (as.matrix(log10$Metastasis),freq=FALSE) # total area of hist is 1
# with percentages:
# h = hist (as.matrix(log10$Metastasis))
# h = hist(x)
# h$density = h$counts/sum(h$counts)*100
# plot(h,freq=FALSE,ylab='Percentage')
# also :
# ggplot(log10, aes(x = Metastasis)) + geom_bar(aes(y = (..count..)/sum(..count..))) + scale_y_continuous(labels=percent) + labs(title = "Phenotype frequency", y = "Percent")