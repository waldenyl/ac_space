function output_mat = AC_get_one_trial_stim(in_cond, in_grid_rects)
%   @Description
%       This function outputs a matrix with all the stimuli (in rows)
%       information needed to display on the screen. A 1*7 row of condition
%       matrix is to be taken in as a recipe to tell this function how to
%       cook a display for that particular trial. A grid_rects matrix is
%       to be taken in to serve as a map of the screen.
%
%   @Output
%       output_mat
%           A m*8 real matrix.
%               Column 1 = Upper left corner x
%               Column 2 = Upper left corner y
%               Column 3 = Lower right corner x
%               Column 4 = Lower right corner y
%               Column 5 = Center of the rect x (for digit display purpose)
%               Column 6 = Center of the rect y (for digit display purpose)
%               Column 7 = Index of the rect
%               Column 8 = Digit needed to appear on the rect
%           If not sorted, a typical output should have the two targets
%           information on the first two rows, followed by rows of
%           distractors.
%
%
%   @Para
%       in_cond
%           A 1*7 single-row real matrix.
%           A sample input_grid_pos may be in the following format:
%               Column 1 = Trial number
%               Column 2 = Block number
%               Column 3 = Trial number in that block
%               Column 4 = Optimal target; (1 = left, 2 = right)
%               Column 5 = Eccentricity of target 1
%               Column 6 = Eccentricity of target 2
%               Column 7 = Non-optimal vs optimal number of squares ratio
%                   e.g. 1.50
%               Column 8 = Digit of target 1
%               Column 9 = Digit of target 2
%
%   @Author
%       Y Li
%
%   @Version
%       20190704
%

% Get data from input args
optimal_side = in_cond(4);
ecc_target_1 = in_cond(5);
ecc_target_2 = in_cond(6);
ratio = in_cond(7);
digit_target_1 = in_cond(8);
digit_target_2 = in_cond(9);
grid_rects = in_grid_rects;


% Initialize local variables
max_rects = 20;

% Create output matrix
% Preallocation in this case is not likely to benefit a lot
output_mat = [];

% Start adding two targets, one on each side
% First, add target 1
target_1_pool = grid_rects(grid_rects(:,8)==ecc_target_1,:); % Select all rows with the correct ecc
target_1_pool = target_1_pool(target_1_pool(:,9)==1,:); % Further select all rows with the correct side
target_1 = target_1_pool((randsample(size(target_1_pool,1),1)),1:7);
target_1 = [target_1, digit_target_1];

% Then, add target 2
target_2_pool = grid_rects(grid_rects(:,8)==ecc_target_2,:); % Select all rows with the correct ecc
target_2_pool = target_2_pool(target_2_pool(:,9)==2,:); % Further select all rows with the correct side
target_2 = target_2_pool((randsample(size(target_2_pool,1),1)),1:7);
target_2 = [target_2, digit_target_2];

% Add to output
output_mat = [output_mat; target_1; target_2];

% Delete these two from the 48 grid rects
% Column 7 = Index of the rect (Version 20190704)
grid_rects(grid_rects(:,7)==target_1(7),:) = [];
grid_rects(grid_rects(:,7)==target_2(7),:) = [];

% Finally, start to determine all other rects
% Column 9 = Left/right of the rect (Version 20190704)
left_pool = grid_rects(grid_rects(:,9)==1,:);
right_pool = grid_rects(grid_rects(:,9)==2,:);

% Determine the total number of rects on each side
num_total_optimal_side_rects = round(max_rects/ratio); % 10 13 17 2.00 1.54 1.18
num_total_non_optimal_side_rects = max_rects; % 20
if (optimal_side == 1) % If optimal target is on the left side
    num_need_left_side_rects = num_total_optimal_side_rects - 1;
    num_need_right_side_rects = num_total_non_optimal_side_rects - 1;
    
else % If optimal target is on the right side
    num_need_left_side_rects = num_total_non_optimal_side_rects - 1;
    num_need_right_side_rects = num_total_optimal_side_rects - 1;
end

left_chosen = left_pool(randsample(size(left_pool,1),num_need_left_side_rects), 1:7);
right_chosen = right_pool(randsample(size(right_pool,1),num_need_right_side_rects), 1:7);

left_mat = [left_chosen'; randi([6 9], 1, size(left_chosen', 2))]';
right_mat = [right_chosen'; randi([6 9], 1, size(right_chosen', 2))]';

output_mat = [output_mat; left_mat; right_mat];

end