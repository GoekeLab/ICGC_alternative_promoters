// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options       = [:]
params.multiqc_label = ''
def options          = initOptions(params.options)

process PROACTIV {
    label "process_medium"
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }

    conda     (params.enable_conda ? "conda-forge::r-base=4.0.0 bioconda::bioconductor-proactiv=1.0.0" : null)
    container "quay.io/biocontainers/bioconductor-proactiv:1.0.0--r40_1"
    
    input:
    path samplesheet
    path gtf
    
    output:    
    path "*.csv"                , emit: proactiv_csv
    path "proactiv.version.txt" , emit: proactiv_version
    path "r.version.txt"        , emit: r_version

    script:
    """
    run_proactiv.r --samplesheet=$samplesheet --annotation=$gtf
    Rscript -e "library(proActiv); write(x=as.character(packageVersion('proActiv')), file='proactiv.version.txt')"
    echo \$(R --version 2>&1) > r.version.txt
    """
}
