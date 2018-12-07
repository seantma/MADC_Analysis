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
# sh ./preprocessing_UMMAP_ASL.sh
# How to check error:
#
# --------------------------------------------------

# Subject list based off of `file_struct.sh` output: `file_struct_out_1222_2016.txt`
# Does not contain filtered out subjects from QC check

subjIDs=(
  # #Batch 1
  # madc0798_5794
  # madc0799_5795
  # madc1040_5745
  # madc1182_5506
  # madc1220_3783
  # madc1243_4201
  # madc1246_5153
  # madc1252_5187
  # madc1263_3874
  # madc1276_3938
  # madc1299_5225
  # madc1307_5883
  # madc1320_5807
  # madc1348_5194
  # madc1350_5521
  # madc1371_5133
  # madc1373_5314
  # madc1384_5358
  # madc1387_5556
  # madc1389_3696
  # madc1395_5848
  #Batch 2
  madc1416_5640
  madc1417_5641
  madc1435_5392
  madc1446_4476
  madc1447_4475
  madc1458_4524
  madc1462_4510
  madc1476_5633
  # madc1477_5635   #no T1 in original folder
  madc1483_5200
  madc1487_4682
  madc1492_5182
  madc1500_5193
  madc1508_5049
  madc1511_5424
  madc1513_5315
  madc1519_5232
  madc1530_5703
  madc1531_5159
  madc1532_5160
  madc1535_5853
  madc1537_5308
  # Batch 3
  madc1539_5154
  madc1543_5181
  madc1544_5549
  madc1545_5550
  # madc1546_5697   #no T1 in original folder
  madc1549_5224
  madc1550_5702
  madc1550_5786
  madc1555_5471
  madc1556_5503
  madc1557_5890
  madc1561_5696
  madc1564_5806
  madc1565_5522
  madc1572_5785
  madc1575_5746
  madc1588_5891
  madc1595_5847
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
  coregOverlay -M ../../Subjects_ASL ${SUBJECT} -v vasc_3dasl -o t1spgr -B &> ${PSTAGE}_${LOCAL_LOG}
  # coregOverlay -M ../../Subjects_ASL ${SUBJECT} -v rtprun_ -o ht1overlay -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  # !! Note no t1overlay.nii ==> using `coregOverlay` to coregister directly rtprun.nii to t1spgr.nii !!
  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *coregHiRes* * * * * * "
  # echo
  # coregHiRes -M ../../Subjects_ASL ${SUBJECT} -o ht1overlay -h t1spgr -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}

  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *newSeg* * * * * * "
  # echo
  # newSeg -a func/coReg -w func/coReg/newSeg -M ./ ${SUBJECT} -h t1spgr -I r3mm_avg152T1 -n wns3mm_ -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}
  #
  # let STAGE++
  # PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  # echo
  # echo "* * * * * * *warpfMRI* * * * * * "
  # echo
  # warpfMRI -W -w coReg/newSeg -M ./ ${SUBJECT} -h t1spgr -v rtrun_ -n wns3mm_ -I r3mm_avg152T1 -B &> ${PSTAGE}_${LOCAL_LOG}
  # cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *vbm8HiRes* * * * * * "
  echo
  vbm8HiRes -a func/coReg -w func/coReg/vbm8 -M ../../Subjects_ASL ${SUBJECT} -h t1spgr -n vbm8_w2mm_ -I PET -B &> ${PSTAGE}_${LOCAL_LOG}
  cat ${UMSTREAM_STATUS_FILE}

  let STAGE++
  PSTAGE=`echo $STAGE | awk '{printf "%02d",$1}'`
  echo
  echo "* * * * * * *warpfMRI* * * * * * "
  echo
  warpfMRI -W -w coReg/vbm8 -M ../../Subjects_ASL ${SUBJECT} -h t1spgr -v vasc_3dasl -n vbm8_w2mm_ -I PET -B &> ${PSTAGE}_${LOCAL_LOG}
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
