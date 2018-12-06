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
  echo "current dir: $(pwd)"
  T1_DIR=$(ls -d ${RAWDIR}/${oldfolder}/anatomy/* | grep -E 't1mprage|t1sag')
  echo "T1 dir: ${T1_DIR}"
  # checking if more than 1 file exists; report error if so
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/${T1_DIR}/{t1mprage*,t1sag*} 2>/dev/null | wc -l)

  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple t1spgr in /anatomy !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/${T1_DIR}/{t1mprage*,t1sag*}

  else
    T1_FILE=$(ls ${T1_DIR} | grep -E '^t1mprage|^t1sag')
    echo "T1 file is: ${T1_FILE}"
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    # !!Note!! switching back to cp -ip for /anatomy files due to direct alterations
    # !!Note!! linking symbolic links first then do an actual cp -pL dereference copy
    # adding || as try/catch mechanism
    # ln -s ${T1_DIR}/${T1_FILE} ${T1_FILE}
    cp -pL ${T1_FILE} ${SUBJ_DIR}/t1spgr.nii  || echo "Error!! Could NOT copy t1spgr.nii for ${newfolder} !!"

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
  N=$(ls -1 ${RAWDIR}/${oldfolder}/${vfilepath}/vasc_3dasl* 2>/dev/null | wc -l)

  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple vasc_3dasl.nii !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/${vfilepath}/vasc_3dasl*

  else
    cd run_01
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ip ${RAWDIR}/${oldfolder}/${vfilepath}/vasc_3dasl.nii .

    cd ..
    ls -laR
  fi
  N=0

  echo
  echo "----------------------------------------------"
  echo "      Subject copy complete, next subject     "
  echo "----------------------------------------------"
  echo

done < UMMAP_forshell_ASL.csv

echo
echo " ==========================================================="
echo "      ALL Done !!  Processing special subject issues!!      "
echo " ==========================================================="
echo

## ==== addressing specific subject issues ====
# !! since PCN only gets 1 anatomical scan as there are repeated treatments !!
# [tehsheng@bhampste-fmri DARTEL]$ grep -i 'Error' file_struct_console_DARTEL_0728_2017.txt

# cd ${THISDIR}/Fease_scan2/anatomy
# rm t1spgr*.nii
# ln -s ${RAWDIR}/bmh16ptrf00048_03838/anatomy/t1spgr_208/t1spgr_208.nii t1spgr_208.nii
# cp -pL t1spgr_208.nii t1spgr.nii


echo
echo " ==================="
echo "      COMPLETE!!    "
echo " ==================="
echo
