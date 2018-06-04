#!/bin/bash
#
# Shell script for structuring subject folders
# - based off of R generated .csv: eg. ben_newfolder_forshell_QC.csv
# - R source code: folder_structure.R
#
# Sean Ma
# Dec 2016
# Jul 2017 - upgrade to use cp -ipal for "hardlink" to files
#
# TODOs:
# - !! NEED !! Check if multiple t1spgr, t1overlay, exists!
# - integrate with Makefile for fault tolerance and parallelization
#
# - How to run:
# sh file_struct_resting.sh 2>&1 | tee file_struct_out_Resting_$(date +"%m%d_%Y").txt
# - How to check error:
# grep -i 'no such file' file_struct_out_1222_2016.txt
# - How to generate directory listing for FirstLevel_mc_template.m
# ls -d */ > dir_struct_{$date}.txt
#
# TODO(Sean): 1. print out original file directory and file name of t1spgr_156sl

THISDIR=/mnt/psych-bhampstelab/NIMH_PTSD_R21/Sean_Working/Subjects_Resting
RAWDIR=/mnt/psych-bhampstelab/NIMH_PTSD_R21

echo
echo "*** This script is for Resting state file structure purpose!! ***"
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
  echo "Copying and linking ht1spgr.nii for Resting state"
  echo

  # checking if more than 1 file exists; report error if so
  cd anatomy
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/t1spgr_156sl/ht1spgr_156sl* 2>/dev/null | wc -l)
  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple t1spgr in /anatomy !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/t1spgr_156sl/ht1spgr_156sl*
  else
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ipal ${RAWDIR}/${oldfolder}/anatomy/t1spgr_156sl/ht1spgr_156sl.nii .
    ln -s ht1spgr_156sl.nii ht1spgr.nii
  fi
  N=0

  # copying overlay.nii and linking them for preprocessing
  echo
  echo "Copying and linking ht1overlay.nii for Resting state"
  echo

  # checking if more than 1 file exists; report error if so
  N=$(ls -1 ${RAWDIR}/${oldfolder}/anatomy/t1spgr_156sl/ht1overlay_45slresting* 2>/dev/null | wc -l)
  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple t1overlay in /anatomy !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/anatomy/t1spgr_156sl/ht1overlay_45slresting*
  else
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ipal ${RAWDIR}/${oldfolder}/anatomy/t1overlay_45slresting/ht1overlay_45slresting.nii .
    ln -s ht1overlay_45slresting.nii ht1overlay.nii
    ls -la
  fi
  N=0

  # start copying the functional files
  echo
  echo "Now copying Resting state functional files: rtprun_01.nii, run_01.nii, realign.dat"
  echo

  cd ../func

  echo
  echo "Currently at /func: " $(pwd)
  echo

  # checking if more than 1 file exists; report error if so
  mkdir run_01
  N=$(ls -1 ${RAWDIR}/${oldfolder}/func/resting/run_01/rtprun_01* 2>/dev/null | wc -l)
  if ((N >= 2)); then
    echo
    echo "****** !! Error !! Subject: ${newfolder} has multiple rtprun_01 in /func !! ******"
    ls -1a ${RAWDIR}/${oldfolder}/func/resting/run_01/rtprun_01*
  else
    cd run_01
    # previously using cp -ip --> occupying too much space; using hardlinks instead
    cp -ipal ${RAWDIR}/${oldfolder}/func/resting/run_01/rtprun_01.nii .
    cp -ipal ${RAWDIR}/${oldfolder}/func/resting/run_01/run_01.nii .
    cp -ipal ${RAWDIR}/${oldfolder}/func/resting/run_01/realign.dat .
    cd ..

    ls -laR

    echo
    echo " ========================================================="
    echo "              Copy complete, next subject"
    echo " ========================================================="
    echo
  fi

done < PTSD_forshell_resting_0914.csv    # last batch of subjects for PTSD
# done < PTSD_forshell_resting_0719.csv    # 1st run for PTSD
