#!/usr/bin/env nextflow
// Include processes
include { REFINDEX }            from './processes/refindex.nf'
include { QCONTROL }            from './processes/qcontrol.nf'
include { TRIM }                from './processes/trim.nf'
include { ALIGN }               from './processes/align.nf'
include { FLAGSTAT }            from './processes/flagstat.nf'
include { QUALIMAP }            from './processes/qualimap.nf'
include { FAINDEX }             from './processes/faindex.nf'
include { BAMINDEX }            from './processes/bamindex.nf'
include { VARCALL }             from './processes/varcall.nf'
include { REPORT }              from './processes/report.nf'
include { CLUSTER }              from './processes/cluster.nf'

// Logging pipeline information
log.info """\
\033[0;36m  ==========================================  \033[0m
\033[0;34m            G B S   P I P E L I N E           \033[0m
\033[0;36m  ==========================================  \033[0m

    reference:  ${params.reference}
    reads:      ${params.reads}
    outdir:     ${params.outdir}
    """
    .stripIndent(true)

// Define help
if ( params.help ) {
    help = """main.nf: This repository contains a Nextflow pipeline for analyzing 
            |Next-Generation Sequencing (NGS) data using octopus 
            |
            |Required arguments:
            |   --reference     Location of the reference file.
            |                   [default: ${params.reference}]
            |   --reads         Location of the input file file.
            |                   [default: ${params.reads}]
            |   --outdir        Location of the output file file.
            |                   [default: ${params.outdir}]
            |
            |Optional arguments:
            |   -profile        <docker/singularity>
            |   -prebuild       Use pre-built bwa indexes and pre-downloaded vep cache
            |   -reports        Generate pipeline reports
            |
""".stripMargin()
    // Print the help with the stripped margin and exit
    println(help)
    exit(0)
}

// Define the input channel for FASTQ files, if provided
input_fastqs = params.reads ? Channel.fromFilePairs(params.reads, checkIfExists: true) : null

// Define the input channel for bwa index files, if provided
bwaidx = params.bwaidx ? Channel.fromPath(params.bwaidx, checkIfExists: true).collect() : null


// Define the workflow
workflow {
    
    QCONTROL(input_fastqs)
    TRIM(input_fastqs)
    if( !params.prebuild ) {
        new File("$params.vepcache").mkdirs() // Make the VEP cache  directory if it needs
        REFINDEX(params.reference)
        ALIGN(TRIM.out.trimmed_reads, params.reference, REFINDEX.out)
        DOWNLOAD_VEP_CACHE(params.vepcache)
    }
    else {
        ALIGN(TRIM.out.trimmed_reads, params.reference, bwaidx)
    }
    FLAGSTAT(ALIGN.out.bam)
    FAINDEX(params.reference)
    BAMINDEX(ALIGN.out.bam)
    VARCALL(params.reference, BAMINDEX.out.bai, FAINDEX.out.fai)
//    REPORT(TRIM.out.json.collect(), QCONTROL.out.zip.collect(), FLAGSTAT.out.flagstat.collect())
    CLUSTER(VARCALL.out.vcf.collect())
}

// Log pipeline execution summary on completion
workflow.onComplete {
    log.info """\033[0;32m\
    
    Pipeline execution summary
    ---------------------------
    Completed at: ${workflow.complete.format('yyyy-MM-dd_HH-mm-ss')}
    Duration    : ${workflow.duration}
    Success     : ${workflow.success}
    workDir     : ${workflow.workDir}
    exit status : ${workflow.exitStatus}
    \033[0m"""
    .stripIndent()
        
    log.info ( workflow.success ? "\nDone" : "\nOops" )
}




