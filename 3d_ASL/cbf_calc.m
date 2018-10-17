%% Written by Scott Peltier @fMRI Lab
%% 10/17/2018, 12:36:14 PM
function [cbfmap]=cbf_calc(asl_filename);

tst=read_nii_img(asl_filename);
tst=reshape(tst.',[128 128 40 2]);

% divide image into perfusion weights and spin density
pw=tst(:,:,:,1);
pd=tst(:,:,:,2);

% creating masks
msk1=(pw==0);   %mask outside spiral coverage
msk2=(pd<200);  %masks non-brain areas

% report the number of 1s in mask
% https://www.mathworks.com/matlabcentral/answers/37196-count-number-of-specific-values-in-matrix
% nnz(msk1 == 1)    % 139692
% nnz(msk2 == 1)    % 409735

%% parameter definitions
alpha=0.9;
ST=2;
T1t=1.2;
eff=0.6;
T1b=1.6;
LT=1.5;

% UMMAP NEX=3 PLD=1.525
% PTR   NEX=3 PLD=2.025

NEX=3;

% post labelling delay
PLD=1.525;    %for UMMAP protocol
PLD=2.025;    %for PTR protocol

%% equation definitions
eqnum=(1-exp(-ST/T1t))*exp(PLD/T1b);
eqdenom=2*T1b*(1-exp(-LT/T1b))*eff*NEX;

% don't know what this is
SF=32;

% final scaling factors
cbf=6000*alpha*(eqnum/eqdenom)*(pw./(SF*pd));

% masking out noise
cbfmap=cbf;
cbfmap(find(msk1))=0;
cbfmap(find(msk2))=1;
