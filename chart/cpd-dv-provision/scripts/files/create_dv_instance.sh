#!/bin/sh

################################################################################
#
# Licensed Materials - Property of IBM
#
# "Restricted Materials of IBM"
#
# (C) COPYRIGHT IBM Corp. 2018 All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
################################################################################

#Global Static variables
VALUE_INT_YES=0
VALUE_INT_NO=1

CPD_RELEASE_CURRENT="4.0.6"
CPD_RELEASE="${CPD_RELEASE_CURRENT}"
DV_RELEASE="${CPD_RELEASE}"
DV_CUSTOM_RELEASE=""

isIAMEnabled="false"

# cpd-operators that hosts all cp4d operators including ibmcpd
# $SERVICE_INSTANCE_NAMESPACE that hosts cp4d pods
ZEN_OPERATORS_NAMESPACE="${ZEN_OPERATORS_NAMESPACE}"
SERVICE_INSTANCE_NAMESPACE="${SERVICE_INSTANCE_NAMESPACE}"

CP4D_WEB_URL="ibm-nginx-svc"
CP4D_WEB_URL_USERNAME="${CP4D_WEB_URL_USERNAME}"
CP4D_WEB_URL_PASSWORD="${CP4D_WEB_URL_PASSWORD}"

IAMINTEGRATION="false"

#Deployment/Provisioning parameters
PROVISION_VIA_CR=${VALUE_INT_NO}
IS_DV=${VALUE_INT_NO}

#DV specific paramters defaults  - can be overridden by user parms
MEMORY_REQUEST_SIZE="${MEMORY_REQUEST_SIZE}"
CPU_REQUEST_SIZE="${CPU_REQUEST_SIZE}"
PERSISTENCE_STORAGE_CLASS="${PERSISTENCE_STORAGE_CLASS}"
PERSISTENCE_STORAGE_SIZE="${PERSISTENCE_STORAGE_SIZE}"
CACHING_STORAGE_CLASS="${CACHING_STORAGE_CLASS}"
CACHING_STORAGE_SIZE="${CACHING_STORAGE_SIZE}"
WORKER_STORAGE_CLASS="${WORKER_STORAGE_CLASS}"
WORKER_STORAGE_SIZE="${WORKER_STORAGE_SIZE}"
DV_INSTALL_JSON_FILE_PATH="newdv.json"
MNTDIR="/scripts"
CMDDIR="/temp"

#Any logic that requires modification of parms based on conditions here
init_parameters() {

    if [ "$DV_CUSTOM_RELEASE" != "" ]; then
        DV_RELEASE=${DV_CUSTOM_RELEASE}
    else
        if [ "${CPD_RELEASE}" = "4.0.4" ]; then
            DV_RELEASE="4.0.3"
        else
            DV_RELEASE=${CPD_RELEASE}
        fi
    fi

    IS_DV=${VALUE_INT_YES}

}

#prints the parameter values that the install will use
print_install_parameters() {

    log_info "General parameters: "
    log_info "Zen Namespace: ${SERVICE_INSTANCE_NAMESPACE}"
    log_info "Zen Operators Namespace: ${ZEN_OPERATORS_NAMESPACE}"
    log_info "CP4D Custom User: ${CP4D_WEB_URL_USERNAME}"
    log_info "CP4D iamIntegration is set to ${IAMINTEGRATION}"
    echo

    echo
    log_info "Version/Tag parameters : "
    oc get ibmcpd ibmcpd-cr -n ${SERVICE_INSTANCE_NAMESPACE} -o yaml | grep ' zenOperatorBuildNumber: '

    log_info "CPD Release Version  : ${CPD_RELEASE}"
    log_info "DV Release Version  : ${DV_RELEASE}"

    echo
    #print dv specific parameters

    log_info "Number of worker pods: ${NUMBER_OF_WORKERS}"
    log_info "Requested memory size: ${MEMORY_REQUEST_SIZE}"
    log_info "Requested CPU size: ${CPU_REQUEST_SIZE}"
    log_info "Persistence Storage Class: ${PERSISTENCE_STORAGE_CLASS}"
    log_info "Persistence Storage Size: ${PERSISTENCE_STORAGE_SIZE}"
    log_info "Caching Storage Class: ${CACHING_STORAGE_CLASS}"
    log_info "Caching Storage Size: ${CACHING_STORAGE_SIZE}"
    log_info "Worker Storage Class: ${WORKER_STORAGE_CLASS}"
    log_info "Worker Storage Size: ${WORKER_STORAGE_SIZE}"

    echo
} #end of print_install_parameters

#Helper Functions
exists() {
    if command -v $1 &>/dev/null; then
        return
    fi

    if [ -f $1 ]; then
        return
    fi
    false
}

get_dv_version() {
    cpd_release=${DV_RELEASE}
    if [[ "$cpd_release" == "4.0.0" ]]; then
        echo '1.7.0'
    elif [[ "$cpd_release" == "4.0.1" ]]; then
        echo '1.7.1'
    elif [[ "$cpd_release" == "4.0.2" ]]; then
        echo '1.7.2'
    elif [[ "$cpd_release" == "4.0.3" ]]; then
        echo '1.7.3'
    elif [[ "$cpd_release" == "4.0.4" ]]; then
        echo '1.7.3'
    elif [[ "$cpd_release" == "4.0.5" ]]; then
        echo '1.7.5'
    else
        echo '1.7.3'
    fi
}


echo "done"