#!/bin/bash
#
# Shell script for structuring subject folders
# - based off of R generated .csv: eg. ben_newfolder_forshell_QC.csv
# - R source code: folder_structure.R
#
# Sean Ma
# Dec 2016
# Jul 2017 - upgrade to use cp -ipal for "hardlink" to files
# Oct 2017 - adding dummy frame trimming; autodetect how many run folders
#
# TODOs:
# - !! NEED !! Check if multiple t1spgr, t1overlay, exists!
# - integrate with Makefile for fault tolerance and parallelization
#
# - How to run:
# sh file_struct_ASL_UMMAP.sh 2>&1 | tee file_struct_console_ASL_UMMAP_$(date +"%m%d_%Y").txt
#
# - How to check error:
# grep -i 'no such file' file_struct_console_Task_1222_2016.txt
#
# - How to generate directory listing for FirstLevel_mc_template.m
# ls -d */ > dir_struct_{$date}.txt
#
# !!TODO(Sean): 1. print out original file directory and file name of t1spgr_208

THISDIR=/nfs/fmri/Analysis/Sean_Working/Subjects_ASL
RAWDIR=/nfs/fmri/RAW_nopreprocess

echo
echo "*** This script is for UMMAP ASL file structure purpose!! ***"
echo

# number of files index
N=0

# for loop to read from input .csv
while IFS="," read -r oldfolder newfolder vfilepath
do
  # making fmri analysis folder in /Subjects
  cd ${THISDIR}
  mkdir "${newfolder}"
  cd ${newfolder}
  SUBJ_DIR=$(pwd)

  echo
  echo "Current subject: " ${SUBJ_DIR}
  echo

  # setting up directories
  echo
  echo "Making anatomy and func directories"
  echo

  mkdir anatomy
  mkdir func

  # copying spgr.nii and linking them for preprocessing
  echo
  echo "Copying and linking t1spgr.nii for Task"
  echo

  # find which t1 folder to get anatomic file: /t1mprage_208 or /t1sag_208
  cd anatomy
  echo "Current folder: $(pwd)"
  T1_DIR=$(ls -d ${RAWDIR}/${oldfolder}/anatomy/* | grep -E 't1mprage|t1sag')
  echo "T1 dir: ${T1_DIR}"
  # checking if more than 1 file exists; report error if so
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/${T1_DIR}/{t1mprage*,t1sag*} 2>/dev/null | wc -l)

  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple t1spgr in /anatomy !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/${T1_DIR}/{t1mprage*,t1sag*}

  else
    cd ${T1_DIR}
    T1_FILE=$(ls *.nii | grep -E '^t1mprage|^t1sag')
    echo "T1 file: ${T1_FILE}"
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    # !!Note!! switching back to cp -ip for /anatomy files due to direct alterations
    # !!Note!! linking symbolic links first then do an actual cp -pL dereference copy
    # adding || as try/catch mechanism
    cd ${SUBJ_DIR}
    ln -s ${T1_DIR}/${T1_FILE} ${SUBJ_DIR}/anatomy/${T1_FILE}
    # cp -pL ${T1_DIR}/${T1_FILE} ${SUBJ_DIR}/anatomy/t1spgr.nii  || echo "Error!! Could NOT copy t1spgr.nii for ${newfolder} !!"
    cp -pL ${SUBJ_DIR}/anatomy/${T1_FILE} ${SUBJ_DIR}/anatomy/t1spgr.nii  || echo "Error!! Could NOT copy t1spgr.nii for ${newfolder} !!"

  fi
  N=0

  # start copying the ASL functional files
  # !! Note !! for functionals we are copying "hardlinks" to save disk space ==> less direct alterations to /func files
  echo
  echo "Now copying vasc_3dasl functional files: vasc_3dasl.nii"
  echo

  cd ${THISDIR}/${newfolder}/func

  echo
  echo "Currently at /func: " $(pwd)
  echo

  # checking if more than 1 file exists using variable N; report error if so
  mkdir run_01
  N=$(ls -1 ${RAWDIR}/${oldfolder}/${vfilepath}/vasc_3dasl*.nii 2>/dev/null | wc -l)

  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple vasc_3dasl.nii !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/${vfilepath}/vasc_3dasl*.nii

  else
    cd run_01
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ip ${RAWDIR}/${oldfolder}/${vfilepath}/vasc_3dasl.nii .

    cd ${SUBJ_DIR}
    tree

  fi
  N=0

  echo
  echo "----------------------------------------------"
  echo "      Subject copy complete, next subject     "
  echo "----------------------------------------------"
  echo

done < UMMAP_forshell_ASL_Baseline_Dec18.csv  # 61 subjects; the rest awaiting Krisanne to reconstruct

echo
echo " ==========================================================="
echo "      ALL Done !!  Processing special subject issues!!      "
echo " ==========================================================="
echo

## ==== addressing subject specific issues ====
# [tehsheng@madcbrain filestructure]$ grep 'Error' file_struct_console_ASL_UMMAP_1207_2018.txt
# Error!! Could NOT copy t1spgr.nii for madc1446_4476 !! ==> FIXED; manually linked t1spgr.nii
# Error!! Could NOT copy t1spgr.nii for madc1447_4475 !! ==> FIXED; manually linked t1spgr.nii
# Error!! Could NOT copy t1spgr.nii for madc1458_4524 !! ==> FIXED; manually linked t1spgr.nii
# Error!! Could NOT copy t1spgr.nii for madc1462_4510 !! ==> FIXED; manually linked t1spgr.nii
# Error!! Could NOT copy t1spgr.nii for madc1477_5635 !! ==> no t1 folder!!
# Error!! Could NOT copy t1spgr.nii for madc1546_5697 !! ==> no t1 folder!!

echo
echo " ==================="
echo "      COMPLETE!!    "
echo " ==================="
echo
