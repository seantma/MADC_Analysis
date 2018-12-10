#!/bin/bash -l
#
# vbm8HiRes Version 1.0 2012-03-05
# Copyright Robert C. Welsh
#
#
STARTTIME=`date` 
#
#     anatomy path             : func/coReg
#     name of hisres image     : t1spgr
#     directory to vbm8        : func/coReg/vbm8/
#     all(1) or biasfield(0)   : 1
#     prepending name          : vbm8_w2mm_
#     Erosion Last flag        : 1


#     functional images path    : ./
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

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1550_5786_validation_umstream_status_file

#     Copyright Robert C. Welsh, 2005-2018, Version 1.0/2012-03-05

MATLAB_BASED_PROCESS=0   # Default to not a matlab process

# Get into the right working directory
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
MATLAB_BASED_PROCESS=1   # We are indeed a matlab based process

/opt/bin/matlab -nodisplay <<EOF 

% vbm8HiRes Script Created on 181207_18_04_50_281

fprintf('Coregistation Script Created on 181207_18_04_50_281\n');

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_12

global UMBatchJobName
global UMBatchProcessName
UMBatchJobName     = 'vbm8HiRes_181207_18_04_50_281_tehsheng_madcbrai'
UMBatchProcessName = 'vbm8HiRes'

vbm8HiRes_181207_18_04_50_281_tehsheng_madcbrai

exit
EOF
MATLAB_RETURN_CODE=$?

#
# Calling erodeMask now interactively
#
# Get into the right working directory
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess

# Make sure that warping job successfully finished

if [ "${MATLAB_RETURN_CODE}" == "0" ]
then
    # Make sure that warping job successfully finished
    erodeMask     -E 2     1     -w func/coReg/vbm8          -v vbm8_w2mm_     -h t1spgr     -m "-s 5 -sub 0.333"     -M ../../Subjects_ASL     -n eroMask_ madc1550_5786
else
    echo "Warping of hi res failed so no erosion possible"
fi
JOBSTATUS="SUCCESS"

if [ "${MATLAB_BASED_PROCESS}" == "1" ]
then
    if [ "${MATLAB_RETURN_CODE}" != "0" ] 
    then
	JOBSTATUS="MATLAB_FAILED:${MATLAB_RETURN_CODE}"
    fi
fi
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1550_5786_validation_umstream_status_file" ] 
then
   echo "vbm8HiRes ${JOBSTATUS}, attempted at : 181207_18_04_50_281" >> ${UMSTREAM_STATUS_FILE}
fi

#
# Remove the sandbox
#
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/remove_sandbox  
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
# This job was created on 181207_18_04_50_281 with the command line:
#
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/vbm8HiRes -a func/coReg -w func/coReg/vbm8 -M ../../Subjects_ASL madc1550_5786 -h t1spgr -n vbm8_w2mm_ -I PET -B
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
