%%%
% load in the data

[~,dirs]=fluolab_preflight;
load(fullfile(dirs.data_dir,dirs.fluo_dir,'lny88/motif1_fs24414_normamp0_extrapad_2015-11-10.mat'));

% process the data


%%
trial_cut=3.5;
nmads=10;
tau=0.1;
smooth_type='b';
channel=1;
newfs=200;
detrend_win=.3;
detrend_method='p';
normalize='m';
classify_trials='s'; % use sound level for detecting feedback trials
daf_level=0.2;
audio_example=1;
plot_trials=1:40;
xlimits=[.74 1.35];

%%

% clean up the data
fluo_data=fluolab_datascrub(adc,'channel',channel,'trial_cut',trial_cut,'nmads',nmads);

% where are the feedback trials?
[trials,trials_idx]=fluolab_classify_trials(ttl,audio,...
		'include_trials',fluo_data.trial_idx,'method',classify_trials,'daf_level',daf_level,...
		'padding',template.extract_options.padding-[.1 .1]);
trials_idx_fluo=trials_idx(trials.all.fluo_include);

% convert to df/f_0

[fluo.mat,fluo.t]=fluolab_condition(fluo_data.data(:,:,channel),fluo_data.fs,fluo_data.t,'tau',tau,'detrend_win',detrend_win,...
	'newfs',newfs,'normalize',normalize,'detrend_method',detrend_method,'smooth_type',smooth_type);
fluo.fs=newfs
fluo_regress=fluo;

% now align to interesting events
[trial_times change_points change_trials,change_idx]=fluolab_ttl_proc(ttl,trials,'padding',template.extract_options.padding);
trial_times_fluo=trial_times(trials.all.fluo_include);
change_idx_fluo=change_idx(trials.all.fluo_include);
% align to trial_times window, plot peak time? value? integrated signal?

% this should be very straightforward
win_data=fluolab_window_data(fluo.mat,trial_times_fluo,change_idx_fluo,'fs',fluo.fs);

%%
% now plotting code, first mic data

% also plot averages from the photometry...

new_motif_number=motif_number(trials.all.fluo_include);
daf_fluo=fluo.mat(:,intersect(trials.fluo_include.daf,find(new_motif_number>0)));
catch_fluo=fluo.mat(:,intersect(trials.fluo_include.catch_other,find(new_motif_number>0)));

% remove trial-mean

trial_mu=mean(fluo.mat,2);

daf_fluo_demean=daf_fluo-repmat(trial_mu,[1 size(daf_fluo,2)]);
catch_fluo_demean=catch_fluo-repmat(trial_mu,[1 size(catch_fluo,2)]);

plot_trials=1:50;

% don't include the adaptation, so take first n trials

daf_mu=mean(daf_fluo_demean(:,plot_trials)');
daf_sem=std(daf_fluo_demean(:,plot_trials)')./sqrt(length(plot_trials));
daf_ci=[daf_mu+daf_sem;daf_mu-daf_sem];
catch_ci=bootci(1e3,{@mean,catch_fluo_demean(:,plot_trials)'},'type','per');

plot_trials_catch=1:200;

catch_mu=mean(catch_fluo_demean(:,plot_trials_catch)');
catch_sem=std(catch_fluo_demean(:,plot_trials_catch)')./sqrt(length(plot_trials_catch));
catch_ci=[catch_mu+catch_sem;catch_mu-catch_sem];
catch_ci=bootci(1e3,{@mean,catch_fluo_demean(:,plot_trials_catch)'},'type','per');

%%
load custom_colormaps;

figs.ave_align=figure();
[s,f,t]=zftftb_pretty_sonogram(audio.data(:,min(trials.all.fluo_include(trials.fluo_include.daf(1)))),audio.fs,...
    'filtering',300,'clipping',[-3 1],'len',70,'overlap',69.5);
ax(1)=subplot(2,1,1);
imagesc(t,f/1e3,s);
axis xy;
colormap(fee_map);
set(gca,'XTick',[],'YTick',[0 9]);
ylim([0 9]);

ax(2)=subplot(2,1,2);
markolab_shadeplot(fluo.t,daf_ci,'r','none');
hold on;
plot(fluo.t,daf_mu,'k-');
markolab_shadeplot(fluo.t,catch_ci,'b','none');
plot(fluo.t,catch_mu,'k-');
ylabel('Norm. fluo. change');
linkaxes(ax,'x');
xlim(xlimits);
set(figs.ave_align,'PaperPositionMode','auto','position',[200 200 280 200]);
ylim([-.1 .15]);
set(gca,'Ytick',[-.1 .15]);

%% RMS on audio to show the "stimulation"

[b,a]=ellip(3,.2,40,[3e3 7e3]/(audio.fs/2),'bandpass');
filt_audio=filtfilt(b,a,double(audio.data)).^2;
rms_tau=.005;
rms_smps=round(rms_tau.*audio.fs);
audio_rms=sqrt(filter(ones(rms_smps,1)/rms_smps,1,filt_audio));

%%
figs.audio_rms=figure();

ax(1)=subplot(5,1,1);
imagesc(t,f/1e3,s);
axis xy;
colormap(fee_map);
set(gca,'XTick',[],'YTick',[0 9]);
ylim([0 9]);
freezeColors();

ax(2)=subplot(5,1,2:5);
imagesc(audio.t,[],20*log10(audio_rms+eps)');
caxis([-50 -10]);
set(gca,'XTick',xlimits);
set(gca,'YTick',[]);
colormap(parula);

linkaxes(ax,'x');
xlim(xlimits);
set(figs.audio_rms,'PaperPositionMode','auto','position',[200 200 280 420]);


%%
% fig_names=fieldnames(figs);
% for i=1:length(fig_names)
%    markolab_multi_fig_save(figs.(fig_names{i}),pwd,[ 'photometry_' fig_names{i} ] ,'eps,png,fig','renderer','painters');
% end
