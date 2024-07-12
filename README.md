# gbs
Call GBS using custom R scripts for clustering (on cows)
```mermaid
%%{init: {'theme':'base'}}%%
    A[QCONTROL(input_fastqs)] --> B[TRIM(input_fastqs)]
    B --> C[ALIGN(TRIM.out.trimmed_reads, params.reference, bwaidx)]
    C --> D[FLAGSTAT(ALIGN.out.bam)]
    C --> E[FAINDEX(params.reference)]
    C --> F[BAMINDEX(ALIGN.out.bam)]
    E --> G[VARCALL(params.reference, BAMINDEX.out.bai, FAINDEX.out.fai)]
    F --> G
    G --> H[BSFSTATS(VARCALL.out.tup_vcf)]
    I[REPORT(TRIM.out.json.collect(), QCONTROL.out.zip.collect(), FLAGSTAT.out.flagstat.collect(), BSFSTATS.out.bcfstats.collect())]
    B --> I
    J[CLUSTER(VARCALL.out.vcf.collect())]
    G --> J
```
