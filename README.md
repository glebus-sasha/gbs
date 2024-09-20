# gbs
Call GBS using custom R scripts for clustering (on cows)
```mermaid
%%{init: {'theme':'base'}}%%
flowchart TB
    subgraph "input"
    v0["input_fastqs"]
    v1["reference"]
    v2["bwaidx"]
    end
    subgraph "output"
    v9["report"]
    v10["clustered vcf"]
    end
    v3([QCONTROL])
    v4([TRIM])
    v5([ALIGN])
    v6([FLAGSTAT])
    v7([FAINDEX])
    v8([BAMINDEX])
    v11([VARCALL])
    v12([BSFSTATS])
    v13([REPORT])
    v14([CLUSTER])
    v0 --> v3
    v3 --> v4
    v4 --> v5
    v1 --> v5
    v2 --> v5
    v5 --> v6
    v1 --> v7
    v5 --> v8
    v8 --> v11
    v7 --> v11
    v1 --> v11
    v11 --> v12
    v12 --> v9
    v4 --> v13
    v3 --> v13
    v6 --> v13
    v12 --> v13
    v13 --> v9
    v11 --> v14
    v14 --> v10

```

## Contributors

- Oxana Kolpakova ([@OxanaKolpakova](https://github.com/OxanaKolpakova))
- Glebus Aleksandr ([@glebus-sasha](https://github.com/glebus-sasha/))
