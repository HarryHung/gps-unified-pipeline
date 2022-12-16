# GPS Unified Pipeline

GPS Unified Pipeline is a Nextflow Pipeline for processing Streptococcus pneumoniae sequencing raw reads (FASTQ files) by the GPS Project ([Global Pneumococcal Sequencing Project](https://www.pneumogen.net/gps/)). 

&nbsp;
## Current workflow and progress
![Workflow](doc/workflow.drawio.svg)

&nbsp;
## Usage
### Requirement
- Mamba / Conda
- Git
### Setup
1. Clone the repository
    ```
    git clone https://github.com/HarryHung/gps-unified-pipeline.git
    ```
2. Go into the local copy of the repository
    ```
    cd gps-unified-pipeline
    ```
3. Setup Conda Environment with Mamba (If using Conda, replace `mamba` with `conda` in the following commands. Use of Mamba is highly recommended due to long environment-resolving time of Conda)
   - MacOS (Intel CPU)
     ```
     mamba env create -f environment_mac.yml
     mamba activate pipeline
     ```
   - MacOS (Apple Silicon)
     ```
     CONDA_SUBDIR=osx-64 mamba env create -f environment_mac.yml
     mamba activate pipeline
     mamba config --env --set subdir osx-64
     ```
   - Linux
     ```
     mamba env create -f environment_linux.yml
     mamba activate pipeline
     ```

### Run
- You can run the pipeline without options. It will attempt to get the raw reads from the default location (`input` directory inside the `gps-unified-pipeline` local repository)
  ```
  nextflow run main.nf
  ```
- You can also specific the location of the raw reads by adding option `--reads`
  ```
  nextflow run main.nf --reads /path/to/raw-reads-directory
  ```
- For a test run, you could use the included test reads in the `test_input` directory
  ```
  nextflow run main.nf --reads test_input
  ```
  - `9870_5#52` will fail the Taxonomy QC and hence Overall QC, therefore without analysis results
  - `21127_1#156` should pass Overall QC, and with analysis results

### Output
- By default, the pipeline outputs the results into `output` directory inside the `gps-unified-pipeline` local repository
- It can be changed by adding option `--output`
  ```
  nextflow run main.nf --output /path/to/output-directory
  ```
- The following directories and files are output into the output directory
  | Directory / File | Description |
  | --- | ---|
  | assemblies | This directory contains all assemblies (`.fasta`) generated by the pipeline |
  | summary.csv | This file contains all the information generated by the pipeline on each sample |

### Options
- The table below contains the avilable options that can be used when you run the pipeline
- Usage:
  ```
  nextflow run main.nf --[option name] [value]
  ```
- `$projectDir` is the directory where the `gps-unified-pipeline` local repository is stored
- Must not have trailing slash ("`/`" at the end of path) on all paths
  | Option | Default | Possible Values | Description |
  | --- | ---| --- | --- |
  | `reads` | `"$projectDir/input"` | Any valid path | Path to the input directory that contains the reads to be processed |
  | `output` | `"$projectDir/output"` | Any valid path | Path to the output directory that save the results |
  | `os` | `System.properties['os.name']` | `"Mac OS X"` or `"Linux"` | Type of host OS. The pipeline will acquire this information automatically by default |
  | `assembler`| `"shovill"` | `"shovill"` or `"unicycler"` | SPAdes Assembler to assembly the reads |
  | `spades_local` | `"$projectDir/bin/spades"` | Any valid path | MacOS Specific. Path to the directory where SPAdes executables can be found or download to |
  | `unicycler_local` | `"$projectDir/bin/unicycler"` | Any valid path | MacOS Specific. Path to the directory where Unicycler executables can be found or download to |
  | `seroba_remote` | [SeroBA GitHub Repo](https://github.com/sanger-pathogens/seroba.git) | Any valid URL to a git remote repository | URL to a SeroBA git remote repository |
  | `seroba_local` | `"$projectDir/bin/seroba"` | Any valid path | Path to the directory where SeroBA local repository can be found or cloned to |
  | `kraken2_db_remote` | [Kraken 2 RefSeq Index Standard-8 (2022-09-12)](https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20220926.tar.gz") | Any valid URL to a Kraken2 database in `.tar.gz` format | URL to a Kraken2 database |
  | `kraken2_db_local` | `"$projectDir/bin/kraken"` | Any valid path | Path to the directory where a Kraken2 database can be found or download to |
  | `kraken2_memory_mapping` | `true` | `true` or `false` | Using memory mapping option of Kraken2 or not. `true` means not loading the database into RAM, suitable for memory-limited or fast storage (e.g. SSD) environments |
  | `ref_genome` | `"$projectDir/data/Streptococcus_pneumoniae_ATCC_700669_v1.fa"` | Any valid path to a `.fa` or `.fasta` file | Path to the reference genome for mapping |
  | `ref_genome_bwa_db_local` | `"$projectDir/bin/bwa_ref_db"` | Any valid path | Path to the directory where the reference genome FM-index database for BWA is stored |