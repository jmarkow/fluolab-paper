function stan_agg_nervecut_audio()
% copies audio data from nervecut birds, finds last suitable pre and earliest suitable post
%

% get options

[options,dirs]=fluolab_preflight;

% gather dates, copy only mic data (stitch too?)
%

listing=robofinch_dir_recurse(pwd,'aggregated_data.mat');

if isempty(listing)
	return;
end

tmp=regexp(listing(1).name,'((\d+-)+\d+)','match');
date_number=datenum(tmp);
tmp=regexp(listing(1).name,filesep,'split');
birdid=tmp{end-7};
motifid=tmp{end-3};

% template should be here

new_dir=template_dir(1:end-7);
new_dir{end+1}='hvc';
new_dir{end+1}='templates';
new_dir{end+1}=motifid;
template_dir=strjoin(new_dir,filesep)

pause();


storedir=fullfile(dirs.data_dir,dirs.fluo_dir,[ birdid '_' motifid '_' datestr(date_number,'yyyy-mm-dd') ]);
storedir
if ~exist(storedir,'dir')
	%mkdir(storedir);
end

for i=1:length(listing)
	disp([listing(i).name]);

	% simply save everything, but rename the file to something useful and make sure
	% we keep all relevant parameters

	% go back to the template and retrieve the pad size, we def. need this for analysis

end

%save(fullfile(storedir,['mic_data.mat']),'agg_audio','-v7.3');
