function [sub_no,cb_no,num_blocks] = AC_prompt()
%AC_SPACE_PROMPT Summary of this function goes here
%   Detailed explanation goes here
prompt = {'Participant code:','Counterbalance code:','Number of Blocks:',};  % Get input before starting
dlg_title = 'Participant information';
num_lines= 1;
defaults = {'99','99','6'};
answer = inputdlg(prompt,dlg_title,num_lines,defaults);
% Caution: consistent with Irons version, sub_no is treated as String
% across the code
sub_no = answer{1};
cb_no = str2num(answer{2});
num_blocks = str2num(answer{3});
end