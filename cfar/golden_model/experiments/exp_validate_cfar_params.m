%EXP_VALIDATE_CFAR_PARAMS : Validation of the (k, threshold_factor) pairs
%
%   Purpose:  100 seeds, 'simple' scenerio, 4 moving targets. For each seed
%             clutter and noise are generated again and the whole chain is
%             executed. Pd (with 95% Wilson interval) and false alarms per frame
%             are calculated for the candidate pairs in cfg = [k threshold_factor].
%             Results are in README.md (Doğrulama ve Karar).
%
%   usage:    run this script from anywhere (nS can be set before to make it faster)
%             about 1 minute for nS = 100 (estimated from nS = 3)

addpath(fileparts(fileparts(mfilename('fullpath'))));    % repo folder (functions)
fs=1e6; fc=3e9; tau=20e-6; B=400e3; PRI=1e-3; PRF=1/PRI; c=3e8; Pt=1e3; NFFT=256; lambda=c/fc;
N_PRI=fs*PRI; N_Pulse=20; k_lfm=B/tau; t_p=(0:fs*tau-1)/fs;
noise_amp=func_calculate_noise('noisefloor',-111); clutter_amp=10*noise_amp;
num_ref=30; num_guard=6; peak_ratio=0.5; max_gap=15;
cfg=[24 6.5; 20 8; 15 15]; ks=unique(cfg(:,1)).';
if ~exist('nS','var'), nS=100; end
tol=5;
for rcsv=[10 3]
  p.R_tgt=[45e3,55e3,70e3,80e3,141e3]; p.V_tgt=[15,-15,0,10,20]; p.rcs_tgt=rcsv*ones(1,5); p.Gt=10^(35/10);
  [R,v,rcs,Gt_eff]=func_target_setup('simple',p);
  tidx=round(2*R/c*fs)+1; valid=find(v~=0);
  hit=zeros(nS,numel(valid),size(cfg,1)); fa=zeros(nS,size(cfg,1));
  for s=1:nS
    rng(1000+s);
    tp=func_lfm_gen(k_lfm,t_p);
    cl=func_clutter_gen(tp,N_PRI,N_Pulse,clutter_amp,PRF,lambda,c,fs);
    rx=func_get_received_signal(tp,N_PRI,N_Pulse,R,v,rcs,Pt,Gt_eff,noise_amp)+cl;
    tw=func_window_processing(tp);
    F=func_fft_processing(func_window_processing(func_mti(func_matched(tw,rx))),NFFT);
    P=abs(F).^2; N=size(P,1); TM=zeros(N,numel(ks));
    for j=1:N
      left=(j-num_guard/2-num_ref/2):(j-num_guard/2-1); right=(j+num_guard/2+1):(j+num_guard/2+num_ref/2);
      ref=[left(left>0) right(right<=N)]; if isempty(ref), continue, end
      Ssort=sort(P(ref,:),1);
      for q=1:numel(ks), TM(j,q)=max(Ssort(min(ks(q),size(Ssort,1)),:)); end
    end
    for a=1:size(cfg,1)
      det=func_cfar_post_processing(F,cfg(a,2)*TM(:,ks==cfg(a,1)),peak_ratio,max_gap);
      for h=1:numel(valid), hit(s,h,a)=any(abs(det-tidx(valid(h)))<=tol); end
      f=0; for d=1:numel(det), f=f+~any(abs(tidx(valid)-det(d))<=tol); end
      fa(s,a)=f;
    end
  end
  fprintf('\n##### RCS = %g m^2, %d seeds, targets at %s km #####\n',rcsv,nS,mat2str(R(valid)/1e3));
  for a=1:size(cfg,1)
    n=nS*numel(valid); x=sum(hit(:,:,a),'all'); ph=x/n; z=1.96;
    lo=(ph+z^2/(2*n)-z*sqrt(ph*(1-ph)/n+z^2/(4*n^2)))/(1+z^2/n); hi=(ph+z^2/(2*n)+z*sqrt(ph*(1-ph)/n+z^2/(4*n^2)))/(1+z^2/n);
    fprintf('k=%2d f=%4.1f | Pd=%.3f [%.3f, %.3f] | per target: %s | FA/frame=%.3f (max %d)\n',cfg(a,1),cfg(a,2),ph,lo,hi,mat2str(mean(hit(:,:,a),1),3),mean(fa(:,a)),max(fa(:,a)));
  end
end
