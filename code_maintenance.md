# Code Maintenance Log
The majority of the current version is coded in early July.
## July 18, 2019
### AC_main
Added the instruction page. The protocol followed the format of the previous ACVS. Participants are going to be informed of the target and distractor information, and how targets can be found.
## July 17, 2019
### AC_get_trial_conditions
The previous version of the code generates a matrix with all trial conditions.

`output(starting_row + i - 1, 8:9) = randsample(4, 2) + 1;`
