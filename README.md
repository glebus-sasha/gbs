# gbs
Call GBS using custom R scripts for clustering (on cows)
```mermaid
graph TD
    A[QCONTROL(input_fastqs)] --> B[TRIM(input_fastqs)]
    B --> C{!params.prebuild}
    
    C -- Yes --> D[new File("$params.vepcache").mkdirs()]
    D --> E[REFINDEX(params.reference)]
    E --> F[ALIGN(TRIM.out.trimmed_reads, params.reference, REFINDEX.out)]
    F --> G[DOWNLOAD_VEP_CACHE(params.vepcache)]
    
    C -- No --> H[ALIGN(TRIM.out.trimmed_reads, params.reference, bwaidx)]
    
    H --> I[FLAGSTAT(ALIGN.out.bam)]
    F --> I
    I --> J[FAINDEX(params.reference)]
    I --> K[BAMINDEX(ALIGN.out.bam)]
    J --> L[VARCALL(params.reference, BAMINDEX.out.bai, FAINDEX.out.fai)]
    L --> M[BSFSTATS(VARCALL.out.tup_vcf)]
    
    M --> N[REPORT(TRIM.out.json.collect(), QCONTROL.out.zip.collect(), FLAGSTAT.out.flagstat.collect(), BSFSTATS.out.bcfstats.collect())]
    N --> O[CLUSTER(VARCALL.out.vcf.collect())]
```
