% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/mnt/psych-bhampstelab/Patient_Centered_Neurorehab/Sean_Working/Git_PCN/rois/Neurosynth_DMN/CoReg_ReSlice_ROIs_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});
