%
% Initialization for AMICO
%
% NB: DO NOT MODIFY THIS FILE!
%     Make a copy of it, adapt to your paths and rename it to "AMICO_Setup.m"
%

global AMICO_code_path AMICO_data_path CAMINO_path CONFIG
global niiSIGNAL niiMASK
global KERNELS bMATRIX

% Path definition: adapt these to your needs
% ==========================================
AMICO_code_path = '/Users/spelt/Work_Scott/NODDI/AMICO_matlab-master';
AMICO_data_path = '/Users/spelt/Work_Scott/NODDI/AMICO_data/ummap/subj1/try_again/';
CAMINO_path     = 'absolute path to CAMINO bin folder';
NODDI_path      = '/Users/spelt/Work_Scott/NODDI/NODDI_toolbox_v0.9';
SPAMS_path      = '/Users/spelt/Work_Scott/NODDI/spams-matlab-v2.6';

if ~isdeployed
    addpath( genpath(NODDI_path) )
    addpath( fullfile(SPAMS_path,'build') )
    addpath( fullfile(AMICO_code_path,'kernels') )
    addpath( fullfile(AMICO_code_path,'models') )
    addpath( fullfile(AMICO_code_path,'optimization') )
    addpath( fullfile(AMICO_code_path,'other') )
    addpath( fullfile(AMICO_code_path,'vendor','NIFTI') )
end
