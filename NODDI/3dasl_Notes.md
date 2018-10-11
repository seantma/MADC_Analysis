## 3dasl Notes
10/10/2018, 4:36:05 PM

### Question - how to preprocess 3d asl?
It seems to take fMRI Lab a fair amount of time to process the correct CBF from the 3d asl images. In the midst of this, I've also encounter how to create difference maps between Scan1 & Scan2 of the **DrD_Extension** study. Although the 2 asl images were co-registered to the same T1 anatomy image, _their affine seems to differ which is causing the error_ (see error notes in code `NODDI_3dasl_Extraction.py`).

I have tried using `fslmaths sub` and need to verify whether if the result is the case. Also I want to know is there a better way to calculate the difference between image maps from the same subject.
==> I should give `SPM ImCalc` a try!

But as I was searching, I came along `FSL BASIL` https://asl-docs.readthedocs.io/en/latest/basil.html


### Resources
1. Very good information regarding GE 3d ASL acquisition from UCSD's fMRI center: https://cfmriweb.ucsd.edu/Howto/3T/asl.html
2. GE 3d ASL information: https://www.gehealthcare.com/en/products/magnetic-resonance-imaging/mr-applications/3d-asl---pediatric
