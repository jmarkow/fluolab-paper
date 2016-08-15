%%% gathers data and formats into a convenient format
% load in the data

[~,dirs]=fluolab_preflight;
%load(fullfile(dirs.data_dir,dirs.fluo_dir,'lny86/motif1_fs24414_normamp0_extrapad_2015-12-12.mat'));

% process the data

%%

trial_cut='auto';
trial_cut_factor=.8;
nmads=10;
tau=0.1;
smooth_type='b';
channel=1;
newfs=200;
detrend_win=.3;
detrend_method='p';
normalize='n';
classify_trials='s'; % use sound level for detecting feedback trials
daf_level=0.15;

%%

listing=robofinch_dir_recurse(fullfile(dirs.data_dir,dirs.fluo_dir,'use_data'),'*.mat');

for i=1:length(listing)
	% load all files within a particular directory?

	bird_id=regexp(listing(i).name,filesep,'split');
	bird_id=bird_id{end-1}

	disp([listing(i).name])
	load(listing(i).name,'adc','audio','ttl','motif_number','file_datenum','template');

	% clean up the data
	fluo_data=fluolab_datascrub(adc,...
		'channel',channel,'trial_cut',trial_cut,'nmads',nmads,'trial_cut_factor',.8);

	% where are the feedback trials?
	[trials,trials_idx]=fluolab_classify_trials(ttl,audio,...
	'include_trials',fluo_data.trial_idx,'method',classify_trials,'daf_level',daf_level,...
	'padding',template.extract_options.padding);
	trials_idx_fluo=trials_idx(trials.all.fluo_include);

	% convert to df/f_0

	[fluo.mat,fluo.t]=fluolab_condition(fluo_data.data(:,:,channel),fluo_data.fs,fluo_data.t,'tau',tau,'detrend_win',detrend_win,...
	'newfs',newfs,'normalize',normalize,'detrend_method',detrend_method,'smooth_type',smooth_type);
	fluo.fs=newfs
	fluo_regress=fluo;

	% now align to interesting events
	[trial_times change_points change_trials,change_idx]=fluolab_ttl_proc(ttl,trials,'padding',template.extract_options.padding);

	% align to trial_times window, plot peak time? value? integrated signal?

	% this should be very straightforward
	%win_data=fluolab_window_data(fluo.mat,trial_times_fluo,change_idx_fluo,'fs',fluo.fs);

	%%
	% also plot averages from the photometry...

	fluo.motif_number=motif_number(trials.all.fluo_include);
	fluo.date_number=file_datenum(trials.all.fluo_include);
	fluo.trials=trials.fluo_include;
	fluo.trials.raw=trials.all;
	fluo.trials.times=trial_times(trials.all.fluo_include);
	fluo.trials.change_idx=change_idx(trials.all.fluo_include);

	for i=1:length(change_trials)
		fluo.change_trials(i)=change_trials(i).fluo_include;
	end

	new_motif_number=motif_number(trials.all.fluo_include);

	% autoplot spectrograms, and some other simple measures
	%audio.rms=zftftb_rms(audio.data,audio.fs);

	% what should we name the filename

	date_string=datestr(file_datenum(1),'yyyy-mm-dd');

	metadata.bird_id=bird_id;
	metadata.date_string=date_string;
	metadata.date_number=floor(file_datenum(1));

	save(fullfile(dirs.data_dir,dirs.fluo_dir,'analysis',[bird_id '_' date_string]),'fluo','audio','template','metadata');
	clearvars adc audio ttl motif_number file_datenum template fluo;

end
