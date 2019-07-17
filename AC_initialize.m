function ini = AC_initialize(exp_name, sub_no)
%AC_SPACE_INITIALIZE This function initialize critical parameters
%   in the experiment.
%
%
%   Adapted from J Irons, August 2017
%   See also Irons & Leber (2016) Irons & Leber (2018)
%   Y Li, July 2019
%
%

% Experiment environment parameters
ini.have_external_monitor = 1;          % Caution. If I test the code on my laptop set this to 1, otherwise set to 0.
ini.skip_sync = 1;                      % skip timing sync tests. 1 = yes, 0 = no
ini.square_size = 40;                   % Width/height of each square in search display in pixels. Might need to adjust. Default is 40
ini.digit_size = 24;                    % Font size for digits
ini.digit_font = 'Arial';               % Font for digits
ini.target_digit = [2 3 4 5];           % Target digits
ini.target_key = ['V','B','N','M'];     % Response keys corresponding to the 4 target digits (can be changed)
ini.ITItime = 1.5;                      % Duration of ITI (inter-trial interval)

% Experiment specific parameters
ini.num_trials_per_block = 72;
ini.num_practice_trials = 10;
ini.ratios = [2.00 1.50 1.20];

% Data file pointers, create dir if not exist
if ~exist('Data')
    mkdir Data;
end

if ~exist('Tracking')
    mkdir Tracking;
end

ini.expname = exp_name
experiment_run_at = clock

datafilename = strcat('Data/Data_',ini.expname,'_',sub_no,'.txt');
stimfilename = strcat('Tracking/Stim_',ini.expname,'_',sub_no,'.txt');

% check for existing result file & avoid overwriting:
if (str2num(sub_no) ~= 99) && fopen(datafilename, 'rt')~=-1
    fclose('all');
    error('Result data file already exists! Choose a different subject number.');
else
    ini.datafilepointer = fopen(datafilename,'wt');
    ini.stimfilepointer = fopen(stimfilename,'wt');
end

% Variables that almost always constant
ini.white = [255 255 255];
ini.grey = ini.white/2;

end