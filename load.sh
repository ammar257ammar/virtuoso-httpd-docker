#!/bin/bash
#
# Virtuoso Loader Script
#
# Author: Ammar Ammar (ammar257ammar@gmail.com)
# Year: 2019
# Adapted from Shangguan work 2010 (https://data-gov.tw.rpi.edu//2010/virtuoso/vload)
# Description: loader script for Virtuoso
# Usage: load [data_file] [graph_uri] [log_file] [virtuoso_password]

# Get input arguments
args=("$@")

if [ $# -ne 4 ]; then
    echo "Wrong number of arguments. Correct usage: \"load [data_file] [graph_uri] [log_file] [virtuoso_password]\""
else

    VAD=/import
    data_file=${args[0]}
    graph_uri=${args[1]}
    LOGFILE=${args[2]}
    VIRT_PSWD=${args[3]}

    # Status message
    echo "Loading triples into graph <$graph_uri>..."

    # Log into Virtuoso isql env
    isql_cmd="isql-v -U dba -P $VIRT_PSWD"
    isql_cmd_check="isql-v -U dba -P $VIRT_PSWD exec=\"checkpoint;\""

    # Build the Virtuoso commands
    load_func="ld_dir('$VAD', '$data_file', '$graph_uri');"
    run_func="rdf_loader_run();"
    select_func="select * from DB.DBA.load_list WHERE ll_file LIKE '%${VAD}%';"
   
    # Run the Virtuoso commands
    ${isql_cmd} << EOF &> ${LOGFILE}
	    $load_func
            $run_func
            $select_func   
            exit;
    ${isql_cmd_check}

EOF

    # Write the load commands to the log 
    echo "----------" >> ${LOGFILE}
    echo $load_func >> ${LOGFILE}
    echo $run_func >> ${LOGFILE}
    echo ${select_func} >> ${LOGFILE}
    echo "----------" >> ${LOGFILE}
    
    # Print out the log file
    cat ${LOGFILE}

    result=$?

    if [ $result != 0 ]
    then
        "Failed to load! Check ${LOGFILE} for details."
        exit 1
    fi

    # Status message
    echo "Loading finished! Check ${LOGFILE} for details."
    exit 0
fi

