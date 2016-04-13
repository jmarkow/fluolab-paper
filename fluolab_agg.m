function stan_agg_nervecut_audio()
% copies audio data from nervecut birds, finds last suitable pre and earliest suitable post
%

% get options

[options,dirs]=stan_preflight;

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

storedir=fullfile(dirs.data_dir,dirs.fluo_dir,[ birdid '_' datestr(date_number,'yyyy-mm-dd') ]);
storedir
if ~exist(storedir,'dir')
	%mkdir(storedir);
end

for i=1:length(listing)
	disp([listing(i).name]);
	% get adc, audio and ttl, get out of dodge...

end

%save(fullfile(storedir,['mic_data.mat']),'agg_audio','-v7.3');
