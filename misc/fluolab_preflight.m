function [OPTIONS,DIRS]=fluolab_read_options
% script for reading config files/sorting for processing/chopping
%
% takes logfile as input
%
%
%

options_name='options.txt';
dirs_name='dirs.txt';

cur_file=mfilename('fullpath');
[cur_path,~,~]=fileparts(cur_file);
dirs=fluolab_read_options(fullfile(cur_path,dirs_name));

OPTIONS=fluolab_read_options(fullfile(cur_path,options_name));
DIRS=fluolab_read_options(fullfile(cur_path,dirs_name));
