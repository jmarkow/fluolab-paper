function stan_agg_nervecut_audio()
% copies audio data from nervecut birds, finds last suitable pre and earliest suitable post
%

% get options

[options,dirs]=fluolab_preflight;

% gather dates, copy only mic data (stitch too?)
%

%listing=robofinch_dir_recurse(pwd,'roboaggregate.mat');
listing=robofinch_dir_recurse(pwd,'forpaper')
% or search for directories that have mark...

if isempty(listing)
	return;
end



% template should be here




for i=1:length(listing)

	disp([listing(i).name]);

	tmp=regexp(listing(i).name,'((\d+-)+\d+)','match');
	date_number=datenum(tmp);
	tmp=regexp(listing(i).name,filesep,'split');
	birdid=tmp{end-7};

	motifid=regexprep(tmp{end-3},'_roboextract','');

	new_dir=tmp(1:end-7);
	new_dir{end+1}='templates';
	new_dir{end+1}=motifid;

	template_dir=strjoin(new_dir,filesep);
	template_file=fullfile(template_dir,'template_data.mat');
	template_opts=fullfile(template_dir,'robofinch_parameters.txt');

	store_dir=fullfile(dirs.data_dir,dirs.fluo_dir,birdid);
	store_file=[ motifid '_' datestr(date_number,'yyyy-mm-dd') '.mat' ];

	if ~exist(store_dir,'dir')
		%mkdir(store_dir);
	end

	template_options=robofinch_read_config(template_opts);

	% get the template data

	load(template_file,'template');
	template.extract_options=template_options;

	[pathname,~,~]=fileparts(listing(i).name);
	data_file=fullfile(pathname,'roboaggregate.mat');

	disp([template_file]);
	disp([data_file]);
	disp(fullfile(store_dir,store_file));

	% move the data file to the store_dir, rename to something useful???

	% simply save everything, but rename the file to something useful and make sure

	%save(data_file,'template_data','-append');
	%copyfile(data_file,fullfile(store_dir,store_file))

	% go back to the template and retrieve the pad size, we def. need this for analysis

end

%save(fullfile(store_dir,['mic_data.mat']),'agg_audio','-v7.3');
