### UMMAP 3dasl Notes
Sean Ma
12/6/2018, 12:09:12 PM

#### Steps taken
1. **File structuring**:
    - `/filestructure/file_struct_ASL_UMMAP.sh`
    - example output:
      madc1595_5847/
      ├── anatomy
      │   ├── t1sag_208.nii ->    /nfs/fmri/RAW_nopreprocess/hlp17umm01595_05847/anatomy/t1sag_208/t1sag_208.nii
      │   └── t1spgr.nii
      └── func
          └── run_01
              └── vasc_3dasl.nii

2. **preprocessing**:
    - `/preprocess/preprocessing_UMMAP_ASL.sh`
    - example output:
      madc1595_5847/
      ├── anatomy
      │   ├── t1sag_208.nii -> /nfs/fmri/RAW_nopreprocess/hlp17umm01595_05847/anatomy/t1sag_208/t1sag_208.nii
      │   └── t1spgr.nii
      └── func
        ├── coReg
        │   ├── t1spgr.nii
        │   └── vbm8
        │       ├── bet_mt1spgr.nii
        │       ├── bet_t1spgr.nii
        │       ├── CSF_eroMask_vbm8_w2mm_p3t1spgr.nii
        │       ├── m0wrp1t1spgr.nii
        │       ├── m0wrp2t1spgr.nii
        │       ├── mt1spgr.nii
        │       ├── p0t1spgr.nii
        │       ├── p1t1spgr.nii
        │       ├── p2t1spgr.nii
        │       ├── p3t1spgr.nii
        │       ├── pt1spgr_seg8.txt
        │       ├── t1spgr.nii
        │       ├── t1spgr_seg8.mat
        │       ├── vbm8_w2mm_bet_t1spgr.nii
        │       ├── vbm8_w2mm_mt1spgr.nii
        │       ├── vbm8_w2mm_p0t1spgr.nii
        │       ├── vbm8_w2mm_p1t1spgr.nii
        │       ├── vbm8_w2mm_p2t1spgr.nii
        │       ├── vbm8_w2mm_p3t1spgr.nii
        │       ├── vbm8_w2mm_t1spgr.nii
        │       ├── WM_eroMask_vbm8_w2mm_p2t1spgr.nii
        │       ├── wmrt1spgr.nii
        │       ├── wrp0t1spgr.nii
        │       ├── wrp1t1spgr.nii
        │       ├── wrp2t1spgr.nii
        │       ├── wrp3t1spgr.nii
        │       └── y_rt1spgr.nii
        └── run_01
            ├── s5vbm8_w2mm_vasc_3dasl.mat
            ├── **s5vbm8_w2mm_vasc_3dasl.nii**
            ├── vasc_3dasl.nii
            ├── vbm8_w2mm_vasc_3dasl.nii
            └── wvasc_3dasl.mat

3. **CBF map calculation**
    - `/3d_ASL/Batch_cbf_calc.m` which calls `/3d_ASL/cbf_calc.m` for the actual calculation of CBF maps. Adopted from `cbf_calc_SeanUpdate.m` where I modified Scott's original code `cbf_calc_Scott.m`.
    - 4 files are generated and described below:
        - cbfmap_anat_mean100_s5vbm8_w2mm_vasc_3dasl.nii: calibrated CBF map, mean scaled to 100, with subject's anatomy mask
        - cbfmap_anat_s5vbm8_w2mm_vasc_3dasl.nii: calibrated CBF map, with subject's anatomy mask
        - cbfmap_mean100_s5vbm8_w2mm_vasc_3dasl.nii: calibrated CBF map, mean scaled to 100
        - cbfmap_s5vbm8_w2mm_vasc_3dasl.nii: calibrated CBF map
