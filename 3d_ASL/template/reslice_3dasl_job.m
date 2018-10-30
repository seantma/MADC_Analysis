%-----------------------------------------------------------------------
% Job saved on 30-Oct-2018 13:29:09 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {'/Users/tehsheng/Dropbox/hlp17umm01220_03783/vasc_3dasl.nii,2'};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {'/Users/tehsheng/Dropbox/hlp17umm01220_03783/bet_t1mprage_208_mask.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'ecc';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'reSlice_3dasl2_';
