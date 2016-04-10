rm(list=ls())
setwd("C:/Users/Arnau/Dropbox/Modelling_Methods_Paper/Tools/4 Analysis of steady states/1 PCA on SS/")
# http://gastonsanchez.com/blog/how-to/2012/06/17/PCA-in-R.html
# https://stat.ethz.ch/R-manual/R-devel/library/stats/html/prcomp.html

tot1<- read.table("ss_for_PCA.txt", header = TRUE, sep="\t", row.names = 1, stringsAsFactors=FALSE)
tot2<- read.table("ss_for_PCA2.txt", header = TRUE, sep="\t", row.names = 1, stringsAsFactors=FALSE)

# 1
fit <- princomp(tot1, cor=TRUE)
summary(fit) # print variance accounted for 
loadings(fit) # pc loadings 
plot(fit,type="lines") # scree plot 
fit$scores # the principal components
biplot(fit)

# 2
library(FactoMineR)
# result <- PCA(tot1) # graphs generated automatically
result <- PCA(tot2) # graphs generated automatically

# 3
library(psych)
pc <- principal(tot1,4,rotate="varimax")
mr <- fa(tot1,4,rotate="varimax")  #minres factor analysis
pa <- fa(tot1,4,rotate="varimax",fm="pa")  # principal axis factor analysis
round(factor.congruence(list(pc,mr,pa)),2)
pc2 <- principal(tot2,2,rotate="varimax",scores=TRUE)
pc2
round(cor(tot1,pc2$scores),2)  #compare these correlations to the loadings 
biplot(pc2,main="Biplot of tot1 variables")

# llevant variables samb tot 0
tot3<-subset(tot2, select=-c(AKT1,CTNNB1,miR34))
pc <- principal(tot3,4,rotate="varimax")
mr <- fa(tot3,4,rotate="varimax")  #minres factor analysis
pa <- fa(tot3,4,rotate="varimax",fm="pa")  # principal axis factor analysis
round(factor.congruence(list(pc,mr,pa)),2)
pc2 <- principal(tot3,2,rotate="varimax",scores=TRUE)
pc2
round(cor(tot3,pc2$scores),2)  #compare these correlations to the loadings 
biplot(pc2,main="Biplot of tot3 variables")

# 5
require(graphics)
prcomp(tot3, scale = TRUE)
plot(prcomp(tot3))
summary(prcomp(tot3, scale = TRUE))
biplot(prcomp(tot3, scale = TRUE))

dev.off()
