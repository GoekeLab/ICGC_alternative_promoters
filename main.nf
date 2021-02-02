#!/usr/bin/env nextflow
/*
========================================================================================
                         ICGC alternative promoters
========================================================================================
 ICGC alternative promoters Analysis Pipeline.
 #### Homepage / Documentation
 https://github.com/GoekeLab/ICGC_alternative_promoters
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

////////////////////////////////////////////////////
/* --               PRINT HELP                 -- */
////////////////////////////////////////////////////

if (params.help) {
    //print something here
    exit 0
}

////////////////////////////////////////////////////
/* --          PARAMETER CHECKS                -- */
////////////////////////////////////////////////////

// Check that conda channels are set-up correctly
//if (params.enable_conda) {
//    Checks.check_conda_channels(log)
//}

// Check AWS batch settings
//Checks.aws_batch(workflow, params)

// Check the hostnames against configured profiles
//Checks.hostname(workflow, params, log)

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow {
    /*
     * SUBWORKFLOW: Run main ICGC alternative promoter analysis pipeline
     */
    include { ALTERNATIVE_PROMOTERS } from './alternative_promoters' addParams( [:] )
    ALTERNATIVE_PROMOTERS ()
}

////////////////////////////////////////////////////
/* --                  THE END                 -- */
////////////////////////////////////////////////////
