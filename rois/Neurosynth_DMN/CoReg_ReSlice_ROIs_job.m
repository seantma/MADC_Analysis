%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.coreg.write.ref = {'/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Subjects_Resting/DrD_scan4/func/run_01/s5vbm8_w3mm_rtprun_01.nii,1'};
%%
matlabbatch{1}.spm.spatial.coreg.write.source = {
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_L_IPL.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_L_LTC.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_L_MFG.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_L_MTL.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_R_IPL.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_R_LTC.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_R_MFG.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_R_MTL.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_dmPFC.img,1'
                                                 '/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/neurosynth_pcc.img,1'
                                                 };
%%
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'reSlice8_';
