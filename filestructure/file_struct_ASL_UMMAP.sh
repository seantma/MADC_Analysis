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
# sh file_struct_ASL_DrD_Ext.sh 2>&1 | tee file_struct_console_ASL_DrD_Ext_$(date +"%m%d_%Y").txt
#
# - How to check error:
# grep -i 'no such file' file_struct_console_Task_1222_2016.txt
#
# - How to generate directory listing for FirstLevel_mc_template.m
# ls -d */ > dir_struct_{$date}.txt
#
# !!TODO(Sean): 1. print out original file directory and file name of t1spgr_208

THISDIR=/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Subjects_ASL
RAWDIR=/mnt/psych-bhampstelab/Patient_Centered_Neurorehab

echo
echo "*** This script is for PCN ASL file structure purpose!! ***"
echo

# number of files index
N=0

# for loop to read from input .csv
while IFS="," read -r oldfolder newfolder
do
  # making fmri analysis folder in /Subjects
  cd ${THISDIR}
  mkdir "${newfolder}"
  cd ${newfolder}

  echo
  echo "Current subject: " $(pwd)
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

  # checking if more than 1 file exists; report error if so
  cd anatomy
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/t1spgr_208sl/ht1spgr_208* 2>/dev/null | wc -l)

  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple t1spgr in /anatomy !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/t1spgr_208sl/ht1spgr_208*

  else
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    # !!Note!! switching back to cp -ip for /anatomy files due to direct alterations
    # !!Note!! linking symbolic links first then do an actual cp -pL dereference copy
    # adding || as try/catch mechanism
    ln -s ${RAWDIR}/${oldfolder}/anatomy/t1spgr_208sl/ht1spgr_208sl.nii ht1spgr_208sl.nii
    cp -pL ht1spgr_208sl.nii ht1spgr.nii  || echo "Error!! Subject: ${newfolder} has no ht1spgr.nii exists!!"

  fi
  N=0

  # start copying the ASL functional files
  # !! Note !! for functionals we are copying "hardlinks" to save disk space ==> less direct alterations to /func files
  echo
  echo "Now copying vasc_3dasl functional files: vasc_3dasl.nii"
  echo

  cd ../func

  echo
  echo "Currently at /func: " $(pwd)
  echo

  # checking if more than 1 file exists using variable N; report error if so
  mkdir run_01
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/vasc_3dasl/vasc_3dasl* 2>/dev/null | wc -l)

  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple vasc_3dasl.nii !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/vasc_3dasl/vasc_3dasl*

  else
    cd run_01
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ip ${RAWDIR}/${oldfolder}/anatomy/vasc_3dasl/vasc_3dasl.nii .

    cd ..
    ls -laR
  fi
  N=0

  echo
  echo "----------------------------------------------"
  echo "      Subject copy complete, next subject     "
  echo "----------------------------------------------"
  echo

done < PCN_forshell_ASL_DrD_Ext.csv
# bmh17ptre00002_05201,DrD_Ext_scan1
# bmh17ptre20002_05472,DrD_Ext_scan2

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
