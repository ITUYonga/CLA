%EXP_SWEEP_CFAR_PARAMS : Sweep of the (k, threshold_factor) pairs
%
%   Purpose:  8 seeds, 'simple' scenerio. Pd and false alarms per frame for
%             each (k, threshold_factor) pair. The fast threshold calculation
%             at the end of the file uses the same reference cells as
%             func_os_cfar (it is checked at the beginning, the difference must be 0).
%             Results are in README.md (k ve threshold_factor ayarı).
%
%   usage:    run this script from anywhere. Change p.rcs_tgt, ks and facs to try
%             other scenerios.

addpath(fileparts(fileparts(mfilename('fullpath'))));    % repo folder (functions)
fs=1e6; fc=3e9; tau=20e-6; B=400e3; PRI=1e-3; PRF=1/PRI; c=3e8; Pt=1e3; NFFT=256; lambda=c/fc;
N_PRI=fs*PRI; N_Pulse=20; k_lfm=B/tau; t_p=(0:fs*tau-1)/fs;
noise_amp=func_calculate_noise('noisefloor',-111); clutter_amp=10*noise_amp;
num_ref=30; num_guard=6; peak_ratio=0.5; max_gap=15;
p.R_tgt=[45e3,55e3,70e3,80e3,141e3]; p.V_tgt=[15,-15,0,10,20]; p.rcs_tgt=[10 10 10 10 10]; p.Gt=10^(35/10);
[R,v,rcs,Gt_eff]=func_target_setup('simple',p);
target_idx=round(2*R/c*fs)+1; valid=v~=0; tol=5;
ks=[10 15 20 24 27]; facs=[1.5 2 2.5 3 3.8 5 6.5];
if ~exist('nS','var'), nS=8; end
PW=cell(1,nS);
for s=1:nS
  rng(s);
  tp=func_lfm_gen(k_lfm,t_p);
  clutter=func_clutter_gen(tp,N_PRI,N_Pulse,clutter_amp,PRF,lambda,c,fs);
  rx=func_get_received_signal(tp,N_PRI,N_Pulse,R,v,rcs,Pt,Gt_eff,noise_amp)+clutter;
  tp=func_window_processing(tp);
  m=func_matched(tp,rx); mt=func_mti(m); w=func_window_processing(mt);
  F=func_fft_processing(w,NFFT); PW{s}=F;
end
% fast threshold row-max for each k (same reference cells as func_os_cfar)
function TM=fastthr(F,num_ref,num_guard,ks)
  P=abs(F).^2; N=size(P,1); TM=zeros(N,numel(ks));   % per k: max over doppler of sorted(k) (before factor)
  for j=1:N
    left=(j-num_guard/2-num_ref/2):(j-num_guard/2-1);
    right=(j+num_guard/2+1):(j+num_guard/2+num_ref/2);
    left=left(left>0); right=right(right<=N);
    ref=[left right]; if isempty(ref), continue, end
    S=sort(P(ref,:),1);
    for q=1:numel(ks), TM(j,q)=max(S(min(ks(q),size(S,1)),:)); end
  end
end
% check against func_os_cfar for one config
[~,tm_ref]=func_os_cfar(PW{1},num_ref,num_guard,20,3);
TM=fastthr(PW{1},num_ref,num_guard,20);
fprintf('check max abs diff (row-max thr): %g\n',max(abs(max(tm_ref,[],2)-3*TM)));
Pd=zeros(numel(ks),numel(facs)); FA=Pd;
for s=1:nS
  TM=fastthr(PW{s},num_ref,num_guard,ks);
  for a=1:numel(ks), for b=1:numel(facs)
    det=func_cfar_post_processing(PW{s},facs(b)*TM(:,a),peak_ratio,max_gap);
    hits=0; for h=find(valid), hits=hits+any(abs(det-target_idx(h))<=tol); end
    fa=0; for d=1:numel(det), fa=fa+~any(abs(target_idx(valid)-det(d))<=tol); end
    Pd(a,b)=Pd(a,b)+hits/sum(valid)/nS; FA(a,b)=FA(a,b)+fa/nS;
  end, end
end
disp('facs:'); disp(facs);
for a=1:numel(ks), fprintf('k=%2d  Pd: %s\n',ks(a),sprintf('%5.2f ',Pd(a,:))); end
for a=1:numel(ks), fprintf('k=%2d  FA: %s\n',ks(a),sprintf('%5.1f ',FA(a,:))); end
