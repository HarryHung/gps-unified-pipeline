// Return Seroba databases path
// Pull to check if seroba database is up-to-date. If outdated or does not exist: clean, clone and re-create kmc and ariba databases
process GET_SEROBA_DB {
    input:
    val remote
    val local

    output:
    val "$local/database"

    shell:
    '''
    if !(git -C !{local} pull | grep -q 'Already up to date'); then
        rm -rf !{local}
        git clone !{remote} !{local}
        seroba createDBs !{local}/database/ 71
    fi
    '''
}

// Run Seroba to serotype samples
process SEROTYPE {
    input:
    val database
    tuple val(sample_id), path(read1), path(read2), path(unpaired)

    output:
    tuple val(sample_id), env(SEROTYPE), env(SEROBA_COMMENT), emit: result

    shell:
    '''
    seroba runSerotyping !{database} !{read1} !{read2} !{sample_id}

    SEROTYPE=$(awk -F'\t' '{ print $2 }' !{sample_id}/pred.tsv)
    SEROBA_COMMENT=$(awk -F'\t' '$3!=""{ print $3 } $3==""{ print "_" }' !{sample_id}/pred.tsv)
    '''
}