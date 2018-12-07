## 3dasl Notes
10/10/2018, 4:36:05 PM

### Question 1 - how to preprocess 3d asl?
It seems to take fMRI Lab a fair amount of time to process the correct CBF from the 3d asl images. In the midst of this, I've also encounter how to create difference maps between Scan1 & Scan2 of the **DrD_Extension** study. Although the 2 asl images were co-registered to the same T1 anatomy image, _their affine seems to differ which is causing the error_ (see error notes in code `NODDI_3dasl_Extraction.py`).

I have tried using `fslmaths sub` and need to verify whether if the result is the case. Also I want to know is there a better way to calculate the difference between image maps from the same subject.
==> I should give `SPM ImCalc` a try!

But as I was searching, I came along `FSL BASIL` https://asl-docs.readthedocs.io/en/latest/basil.html

### Question 2 - how to coregister pre-post T1 anatomy to middle image
This question was asked by Ben on how different source of T1 and coregistering with it will change the outcome of ASL measures. While I'm still searching on _how to create a middle image between the pre-post T1 anatomy_, my initial thought is to compare the results when using each pre-post T1 images as coregistration sources.

### Steps taken
1. Copy anatomy and vasc_3dasl files to analysis folder.
2. Backup anatomy file to allow **Estimation** of `CoRegistration` can be overwritten (it's always best to check to original and coregistered anatomy on top of perfusion weighted images).
    - `for dir in */; do cp -p $dir/t1mprage_208.nii $dir/t1mprage_208.nii.bakup; done`
3. Coregistration: _vasc_3dasl as reference image, anatomy as target_
    - `Batch_CoReg.m`
    - % write out CBF to nii - 3 files:
        1. calibrated CBF map,
        2. brain-masked calibrated CBF map
        3. mean scaled to 100, brain-masked calibrated CBF map
        `write_nii(strcat('cbfmap_', asl_filename), cbfmap, h2, 0)`
        `write_nii(strcat('cbfmap_anat_', asl_filename), cbfmap_anat, h2, 0)`
        `write_nii(strcat('cbfmap_anat_mean100_', asl_filename), cbfmap_anat100, h2, 0)`
4. Generate skull-strip BET mask **!!This needs to happen AFTER CoRegistration!!**
    - `for dir in */; do bet2 $dir/t1mprage_208.nii $dir/bet_t1mprage_208 -m; done`
    - `for dir in */; do gunzip $dir/bet_t1mprage_208_mask.nii.gz; done`
5. reSlice BET mask to vasc_3dasl space
6. CBF calibration
7. move files back to Github folder
8. copy roi.csv to each folder
    - `for i in hlp*/; do cp LRTC_roi_10mm.csv $i; done`

### References
- Reference paper: Sun et al., 2016, Cerebral Blood Flow Alterations as Assessed by 3D ASL in Cognitive Impairment in Patients with Subcortical Vascular Cognitive Impairment: A Marker for Disease Severity https://www.frontiersin.org/articles/10.3389/fnagi.2016.00211/full
- MRI was conducted using a 3.0T MRI scanner (Signa HDxt; GE HealthCare, Milwaukee, WI, USA) at Ren Ji Hospital. A standard head coil with foam padding was used to restrict head motion. Pseudocontinuous ASL (PCASL) is the continuous ASL labeling scheme that is recommended for clinical imaging (Alsop et al., 2015). PCASL perfusion images were collected using 3D fast spin-echo acquisition with background suppression and with a labeling duration of 1500 ms and post-labeling delay of 2000 ms, as suggested in a recent study (Collij et al., 2016). Repetition time (TR) = 4580 ms, Echo time (TE) = 9.8 ms, field of view (FOV) = 240 × 240 mm, matrix = 128 × 128, flip angle = 155°, slice thickness = 4 mm. CBF maps were calculated from the perfusion-weighted images using a 2-compartment model (Alsop et al., 1996) with a finite labeling duration, as described previously (Pfefferbaum et al., 2011). In addition to perfusion images, following acquisitions were also performed: (1) 3D-fast spoiled gradient recalled (SPGR) sequence images (TR = 6.1 ms, TE = 2.8 ms, TI = 450 ms, flip angle = 15°, slice thickness = 1.0 mm, gap = 0, FOV = 256 × 256 mm2, and slices = 166); (2) T2-fluid attenuated inversion recovery (FLAIR) sequence (TE = 150 ms, TR = 9075 ms, TI = 2250 ms, FOV = 256 × 256 mm2, and slices = 66); (3) axial T2-weighted fast spin-echo sequences (TR = 3013 ms, TE = 80 ms, FOV = 256 × 256 mm2, and slices = 34), and (4) Gradient Recalled Echo (GRE) T2*-weighted sequence (TR = 53.58 ms, TE = 23.93 ms, flip angle = 20°, matrix = 320 × 288, FOV = 240 × 240 mm2, slice thickness = 2 mm, NEX = 0.7, gap = 0, and slices = 72).

### Methods writeup
ASL data was collected with a 3.0T MRI scanner (GE HealthCare, Milwaukee, WI, USA) using GE's 3D ASL protocol, a pseudo-continuous ASL (PCASL) sequence. Perfusion images were collected using 3D fast spin-echo acquisition with background suppression and with a labeling duration of 1500 ms and post-labeling delay of 2025 ms, as suggested in a recent study (Alsop et al, 2015). CBF maps were calcuated from the perfusion-weighted images through a kinetic model equation (Buxton et al, 2015). To compare pre-post CBF map differences, a calibrating factor was derived by scaling the mean of CBF to 100 and applied for both maps. T1 anatomical images were coregistered to the perfusion-weighted image and regions of interests (ROIs) were selected as 5mm spheres closest - to the stimulation sites. CBF values for these ROIs were extracted in native space for pre-post session comparisons.
- Alsop, D. C., Detre, J. A., Golay, X., Günther, M., Hendrikse, J., Hernandez-Garcia, L., … Zaharchuk, G. (2015). Recommended implementation of arterial spin-labeled Perfusion mri for clinical applications: A consensus of the ISMRM Perfusion Study group and the European consortium for ASL in dementia. Magnetic Resonance in Medicine, 73(1), 102–116.
- Buxton RB, Frank LR, Wong EC, Siewert B, Warach S, Edelman RR. A general kinetic model for quantitative perfusion imaging with arte- rial spin labeling. Magn Reson Med 1998;40:383–396.

### Resources
1. Very good information regarding GE 3d ASL acquisition from UCSD's fMRI center: https://cfmriweb.ucsd.edu/Howto/3T/asl.html
2. GE 3d ASL information: https://www.gehealthcare.com/en/products/magnetic-resonance-imaging/mr-applications/3d-asl---pediatric
3. Great book for ASL: `Introduction to perfusion qualification using arterial spin labeling` by Michael Chappell.
