addpath(genpath('/opt/tools/niftimatlib-1.2'))
addpath(genpath('/opt/tools/NODDI_toolbox_v1.01'))
CreateROI('erun_01.nii', 'erun_01_bet_mask.nii', 'NODDI_roi.mat')
protocol = FSL2Protocol('ummap.bval', 'ummap.bvec');
noddi = MakeModel('WatsonSHStickTortIsoV_B0');
batch_fitting('NODDI_roi.mat', protocol, noddi, 'FittedParams.mat', 7);
SaveParamsAsNIfTI('FittedParams.mat', 'NODDI_roi.mat', 'erun_01_bet_mask.nii', 'madc1347')
