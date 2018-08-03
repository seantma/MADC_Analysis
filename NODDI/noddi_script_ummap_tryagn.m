 addpath(genpath('/Users/spelt/Work_Scott/NODDI/AMICO_matlab-master'))

% addpath(genpath('/Users/spelt/Work_Scott/NODDI/NODDI_toolbox_v0.9')) 
%%
tic; AMICO_Setup_ummap; toc     %%Elapsed time is 0.142097 seconds.
%%

tic; AMICO_PrecomputeRotationMatrices(); toc

%-> Precomputing rotation matrices for l_max=12:
%   [ 53.9 seconds ]
%Elapsed time is 53.978348 seconds.
%%
tic; AMICO_SetSubject( 'subj1', 'again' ); toc     %Elapsed time is 0.009932 seconds.

%%
CONFIG.dwiFilename    = fullfile( CONFIG.DATA_path, 'run_01.nii' );
%CONFIG.maskFilename   = fullfile( CONFIG.DATA_path, 'roi_mask.hdr' );
CONFIG.maskFilename   = fullfile( CONFIG.DATA_path, 'automask.nii' );
CONFIG.schemeFilename = fullfile( CONFIG.DATA_path, 'UMMAP_NODDI.scheme' );

%%

tic; AMICO_LoadData; toc
%%
%
%-> Loading and setup:
%	* Loading DWI...
%
%- pixdim = 1.714 x 1.714 x 1.700
%	* Loading SCHEME...
%		- 96 measurements divided in 2 shells (6 b=0)
%	* Loading MASK...
%		- dim    = 140 x 140 x 81
%		- voxels = 273230
%  [ DONE ]
%Elapsed time is 2.567652 seconds.

%%

tic; AMICO_SetModel( 'NODDI' );toc         %Elapsed time is 0.259893 seconds.
%%
tic; AMICO_GenerateKernels( false ); toc
%-> Generating kernels with model "NODDI" for protocol "subj1":
%   [=========================] 
%   [ 251.0 seconds ]
%Elapsed time is 251.391931 seconds.
%-> Generating kernels with model "NODDI" for protocol "NoddiTutorial":
%   [ Kernels already computed. Set "doRegenerate=true" to force regeneration ]
%Elapsed time is 0.021268 seconds.
%%
 tic; AMICO_ResampleKernels(); toc

%-> Resampling rotated kernels for subject "NODDI_example_dataset":
%   [=========================] 
%   [ 25.4 seconds ]
%Elapsed time is 25.381692 seconds.

%%
tic; AMICO_Fit(); toc

%-> Fitting "NODDI" model to 273230 voxels:
 %  [=========================] 
  % [ 0h 8m 7s ]

%-> Saving output to "AMICO/*":
%	- CONFIG.mat [OK]
%	- FIT_dir.nii [OK]
%	- AMICO/FIT_ICVF.nii [OK]
%	- AMICO/FIT_OD.nii [OK]
%	- AMICO/FIT_ISOVF.nii [OK]
 %  [ DONE ]
%Elapsed time is 487.110238 seconds.


