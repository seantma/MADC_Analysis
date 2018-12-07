#!/bin/bash
#
#
# Robert C. Welsh
#
# Copyright 2013
#
# This stream is for testing the spm8Batch system
# To run this you should be in a directory with the subject master
# folder just below you. Then issue the command
#
# --------------------------------------------------
#
# Sean Ma, modified, Dec 2016
#
# 12/15/2016, Modified for automation purpose (single subject)
# 12/22/2016, added loop for multi subjects
#
# How to run:
# sh ./preprocessing_DrD_Ext_ASL.sh
# How to check error:
#
# --------------------------------------------------

# Subject list based off of `file_struct.sh` output: `file_struct_out_1222_2016.txt`
# Does not contain filtered out subjects from QC check

subjIDs=(
  DrD_Ext_ASL_scan1
  DrD_Ext_ASL_scan2
)

for SUBJECT in ${subjIDs[@]}
do

  LOCAL_LOG=full_stream_${SUBJECT}_validation.log

  THEDATE=`date`

  echo
  echo Start $THEDATE
  echo

  THISDIR=`pwd`
  export UMSTREAM_STATUS_FILE=${THISDIR}/${SUBJECT}_validation_umstream_status_file

  let STAGE=0

  # !! Note no t1overlay.nii ==> using `coregOverlay` to coregister directly rtprun.nii to t1spgr.nii !!
  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *coregOverlay* * * * * * "
  echo
  coregOverlay -M ../../Subjects_ASL ${SUBJECT} -v vasc_3dasl -o ht1spgr -B &> ${PSTAGE}_${LOCAL_LOG}
  # coregOverlay -M ../../Subjects_ASL ${SUBJECT} -v rtprun_ -o ht1overlay -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  # !! Note no t1overlay.nii ==> using `coregOverlay` to coregister directly rtprun.nii to t1spgr.nii !!
  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *coregHiRes* * * * * * "
  # echo
  # coregHiRes -M ../../Subjects_ASL ${SUBJECT} -o ht1overlay -h ht1spgr -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}

  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *newSeg* * * * * * "
  # echo
  # newSeg -a func/coReg -w func/coReg/newSeg -M ./ ${SUBJECT} -h ht1spgr -I r3mm_avg152T1 -n wns3mm_ -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}
  #
  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *warpfMRI* * * * * * "
  # echo
  # warpfMRI -W -w coReg/newSeg -M ./ ${SUBJECT} -h ht1spgr -v rtrun_ -n wns3mm_ -I r3mm_avg152T1 -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *vbm8HiRes* * * * * * "
  echo
  vbm8HiRes -a func/coReg -w func/coReg/vbm8 -M ../../Subjects_ASL ${SUBJECT} -h ht1spgr -n vbm8_w2mm_ -I PET -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *warpfMRI* * * * * * "
  echo
  warpfMRI -W -w coReg/vbm8 -M ../../Subjects_ASL ${SUBJECT} -h ht1spgr -v vasc_3dasl -n vbm8_w2mm_ -I PET -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *Smoothing* * * * * * "
  echo
  smoothfMRI 5 5 5 -M ../../Subjects_ASL ${SUBJECT} -v vbm8_w2mm_vasc_3dasl -n s5 -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  echo
  echo Finished
  echo

  echo Concatenating logs
  echo
  cat [0,1][0-9]_${LOCAL_LOG} > ${LOCAL_LOG}

  echo
  echo "Completed, full log can be found in ${LOCAL_LOG}"
  echo

  THEDATE=`date`

  echo
  echo Done $THEDATE
  echo

done
