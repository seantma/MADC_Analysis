#!/bin/bash -l
#
# vbm8HiRes Version 1.0 2012-03-05
# vbm8HiRes Version 1.0 2012-03-05
# Copyright Robert C. Welsh
# Copyright Robert C. Welsh
#
#
#
#
STARTTIME=`date` 
STARTTIME=`date` 
#
#
#     anatomy path             : func/coReg
#     name of hisres image     : t1mprage
#     directory to vbm8        : func/coReg/vbm8/
#     all(1) or biasfield(0)   : 1
#     prepending name          : vbm8_w3mm_
#     Erosion Last flag        : 1

#     anatomy path             : func/coReg
#     name of hisres image     : t1mprage
#     directory to vbm8        : func/coReg/vbm8/
#     all(1) or biasfield(0)   : 1
#     prepending name          : vbm8_w3mm_
#     Erosion Last flag        : 1


#     functional images path    : ./
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

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1422_scan1_validation_umstream_status_file


#     Copyright Robert C. Welsh, 2005-2018, Version 1.0/2012-03-05

#     functional images path    : ./
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

#     UMSTREAM_STATUS_FILE      : /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1228_scan1_validation_umstream_status_file

#     Copyright Robert C. Welsh, 2005-2018, Version 1.0/2012-03-05

MATLAB_BASED_PROCESS=0   # Default to not a matlab process

MATLAB_BASED_PROCESS=0   # Default to not a matlab process
# Get into the right working directory
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess

# Get into the right working directory
#
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
MATLAB_BASED_PROCESS=1   # We are indeed a matlab based process
#

MATLAB_BASED_PROCESS=1   # We are indeed a matlab based process
/opt/bin/matlab -nodisplay <<EOF 


/opt/bin/matlab -nodisplay <<EOF 
% vbm8HiRes Script Created on 181121_17_33_56_276


% vbm8HiRes Script Created on 181121_17_33_56_276
fprintf('Coregistation Script Created on 181121_17_33_56_276\n');


addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
fprintf('Coregistation Script Created on 181121_17_33_56_276\n');
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/SPM/SPM8/spm8_with_R6313
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_11
addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/matlabScripts

addpath /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/spm8_patch
global UMBatchJobName
addpath /Users/rcwelsh/matlabScripts/WELLES/mfiles -END
global UMBatchProcessName
addpath /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/spm8Batch/vbm8HiRes/2018_11
UMBatchJobName     = 'vbm8HiRes_181121_17_33_56_276_tehsheng_madcbrai'

UMBatchProcessName = 'vbm8HiRes'
global UMBatchJobName

global UMBatchProcessName
vbm8HiRes_181121_17_33_56_276_tehsheng_madcbrai
UMBatchJobName     = 'vbm8HiRes_181121_17_33_56_276_tehsheng_madcbrai'

UMBatchProcessName = 'vbm8HiRes'
exit

EOF
vbm8HiRes_181121_17_33_56_276_tehsheng_madcbrai
MATLAB_RETURN_CODE=$?


exit
EOF
#
MATLAB_RETURN_CODE=$?

# Calling erodeMask now interactively
#
#
# Get into the right working directory
# Calling erodeMask now interactively
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#

# Get into the right working directory
# Make sure that warping job successfully finished
cd /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess


if [ "${MATLAB_RETURN_CODE}" == "0" ]
# Make sure that warping job successfully finished
then

    # Make sure that warping job successfully finished
    erodeMaskif [ "${MATLAB_RETURN_CODE}" == "0" ]
     -E 2     1then
     -w func/coReg/vbm8         # Make sure that warping job successfully finished
     -v vbm8_w3mm_    erodeMask     -h t1mprage     -E 2     -m "-s 5 -sub 0.333"     -M ../../Subjects_ABCDResting     1     -n eroMask_     -w func/coReg/vbm8 madc1422_scan1
     else
     -v vbm8_w3mm_    echo "Warping of hi res failed so no erosion possible"
     -h t1mpragefi
     -m "-s 5 -sub 0.333"     -M ../../Subjects_ABCDRestingJOBSTATUS="SUCCESS"
     -n eroMask_
 madc1228_scan1if [ "${MATLAB_BASED_PROCESS}" == "1" ]

then
else
    if [ "${MATLAB_RETURN_CODE}" != "0" ] 
    echo "Warping of hi res failed so no erosion possible"
    then
fi
	JOBSTATUS="MATLAB_FAILED:${MATLAB_RETURN_CODE}"
JOBSTATUS="SUCCESS"

    fi
if [ "${MATLAB_BASED_PROCESS}" == "1" ]
fi
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1422_scan1_validation_umstream_status_file" ] 
then
then
    if [ "${MATLAB_RETURN_CODE}" != "0" ] 
   echo "vbm8HiRes ${JOBSTATUS}, attempted at : 181121_17_33_56_276" >> ${UMSTREAM_STATUS_FILE}
    then
fi
	JOBSTATUS="MATLAB_FAILED:${MATLAB_RETURN_CODE}"

    fi
#
fi
# Remove the sandbox
if [ ! -z "/nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess/madc1228_scan1_validation_umstream_status_file" ] 
#
then
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/remove_sandbox  
   echo "vbm8HiRes ${JOBSTATUS}, attempted at : 181121_17_33_56_276" >> ${UMSTREAM_STATUS_FILE}
#
fi
ENDTIME=`date`

#
#
#
# Remove the sandbox
echo   
#
echo   
/nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/auxiliary/remove_sandbox  
echo "Start   : ${STARTTIME}" 
#
echo "Finish  : ${ENDTIME}" 
echo  
ENDTIME=`date`
#
echo  
#
echo   
#
echo   
#
echo "Start   : ${STARTTIME}" 
# This job was created on 181121_17_33_56_276 with the command line:
echo "Finish  : ${ENDTIME}" 
#
echo  
echo  
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/vbm8HiRes -a func/coReg -w func/coReg/vbm8 -M ../../Subjects_ABCDResting madc1422_scan1 -h t1mprage -n vbm8_w3mm_ -I r3mm_avg152T1 -B
#
#
#
# This job was created on 181121_17_33_56_276 with the command line:
# Command was built while in the directory:
#
#
# /nfs/psych-bhampstelab/VA_SPiRE_2015/fMRI_Working/MCore/spm8Batch/vbm8HiRes -a func/coReg -w func/coReg/vbm8 -M ../../Subjects_ABCDResting madc1228_scan1 -h t1mprage -n vbm8_w3mm_ -I r3mm_avg152T1 -B
# /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
#
# Command was built while in the directory:
#
# /nfs/fmri/Analysis/Sean_Working/Git_MADC/preprocess
#
# spm8Batch Version : spm8Batch VBM8 2013-04-01 On branch spm8Batch/Fix_sandbox_on_MAC
# MethodsCore Release Tag : MethodsCore 2.0
# spm8Batch Version : spm8Batch VBM8 2013-04-01 On branch spm8Batch/Fix_sandbox_on_MAC
# MethodsCore Repository SHA-ID: 
# MethodsCore Release Tag : MethodsCore 2.0
#
# MethodsCore Repository SHA-ID: 
# All done
#
#
# All done
#
