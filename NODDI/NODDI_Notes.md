## Notes on NODDI
Sean Ma
9/14/2018, 10:20:26 AM

Scripts adopted heavily from UCL MIG's **NODDI Toolbox** tutorial: http://mig.cs.ucl.ac.uk/index.php?n=Tutorial.NODDImatlab . Also learned that _Daducci et al._ created another toolbox with faster method of calculation, named **AMICO** (maintained in `python`; although Scott is using their deprecated `Matlab` scripts): https://github.com/daducci/AMICO

### UMMAP Protocol
There should be 96 volumes in the UMMAP NODDI DTI image. The bval/bvec values are posted below.

### Resources
_UMich-TAD-Lab_ has some great resources on how to train RAs to identify artifacts in DTI images: https://github.com/UMich-TAD-Lab/dti-qc-training

### Procedures
1. Strip out initial redundant B0 volumes if existing (derived by `dcm2nii`)
    `fslroi run_01.nii run_01_noB0.nii 6 96`
2. Eddy correct the DTI image
    `eddy_correct run_01_noB0.nii eddy_run_01_noB0.nii 0`
3. Skull extraction with `bet2`
    ```shell
    bet2 eddy_run_01_noB0.nii.gz eddy_run_01_noB0_bet -m
    gunzip eddy_run_01_noB0.nii.gz
    gunzip eddy_run_01_noB0_bet_mask.nii.gz
    ```
4. Call `MATLAB` with `NODDI Toolbox`
    ```matlab
    addpath(genpath('/opt/tools/niftimatlib-1.2'))
    addpath(genpath('/opt/tools/NODDI_toolbox_v1.01'))
    CreateROI('eddy_run_01_noB0.nii','eddy_run_01_noB0_bet_mask.nii','NODDI_roi.mat')
    protocol = FSL2Protocol('ummap.bval', 'ummap.bvec');
    noddi = MakeModel('WatsonSHStickTortIsoV_B0');
    noddi = MakeModel('BinghamStickTortIsoV_B0');   % Bingham model
    batch_fitting('NODDI_roi.mat', protocol, noddi, 'FittedParams.mat', 4);
    SaveParamsAsNIfTI('FittedParams.mat', 'NODDI_roi.mat', 'eddy_run_01_noB0_bet_mask.nii', 'PCN_DrD_Ext_scan1')
    SaveParamsAsNIfTI('FittedParams.mat', 'NODDI_roi.mat', 'eddy_run_01_noB0_bet_mask.nii', 'DrD_Ext_scan1')
    ```
### Output
Output files analyzed are listed below with brief descrpition:

- Neurite density (or intra-cellular volume fraction): example_ficvf.nii
- Orientation dispersion index (ODI): example_odi.nii
- CSF volume fraction: example_fiso.nii
- Fibre orientation: example_fibredirs_{x,y,z}vec.nii
- Fitting objective function values: example_fmin.nii
- Concentration parameter of Watson distribution used to compute ODI: example_kappa.nii
- Error code: example_error_code.nii (NEW) Nonzero values indicate fitting errors.


### UMMAP Camino format bval/bvec
8VERSION: BVECTOR
0 0 0 0
-0.6549 -0.3557 -0.6668 2000
0.2719 0.934 0.2319 2000
-0.3258 0.3692 0.3362 711
-0.1188 0.1104 0.9868 2000
-0.3269 0.8665 0.3772 2000
0.2379 0.3577 -0.4135 711
-0.3948 -0.1083 0.9124 2000
-0.9063 0.3493 -0.2381 2000
0.3506 0.311 0.3686 711
0.5663 -0.4709 0.6764 2000
0.0333 -0.5915 -0.0676 711
0.5585 -0.6652 -0.4955 2000
0.6489 0.612 0.4521 2000
0.3977 0.4042 -0.1843 711
0.4352 -0.4979 -0.7501 2000
-0.0601 0.9726 0.2244 2000
0.0976 0.3178 0.495 711
-0.2903 0.6194 -0.7294 2000
0 0 0 0
0.0088 0.5487 -0.8359 2000
-0.0988 -0.638 -0.7637 2000
0.3237 0.0798 0.4943 711
-0.1629 -0.9173 0.3634 2000
0.095 -0.8218 0.5617 2000
-0.0446 -0.2089 0.5567 711
-0.215 0.7211 0.6587 2000
-0.7416 -0.0399 -0.6696 2000
0.5043 -0.2854 -0.1406 711
-0.8479 -0.2004 0.4909 2000
0.4574 -0.3641 0.1171 711
0.9432 -0.3042 -0.1338 2000
0.2157 0.7327 -0.6454 2000
0.1692 -0.2275 -0.5245 711
0.0604 0.2236 -0.9728 2000
0.8147 0.5611 0.1462 2000
-0.3203 0.3674 -0.3434 711
0.266 -0.3351 0.9039 2000
0 0 0 0
0.442 -0.7645 0.4692 2000
0.5661 -0.8076 0.1651 2000
0.4242 -0.1179 -0.4021 711
0.7166 -0.5846 0.3804 2000
-0.3313 0.943 0.0309 2000
0.5286 0.1306 0.243 711
-0.4657 -0.168 -0.8688 2000
0.4807 0.7893 -0.382 2000
0.1765 0.5026 0.2678 711
0.9614 0.2531 0.1082 2000
-0.559 -0.2033 0.0411 711
0.9204 -0.004 0.3911 2000
0.3933 0.9154 -0.0853 2000
-0.2378 -0.5468 -0.0005 711
-0.8523 -0.3246 -0.4102 2000
0.5712 0.7994 0.1861 2000
0.058 -0.4245 0.4147 711
-0.5354 0.1672 -0.8279 2000
-0.4428 0.2032 0.8733 2000
0 0 0 0
-0.1438 0.4313 0.8907 2000
-0.1857 0.5418 -0.1658 711
0.8935 0.4149 -0.172 2000
-0.7958 0.5114 0.3242 2000
-0.2576 -0.0535 0.535 711
-0.3991 -0.5239 -0.7525 2000
-0.8065 0.5906 -0.0268 2000
0.5664 -0.0184 -0.1853 711
0.6914 0.7102 -0.1327 2000
-0.0875 0.4841 0.3368 711
-0.9738 -0.0801 0.2126 2000
0.0521 0.996 -0.0721 2000
0.1027 0.5417 -0.2269 711
0.6967 -0.0344 -0.7165 2000
-0.6263 -0.2862 0.7252 2000
0.3024 -0.506 -0.0897 711
-0.9941 0.0727 -0.0804 2000
0 0 0 0
-0.7389 -0.5195 0.429 2000
-0.7022 0.3532 0.6182 2000
0.4357 0.39 0.1163 711
-0.5051 -0.5816 0.6377 2000
0.3712 0.7702 0.5187 2000
0.0464 0.0566 0.5917 711
0.0509 0.8584 0.5105 2000
0.1706 0.3255 0.93 2000
-0.2289 0.1753 -0.5219 711
-0.3122 -0.4225 0.8509 2000
0.47 -0.1274 0.3441 711
-0.887 0.1522 0.4359 2000
0.6058 -0.7763 -0.1742 2000
0.4486 0.1797 -0.3493 711
-0.2158 0.9371 -0.2743 2000
0.2108 -0.0134 0.9774 2000
-0.5818 0.0987 -0.0855 711
0.7879 -0.2745 0.5513 2000
0 0 0 0
