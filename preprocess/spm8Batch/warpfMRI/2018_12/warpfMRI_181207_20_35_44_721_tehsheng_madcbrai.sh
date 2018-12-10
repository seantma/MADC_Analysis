#!/bin/bash -l
#
# warpfMRI Version 2.1 2011-07-30
# Copyright Robert C. Welsh
#
#
STARTTIME=`date` 
#
#     directory to coreg       : func//coReg/vbm8/
#     name of the high res     : t1spgr
#     Warping Method (1=VBM8)  : 1
#     template image dir/name  : /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313/templates//T1.nii
#     prepending name          : vbm8_w2mm_
#     Voxel dimension (0=spm)  : 0
#     volumeWILD               : vasc_3dasl
#     functional sub-dir       : 


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

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1565_5522_validation_umstream_status_file

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

% warpfMRI Script Created on 181207_20_35_44_721

fprintf('Coregistation Script Created on 181207_20_35_44_721\n');

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/warpfMRI/2018_12

global UMBatchJobName
global UMBatchProcessName
UMBatchJobName     = 'warpfMRI_181207_20_35_44_721_tehsheng_madcbrai'
UMBatchProcessName = 'warpfMRI'

warpfMRI_181207_20_35_44_721_tehsheng_madcbrai

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
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1565_5522_validation_umstream_status_file" ] 
then
   echo "warpfMRI ${JOBSTATUS}, attempted at : 181207_20_35_44_721" >> ${UMSTREAM_STATUS_FILE}
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
# This job was created on 181207_20_35_44_721 with the command line:
#
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/warpfMRI -W -w coReg/vbm8 -M ../../Subjects_ASL madc1565_5522 -h t1spgr -v vasc_3dasl -n vbm8_w2mm_ -I PET -B
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
