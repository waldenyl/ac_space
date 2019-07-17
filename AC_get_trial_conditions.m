function output = AC_get_trial_conditions(counterbalance_id, ...
    num_blocks, num_trials_per_block, num_prac_trials, all_ratios)
%AC_SPACE_GET_TRIAL_CONDITIONS
%   @Description
%       This function takes in critical parameters of the experiment
%       manipulations, and return a matrix that contains every single trial
%       condition for the whole experiment, including practice trials. When
%       generating the conditions, three variables (optimal side, left
%       target ecc, right target ecc) have their levels balanced every
%       block, while one variable of interest (ratio) is within-subject,
%       counterbalanced across subjects.
%
%   @Output
%       output_mat
%           A m*9 real matrix
%               Column 1 = Trial number
%               Column 2 = Block number
%               Column 3 = Trial number in its block
%               Column 4 = Optimal target side (1 = left, 2 = right)
%               Column 5 = Ecc of left target
%               Column 6 = Ecc of right target
%               Column 7 = Non-optimal vs. optimal side squares ratio
%               Column 8 = Left target digit
%               Column 9 = Right target digit
%
%   @Para
%       counterbalance_id
%           The counterbalance id ranges from 1-6 in this case, depending
%           on how many ratios there are.
%       num_blocks
%           This is the total number of blocks needed. In order to get a
%           balanced condition, make sure this parameter is a multiple of
%           3 in this case.
%       num_trials_per_block
%           This is total number of trials per block. In order to control
%           for confounding variables, make sure all the participant is
%           exposed to equal amount of every level (in this case optimal
%           target side, left target ecc, right target ecc) by letting the
%           number of trials each block a multiple of 18=2*3*3.
%       num_prac_trials
%           This is the total number of practice trials.
%       all_ratios
%           In a pilot study, this is all the ratios we want to test in
%           this experiment. A typical input would be a row vector
%           [2.00 1.50 1.20]. If the ratio is fixed, there will not be
%           counterbalance needed, and the parameter can be e.g. [2 2 2].
%
%   @Author
%       Y Li
%
%   @Version
%       Last updated 20190716
%

% Set local parameters
max_run = 3; % Max number of trials where optimal target is on the same side allowed

% Set ratio based on counterbalance id
all_ratio_perm = perms(all_ratios);
num_perm = size(all_ratio_perm, 1);
ratio = all_ratio_perm(mod(counterbalance_id, num_perm), :); % e.g. ratio = [2 1.5 1.2](31 mod 6) = 2

% Create total trial condition matrix
num_total_trials = num_prac_trials + num_blocks * num_trials_per_block;
output = zeros(num_total_trials, 9);

% Start adding rows
% First, add practice trial conditions
% Since this is a more simple task, maybe we just need 10 trials. And since practice
% trials data are not used for analysis, we can randomly generate trial conditions
for i = 1:num_prac_trials
    output(i, :) = [i, 0, i, randi(2), randi(3), randi(3), ...
        all_ratios(randi(size(all_ratios,2))), randsample(4,2)'+1];
end

% Start adding actual experiment blocks
for b = 1:num_blocks
    starting_row = (b-1) * num_trials_per_block + num_prac_trials + 1;
    block_conds = zeros(num_trials_per_block, 4);
    if mod(num_trials_per_block, 18) ~= 0
        error('Error: number of trials must be a integer multiple of 18')
    end
    reps = num_trials_per_block/18; % How many reps of all possible target conditions
    current_row = 1;
    % First, add all ecc and ratios
    for r = 1:reps
        for i = 1:2
            for j = 1:3
                for k = 1:3
                    block_conds(current_row, 1:3) = [i, j, k];
                    block_conds(current_row, 4) = ratio(ceil(b/2));
                    current_row = current_row + 1;
                end
            end
        end
    end
    
    % Randomize
    block_conds = block_conds(randperm(size(block_conds, 1)), :);
    
    % Make sure target does not appear repeated on one side
    optimal = block_conds(:,1);
    while AC_check_repetition(optimal, 1, max_run)
        optimal = optimal(randperm(size(optimal,1)),:);
    end

    % Add this block to the big output
    for i = 1:size(block_conds, 1)
        output(starting_row + i - 1, 1:3) = [starting_row + i - 1, b, i];
        output(starting_row + i - 1, 4) = optimal(i);
        output(starting_row + i - 1, 5:7) = block_conds(i, 2:4);
        output(starting_row + i - 1, 8:9) = randsample(4, 2) + 1;
    end
end
end