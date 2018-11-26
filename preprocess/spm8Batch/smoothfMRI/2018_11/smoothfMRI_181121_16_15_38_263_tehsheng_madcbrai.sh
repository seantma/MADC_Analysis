#!/bin/bash -l
#
# smoothfMRI Version 2.1 2011-07-30
# Copyright Robert C. Welsh
#
#
STARTTIME=`date` 
#
#     images will be smoothed  : 5 5 5
#     volumes to be smoothed   : vbm8_w3mm_utprun_
#     prepending name          : s5


#     functional images path    : func/
#     Subject directory         : ../../Subjects_ABCDResting

#     Back(1)/fore(0)ground     : 0

#     spm8 is located in        : /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
#     spm8Batch is located in   : /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
#     spm8 patch is located in  : /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts
#     auxiliary matlab path     : /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
#     matlab options file       : 

#     User                      : NOMAIL
#     MATLAB                    : /opt/bin/matlab

#     SANDBOXHOST               : madcbrain
#     SANDBOX                   : /madcbrain/sandbox/
#     SANDBOXPID                : 

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1418_scan1_validation_umstream_status_file

#     Copyright Robert C. Welsh, 2005-2018, Version 2.1/2011-07-30

MATLAB_BASED_PROCESS=0   # Default to not a matlab process

# Get into the right working directory
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
# Create the sandbox
#
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/create_sandbox 
#
#
MATLAB_BASED_PROCESS=1   # We are indeed a matlab based process

/opt/bin/matlab -nodisplay <<EOF 

% smoothfMRI Script Created on 181121_16_15_38_263

fprintf('Coregistation Script Created on 181121_16_15_38_263\n');

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/smoothfMRI/2018_11

global UMBatchJobName
global UMBatchProcessName
UMBatchJobName     = 'smoothfMRI_181121_16_15_38_263_tehsheng_madcbrai'
UMBatchProcessName = 'smoothfMRI'

smoothfMRI_181121_16_15_38_263_tehsheng_madcbrai

exit
EOF
MATLAB_RETURN_CODE=$?

JOBSTATUS="SUCCESS"

if [ "${MATLAB_BASED_PROCESS}" == "1" ]
then
    if [ "${MATLAB_RETURN_CODE}" != "0" ] 
    then
	JOBSTATUS="MATLAB_FAILED:${MATLAB_RETURN_CODE}"
    fi
fi
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1418_scan1_validation_umstream_status_file" ] 
then
   echo "smoothfMRI ${JOBSTATUS}, attempted at : 181121_16_15_38_263" >> ${UMSTREAM_STATUS_FILE}
fi

#
# Remove the sandbox
#
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/remove_sandbox 0 
#
ENDTIME=`date`
#
#
echo   
echo   
echo "Start   : ${STARTTIME}" 
echo "Finish  : ${ENDTIME}" 
echo  
echo  
#
#
# This job was created on 181121_16_15_38_263 with the command line:
#
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/smoothfMRI 5 5 5 -M ../../Subjects_ABCDResting madc1418_scan1 -v vbm8_w3mm_utprun_ -n s5 -B
#
# Command was built while in the directory:
#
# /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
# spm8Batch Version : spm8Batch VBM8 2013-04-01 On branch spm8Batch/Fix_sandbox_on_MAC
# MethodsCore Release Tag : MethodsCore 2.0
# MethodsCore Repository SHA-ID: 
#
# All done
#
