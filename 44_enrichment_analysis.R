# Run this function to test for GO term or KEGG pathways enrichment
run_WebGestaltR <- function(
  interestGene, # vector of genes as input
  projectName, # the suffix to which "Project_" is appended
  enrichDatabase, # the data base to query  
  outputDirectory # where to store the results
){
  res <- WebGestaltR(
    enrichDatabase = enrichDatabase, enrichMethod = "ORA",organism = "mmusculus",
    interestGene = interestGene, interestGeneType = "ensembl_gene_id",
    referenceSet = "genome",sigMethod = "fdr",fdrMethod = "BH", fdrThr = 0.1,
    topThr = 100, reportNum = 20, isOutput = TRUE, outputDirectory = outputDirectory,
    hostName = "http://www.webgestalt.org/",projectName = projectName)
  fl_out <- paste0(enrichDatabase,"_sig_results.csv")
  write.csv(res, file.path(outputDirectory,paste0("Project_", projectName),fl_out))
}

# run for each line
lapply(c("DUK","DUC","DU6","DU6P","DUhLB","FERT"), function(l){
  run_WebGestaltR(
    interestGene=RDD_genes[[l]]$mcols.gene_id,
    projectName=paste0("WebGestaltR_",l, "_vs_FZTDU"),
    enrichDatabase="geneontology_Biological_Process",
    outputDirectory="WebGestaltR_RDD/GOBP")})
