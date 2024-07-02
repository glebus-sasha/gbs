// Define the `CLUSTER` process that performs clustering
process CLUSTER {
    tag "$vcf"
    publishDir "${params.outdir}/${workflow.start.format('yyyy-MM-dd_HH-mm-ss')}_${workflow.runName}/CLUSTER"
//	debug true
  errorStrategy 'ignore'
	
    input:
    path vcf

    output:
    path "cluster.png"
    path "cluster_tab.tsv"
    path "dendrogram.png"

    script:
    """    
    mkdir .temp
    mv $vcf .temp
    Rscript ${workflow.workDir}/../scripts/cluster.R ./.temp combined.gds ./
    """
}
