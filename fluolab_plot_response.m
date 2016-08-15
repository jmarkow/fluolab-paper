% simple plot for each day's worth of feedback


% how many changes today?

[nsamples,ntrials]=size(fluo.mat);
fluo_max=max(fluo.mat);
fluo_min=min(fluo.mat);

% fluo_norm=fluo.mat./repmat(fluo_max,[nsamples 1])

%fluo_norm=fluo.mat-repmat(mean(fluo.mat')',[1 ntrials]);
%mu=mean(zscore(fluo.mat(:,fluo.trials.catch_other))');
fluo_norm=fluolab_vec_rej(zscore(fluo.mat),zscore(mean(fluo.mat'))');
%fluo_norm=fluo.mat;
%fluo_norm=zscore(fluo.mat)-repmat(zscore(mu(:)),[1 ntrials]);
win_data=fluolab_window_data(fluo_norm,fluo.t,fluo.trials.times,fluo.trials.change_idx);
