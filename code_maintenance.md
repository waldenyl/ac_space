# Code Maintenance Log
The majority of the current version is coded in early July.
## July 18, 2019
### AC_main
Added the instruction page. The protocol followed the format of the previous ACVS. Participants are going to be informed of the target and distractor information, and how targets can be found.
## July 17, 2019
### AC_get_trial_conditions
The previous version of the code generates a matrix with all trial conditions.

`output(starting_row + i - 1, 8:9) = randsample(4, 2) + 1;`

However, by this random sampling process, we still cannot ensure all target digits appear the same number of times during each experiment. This might arise problem, especially after we found some evidence that participants response to different target digits in a different way. I plan to investigate further in the near future. At this time, if we hold the occurrence of each target digit in an experiment the same, the experiment will at least free from being confounded.

As a result, we still have to use the permutation way to generate target digits matrix.

    current_row = 1;
    % Then, add all combinations of target digits
    for r = 1:num_trials_per_block/12
        for i = 2:5
            for j = 2:5
                if j ~= i
                    block_conds(current_row, 5:6) = [i, j];
                    current_row = current_row + 1;
                end
            end
        end
        
    end
    
