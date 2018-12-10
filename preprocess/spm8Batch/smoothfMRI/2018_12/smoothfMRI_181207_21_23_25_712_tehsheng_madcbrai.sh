#!/bin/bash -l
#
#
#
# smoothfMRI Version 2.1 2011-07-30
STARTTIME=`date` 
# Copyright Robert C. Welsh
#
#
#
#     images will be smoothed  : 5 5 5
#     volumes to be smoothed   : vbm8_w2mm_vasc_3dasl
#     prepending name          : s5


#     functional images path    : func/
#     Subject directory         : ../../Subjects_ASL

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

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1519_5232_validation_umstream_status_file

#     Copyright Robert C. Welsh, 2005-2018, Version 2.1/2011-07-30

STARTTIME=`date` 
MATLAB_BASED_PROCESS=0   # Default to not a matlab process
#

# Get into the right working directory
#     images will be smoothed  : 5 5 5
#     volumes to be smoothed   : vbm8_w2mm_vasc_3dasl
#     prepending name          : s5


cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#     functional images path    : func/
#     Subject directory         : ../../Subjects_ASL

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

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1575_5746_validation_umstream_status_file

#     Copyright Robert C. Welsh, 2005-2018, Version 2.1/2011-07-30

#
MATLAB_BASED_PROCESS=0   # Default to not a matlab process

# Create the sandbox
#
# Get into the right working directory
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/create_sandbox 
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
#
#
# Create the sandbox
MATLAB_BASED_PROCESS=1   # We are indeed a matlab based process
#

/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/create_sandbox 
/opt/bin/matlab -nodisplay <<EOF 
#

#
% smoothfMRI Script Created on 181207_21_23_25_712
MATLAB_BASED_PROCESS=1   # We are indeed a matlab based process


fprintf('Coregistation Script Created on 181207_21_23_25_712\n');
/opt/bin/matlab -nodisplay <<EOF 


addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
% smoothfMRI Script Created on 181207_21_23_25_712
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts
fprintf('Coregistation Script Created on 181207_21_23_25_712\n');
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/smoothfMRI/2018_12
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
global UMBatchJobName
global UMBatchProcessName
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
UMBatchJobName     = 'smoothfMRI_181207_21_23_25_712_tehsheng_madcbrai'
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/smoothfMRI/2018_12
UMBatchProcessName = 'smoothfMRI'

global UMBatchJobName

global UMBatchProcessName
smoothfMRI_181207_21_23_25_712_tehsheng_madcbrai
UMBatchJobName     = 'smoothfMRI_181207_21_23_25_712_tehsheng_madcbrai'

UMBatchProcessName = 'smoothfMRI'
exit

EOF
smoothfMRI_181207_21_23_25_712_tehsheng_madcbrai
MATLAB_RETURN_CODE=$?


exit
EOF
JOBSTATUS="SUCCESS"
MATLAB_RETURN_CODE=$?


if [ "${MATLAB_BASED_PROCESS}" == "1" ]
JOBSTATUS="SUCCESS"
then

    if [ "${MATLAB_RETURN_CODE}" != "0" ] 
if [ "${MATLAB_BASED_PROCESS}" == "1" ]
    then
then
	JOBSTATUS="MATLAB_FAILED:${MATLAB_RETURN_CODE}"
    if [ "${MATLAB_RETURN_CODE}" != "0" ] 
    fi
    then
fi
	JOBSTATUS="MATLAB_FAILED:${MATLAB_RETURN_CODE}"
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1519_5232_validation_umstream_status_file" ] 
    fi
then
fi
   echo "smoothfMRI ${JOBSTATUS}, attempted at : 181207_21_23_25_712" >> ${UMSTREAM_STATUS_FILE}
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1575_5746_validation_umstream_status_file" ] 
fi
then

   echo "smoothfMRI ${JOBSTATUS}, attempted at : 181207_21_23_25_712" >> ${UMSTREAM_STATUS_FILE}
#
fi
# Remove the sandbox

#
#
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/remove_sandbox 0 
# Remove the sandbox
#
#
ENDTIME=`date`
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/remove_sandbox 0 
#
#
#
ENDTIME=`date`
echo   
#
echo   
#
echo "Start   : ${STARTTIME}" 
echo   
echo "Finish  : ${ENDTIME}" 
echo   
echo  
echo "Start   : ${STARTTIME}" 
echo  
echo "Finish  : ${ENDTIME}" 
#
echo  
#
echo  
# This job was created on 181207_21_23_25_712 with the command line:
#
#
#
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/smoothfMRI 5 5 5 -M ../../Subjects_ASL madc1519_5232 -v vbm8_w2mm_vasc_3dasl -n s5 -B
# This job was created on 181207_21_23_25_712 with the command line:
#
#
# Command was built while in the directory:
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/smoothfMRI 5 5 5 -M ../../Subjects_ASL madc1575_5746 -v vbm8_w2mm_vasc_3dasl -n s5 -B
#
#
# /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
# Command was built while in the directory:
#
#
# /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
# spm8Batch Version : spm8Batch VBM8 2013-04-01 On branch spm8Batch/Fix_sandbox_on_MAC
# spm8Batch Version : spm8Batch VBM8 2013-04-01 On branch spm8Batch/Fix_sandbox_on_MAC
# MethodsCore Release Tag : MethodsCore 2.0
# MethodsCore Release Tag : MethodsCore 2.0
# MethodsCore Repository SHA-ID: 
# MethodsCore Repository SHA-ID: 
#
#
# All done
# All done
#
#
