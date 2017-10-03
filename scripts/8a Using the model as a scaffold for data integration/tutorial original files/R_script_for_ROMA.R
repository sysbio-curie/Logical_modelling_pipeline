#install.packages("readr")
#install.packages("devtools")
#devtools::install_github("Albluca/rROMA")

library(readr)
library(rRoma)
library(pheatmap)

data_colon <- read_delim("./data_EMT_sorted.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
Exp_colon <- data_colon[,-1]
rownames(Exp_colon) <- unlist(data_colon[,1])

Groups <- read_delim("./response.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
#rownames(Groups) <- unlist(Groups[,1])
GroupVect <- unlist(Groups$responder)
names(GroupVect) <- unlist(Groups$patients)
table(GroupVect)

Modules <- read_delim("./modular_model.gmt.txt", "\t", escape_double = FALSE, trim_ws = TRUE)


Data.colon <- rRoma.R(ExpressionMatrix = Exp_colon, centerData = TRUE, ExpFilter = FALSE,
                      ApproxSamples = 4, ModuleList = Modules, MinGenes = 8,
                      MaxGenes = 1000, nSamples = 100, UseWeigths = FALSE,
                      DefaultWeight = 1, FixedCenter = FALSE,
                      GeneOutDetection = 'L1OutExpOut', GeneOutThr = 4,
                      GeneSelMode = "All", SampleFilter = TRUE, MoreInfo = FALSE,
                      PlotData = FALSE, PCSignMode = "CorrelateAllWeightsByGene", OutGeneNumber = 5,
                      Ncomp = 100, OutGeneSpace = 5, PCADims = 5, PCSignThr = NULL,
                      UseParallel = TRUE, nCores = 3, ClusType = "FORK",
                      SamplingGeneWeights = NULL, Grouping = GroupVect,
                      FullSampleInfo = FALSE, GroupPCSign = FALSE)


# Plot genesets
Agg.colon <- Plot.Genesets(RomaData = Data.colon, Selected = SelectGeneSets(RomaData = Data.colon, VarThr = 5e-2, VarMode = "Wil", VarType = "Over"), GenesetMargin = 14, SampleMargin = 14, 
                           cluster_cols = F, GroupInfo = GroupVect, AggByGroupsFL = c("mean"))

# Visualize scores for all samples for all selected pathways
pheatmap(Agg.colon$mean, color = colorRampPalette(c("blue3", "white", "red3"))(50), fontsize_row=5, cluster_cols=FALSE, cluster_rows=T)
dev.copy2pdf(file = "colon_response.pdf")

# Visualiza scores for all groups for all selected pathways

Selected = SelectGeneSets(RomaData = Data.colon, VarThr = 5e-2, VarMode = "Wil", VarType = "Over")
Select_samples <- Data.colon$SampleMatrix[Selected,]
pheatmap(Select_samples, color = colorRampPalette(c("blue3", "white", "red3"))(50), fontsize_row=5, cluster_cols=FALSE, cluster_rows=T)
dev.copy2pdf(file = "colon_response_all_samples.pdf")


