function [cbfmap]=cbf_calc(asl_filename);

tst=read_nii_img(asl_filename);
tst=reshape(tst.',[128 128 40 2]);

pw=tst(:,:,:,1);
pd=tst(:,:,:,2);

msk1=(pw==0);   %mask outside spiral coverage
msk2=(pd<200);  %masks non-brain areas

%%
alpha=0.9;
ST=2;
T1t=1.2;

eff=0.6;

T1b=1.6;

LT=1.5; 

% UMMAP NEX=3 PLD=1.525
%  PTR   NEX=3   PLD=2.025

NEX=3;

PLD=1.525;   %for PTR change this to 2.025


eqnum=(1-exp(-ST/T1t))*exp(PLD/T1b);

eqdenom=2*T1b*(1-exp(-LT/T1b))*eff*NEX;

SF=32;

cbf=6000*alpha*(eqnum/eqdenom)*(pw./(SF*pd));

cbfmap=cbf;
cbfmap(find(msk1))=0;
cbfmap(find(msk2))=1;
