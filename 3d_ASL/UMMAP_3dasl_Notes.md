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

#### References
- Reference paper: Sun et al., 2016, Cerebral Blood Flow Alterations as Assessed by 3D ASL in Cognitive Impairment in Patients with Subcortical Vascular Cognitive Impairment: A Marker for Disease Severity https://www.frontiersin.org/articles/10.3389/fnagi.2016.00211/full
- MRI was conducted using a 3.0T MRI scanner (Signa HDxt; GE HealthCare, Milwaukee, WI, USA) at Ren Ji Hospital. A standard head coil with foam padding was used to restrict head motion. Pseudocontinuous ASL (PCASL) is the continuous ASL labeling scheme that is recommended for clinical imaging (Alsop et al., 2015). PCASL perfusion images were collected using 3D fast spin-echo acquisition with background suppression and with a labeling duration of 1500 ms and post-labeling delay of 2000 ms, as suggested in a recent study (Collij et al., 2016). Repetition time (TR) = 4580 ms, Echo time (TE) = 9.8 ms, field of view (FOV) = 240 × 240 mm, matrix = 128 × 128, flip angle = 155°, slice thickness = 4 mm. CBF maps were calculated from the perfusion-weighted images using a 2-compartment model (Alsop et al., 1996) with a finite labeling duration, as described previously (Pfefferbaum et al., 2011). In addition to perfusion images, following acquisitions were also performed: (1) 3D-fast spoiled gradient recalled (SPGR) sequence images (TR = 6.1 ms, TE = 2.8 ms, TI = 450 ms, flip angle = 15°, slice thickness = 1.0 mm, gap = 0, FOV = 256 × 256 mm2, and slices = 166); (2) T2-fluid attenuated inversion recovery (FLAIR) sequence (TE = 150 ms, TR = 9075 ms, TI = 2250 ms, FOV = 256 × 256 mm2, and slices = 66); (3) axial T2-weighted fast spin-echo sequences (TR = 3013 ms, TE = 80 ms, FOV = 256 × 256 mm2, and slices = 34), and (4) Gradient Recalled Echo (GRE) T2*-weighted sequence (TR = 53.58 ms, TE = 23.93 ms, flip angle = 20°, matrix = 320 × 288, FOV = 240 × 240 mm2, slice thickness = 2 mm, NEX = 0.7, gap = 0, and slices = 72).

#### Methods writeup
ASL data was collected with a 3.0T MRI scanner (GE HealthCare, Milwaukee, WI, USA) using GE's 3D ASL protocol, a pseudo-continuous ASL (PCASL) sequence. Perfusion images were collected using 3D fast spin-echo acquisition with background suppression and with a labeling duration of 1500 ms and post-labeling delay of 2025 ms, as suggested in a recent study (Alsop et al, 2015). CBF maps were calcuated from the perfusion-weighted images through a kinetic model equation (Buxton et al, 2015). To compare pre-post CBF map differences, a calibrating factor was derived by scaling the mean of CBF to 100 and applied for both maps. T1 anatomical images were coregistered to the perfusion-weighted image and regions of interests (ROIs) were selected as 5mm spheres closest - to the stimulation sites. CBF values for these ROIs were extracted in native space for pre-post session comparisons.
- Alsop, D. C., Detre, J. A., Golay, X., Günther, M., Hendrikse, J., Hernandez-Garcia, L., … Zaharchuk, G. (2015). Recommended implementation of arterial spin-labeled Perfusion mri for clinical applications: A consensus of the ISMRM Perfusion Study group and the European consortium for ASL in dementia. Magnetic Resonance in Medicine, 73(1), 102–116.
- Buxton RB, Frank LR, Wong EC, Siewert B, Warach S, Edelman RR. A general kinetic model for quantitative perfusion imaging with arte- rial spin labeling. Magn Reson Med 1998;40:383–396.

#### Resources
1. Very good information regarding GE 3d ASL acquisition from UCSD's fMRI center: https://cfmriweb.ucsd.edu/Howto/3T/asl.html
2. GE 3d ASL information: https://www.gehealthcare.com/en/products/magnetic-resonance-imaging/mr-applications/3d-asl---pediatric
3. Great book for ASL: `Introduction to perfusion qualification using arterial spin labeling` by Michael Chappell.
