////////////////////////////////////////////////////
/* --         LOCAL PARAMETER VALUES           -- */
////////////////////////////////////////////////////

params.summary_params = [:]

////////////////////////////////////////////////////
/* --          VALIDATE INPUTS                 -- */
////////////////////////////////////////////////////

// Check input path parameters to see if they exist
checkPathParamList = [ params.input, params.gtf ]
for (param in checkPathParamList) { if (param) { file(param, checkIfExists: true) } }

// Check mandatory parameters (missing protocol or profile will exit the run.)
if (params.junction_file) { ch_junction_file = file(params.junction_file)         } else { exit 1, 'Junction file input not specified!' }
if (params.annotation)    { ch_premade_annotation_rds   = file(params.annotation) } else { exit 1, 'premade promoterAnnotation rds not specified!' }

// Function to check if running offline
def isOffline() {
    try {
        return NXF_OFFLINE as Boolean
    }
    catch( Exception e ) {
        return false
    }
}

////////////////////////////////////////////////////
/* --    IMPORT LOCAL MODULES/SUBWORKFLOWS     -- */
////////////////////////////////////////////////////

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

// TO DO -- define options for the processes below
def proactiv_options    = modules['proActiv']

include { PROACTIV              } from './modules/process/proactiv'              addParams( options: proactiv_options             )
//include { GET_SOFTWARE_VERSIONS } from './modules/process/get_software_versions' addParams( options: [publish_files : ['csv':'']] )

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow ALTERNATIVE_PROMOTERS{
         PROACTIV ( ch_junction_file, ch_premade_annotation_rds )
    }

////////////////////////////////////////////////////
/* --                  THE END                 -- */
////////////////////////////////////////////////////
