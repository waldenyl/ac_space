function AC_space_main
%AC_SPACE_MAIN
% The main function of the experiment. This expeirment is a visual search
% task adapted from the Adaptive Choice Visual Search (ACVS; Irons & Leber,
% 2016, 2018). A typical search display in this experiment is divided into
% the left side and the right side, each containing one of the target. All
% stimuli are grey squares with digits (2-9) on them, with target squares
% having digits 2-5 and distractors having digits 6-9. Importantly, on each
% trial, one side of the display will contain smaller number of squares
% than the other side, making the search of this side an optimal choice
% (i.e., faster reaction time). An observer should therefore always search
% through the smaller subset of squares on every trial when adopting the
% optimal strategy, which can be examined by calculating the proportion of
% optimal target choices within the experiment.
%
%                              %          %
%                       %                     %
%                    %         %                   %
%                         %                       %   %
%             %         %                          
%                  %                                     %
%                          %                      
%                   %                                 %     %
%           %     
%                      %             +                        %
%           %                                               %
%                  %       %                           %
%           %
%                   %                                    % 
%                %                             
%                   %       %                       % 
%                          %                   %
%                               %        %
%
% See Irons & Leber (2016) AP&P
% Programmed by J Irons, August 2017
% Adapted by Y Li, July 2019
%
% @Version 20190715
%



%%%%%%%%%%%%%%%%%%%%%%%%%% STARTUP INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;            % Clear Matlab/Octave window

[sub_no, cb_no, nblocks] = AC_prompt();

diary_file = strcat('Tracking/Diary_',num2str(sub_no),'.txt');
diary(diary_file);
diary on
commandwindow;

% Set up the experiment
ini = AC_initialize(mfilename, sub_no);

% Set up keyboard. No need to change anything in here.
k = AC_setup_keyboard(ini);

%%%%%%%%%%%%%%%%%%%%%%%%%%% SCREEN SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try %Try/catch loop = throws error to command window if anythign goes wrong
    % Psychtoolbox specific set-up stuff
    ListenChar(2);  % Setting flag to 2 enables listening to keyboard input, without outputting to command window
    Screen('Preference', 'SkipSyncTests', ini.skip_sync); % Decides whether to run screen sync tests
    AssertOpenGL;
    rand('state',sum(100*clock));   % Reseed the random-number generator for each expt.
    HideCursor;	% Hide the mouse cursor
    
    % Do dummy calls
    WaitSecs(0.1);
    GetSecs;    % Get timing
    
    
    if IsOSX==1
        ptbPipeMode=kPsychNeedFastBackingStore;  % enable imaging pipeline for osx
    elseif IsWin==1
        ptbPipeMode=[];  % don't need to enable imaging pipeline
    else
        ListenChar(0); clear screen; error('Operating system not OS X or Windows.')
    end
    
    % Set up screen
    screens = Screen('Screens');
    screenNumber = max(screens);
    
    % I usually test this code with the command window undocked to the
    % external monitor. Different environment may have different settings.
    if ini.have_external_monitor
        screenNumber=1;
    end
    
    [w, wRect]=Screen('OpenWindow',screenNumber, [0 0 0],[],[],[],[],[],ptbPipeMode);
    [screen_x_pixels, screen_y_pixels] = Screen('WindowSize', w);
    [x_center, y_center] = RectCenter(wRect);
    
    Priority(MaxPriority(w)); % Prioritse experiment functions
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% KEYBOARD SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    RestrictKeysForKbCheck(k.need_restrict);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%% SET UP STIMULI %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Create Rectangle for presenting instruction pngs
    InstrRect = SetRect(x_center-648,y_center-486,x_center+648,y_center+486);
    
    %%% Set the spatial locaiton of each squares in the display
    gridpos = AC_get_grid_pos(screen_x_pixels, screen_y_pixels);
    
    %%% Draw rect for each location in display
    grid_rects = AC_get_grid_rects(gridpos, ini.square_size);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SET UP TRIAL CONDS %%%%%%%%%%%%%%%%%%%%%%%%
    
    trialconds = AC_get_trial_conditions(cb_no, nblocks, ...
        ini.num_trials_per_block, ini.num_practice_trials, ini.ratios);
    
    % write to file in case need to restart
    dlmwrite(strcat('Tracking/Conds_',ini.expname,'_',sub_no,'.txt'),trialconds,'delimiter','\t');
    
    % Print header info to file
    fprintf(ini.datafilepointer,'%s\tCode = %s\t\n',char(ini.expname),sub_no);
    fprintf(ini.datafilepointer,'SubNo\tTrial\tBlock_trial\tBlock\tleft_ecc\tRight_ecc\tRatio\tTarg1_position\tTarg2_position\tLeft_targ_digit\tRight_targ_digit\tResponse\tTarg_Choice\tAcc\tRT\tOptimal_Choice\tRepeat_Switch\n');
    
    % record the stimus location X and Y positions in Stim file
    fprintf(ini.stimfilepointer,'%s\tCode = %s\t\n',char(ini.expname),sub_no);
    fprintf(ini.stimfilepointer,'00\t');
    fprintf(ini.stimfilepointer,'%f\t',gridpos(:,1));
    fprintf(ini.stimfilepointer,'\n');
    fprintf(ini.stimfilepointer,'00\t');
    fprintf(ini.stimfilepointer,'%f\t',gridpos(:,2));
    fprintf(ini.stimfilepointer,'\n');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INSTRUCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Present instructions, SPACEBAR to continue
    % This is done just using png files, but can also just be programed
    % directly in
    if (screen_y_pixels/screen_x_pixels)<(2/3)  % This depends on size of the png stimuli. Used to optimise its size on the screen
        InstrRect = SetRect(x_center-(screen_y_pixels*1.333/2),0,x_center+(screen_y_pixels*1.333/2),screen_y_pixels);
    else
        InstrRect = SetRect(0,y_center-(screen_x_pixels*.667/2),screen_x_pixels,y_center+(screen_x_pixels*.667/2));
    end
    instrfolder = 'Instructions';
    ninstr = 7;
    Beeper;
    
%    for instructions = 1:ninstr;
%        instrpic=imread(strcat(instrfolder,'/StartInstr',num2str(instructions),'.png'));
%        instrtex = Screen('MakeTexture',w,instrpic);
%        Screen('DrawTexture',w,instrtex,[],InstrRect);
        line1 = 'Hello';
        line2 = '\n This is the instruction page';
        line3 = '\n\n The experiment will now begin';
        DrawFormattedText(w, [line1 line2 line3],...
            'center', screen_y_pixels * 0.25, [255 255 255]);
        Screen('Flip',w);
        WaitSecs(.5);
        while (1)
            [~,~,keyCode] = KbCheck;
            if keyCode(k.space)
                break
            elseif keyCode(k.escape)
                ListenChar(1);
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
                clear all
                break;
            end
        end
        FlushEvents('keyDown');
%        Screen('Close',instrtex);
%    end
    
    Screen('Flip',w);
    WaitSecs(1.000);
    
    %%%%%%%%%%%%%%%%%%%%%%%%% BEGIN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%% BLOCK LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for block=0:nblocks                 % Block 0: Practice block, Block 1:nblocks: Experimental blocks
        
        if block == 0
            trialno = ini.num_practice_trials;            % Set the number of trials for practice
            totaltrialcount = 1;        % Start a counter for trials acros entire experiment
        else
            trialno = ini.num_trials_per_block;     % Set number of trials for exp blocks
        end
        
        % Reset block counters
        blockacc = 0;                   % Start at 0, used later to provid feedback on accuracy at the end of the block
        prevchoice = 0;                 % Start at 0, used later to calculate whether a trial is repeat or switch
        Screen('TextSize', w,30);
        
        % At start of block one, present instructions for starting experimental trials
        if block == 1
            totaltrialcount = 1;        % Reset counter after practice trials
            % Present instructions
            Screen('TextSize', w, 40);
            message = char(strcat('The experimental trials will now begin.\nThere will be',{' '},num2str(nblocks),{' '},'blocks of',{' '},num2str(ini.num_trials_per_block),{' '},'trials.\n\n Press SPACE to begin.'));
            DrawFormattedText(w, message, 'center', 'center', [255 255 255]);
            Screen('Flip',w);
            WaitSecs(.5);
            while (1)
                [~,~,keyCode ] = KbCheck;
                if keyCode(k.space)
                    break
                elseif keyCode(k.escape)  % Escape will close experiment window
                    ListenChar(1);
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0);
                    clear all
                    break;
                end
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%% TRIAL LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        WaitSecs(.5);
        for trial = 1:trialno  % 18*2*2=72 trialno
            %%%%%%%%%%%%% Prepare Stimuli %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % First retrieve the row from trial condition matrix, and get all the
            % stimuli information
            block_conds = trialconds(trialconds(:,2)==block, :);
            current_trial_cond = block_conds(trial, :)
            trial_stim = AC_get_one_trial_stim(current_trial_cond, grid_rects);
            
            
            
            % A sample current_trial_cond = 31  1  21  1  1  1  1.2  2  3
            optimal_side = current_trial_cond(4);
            left_target_ecc = current_trial_cond(5);
            right_target_ecc = current_trial_cond(6);
            ratio = current_trial_cond(7);
            left_target_digit = current_trial_cond(8);
            right_target_digit = current_trial_cond(9);
            
            left_target_pos = trial_stim(1, 7);
            right_target_pos = trial_stim(2, 7);
            
            
            Screen('TextSize', w, ini.digit_size);
            Screen('TextFont', w, ini.digit_font);
            
            
            %%%%%%%%%%%%%%% Present fixaton cross %%%%%%%%%%%%%%%%%%%%%%%%%%%
            DrawFormattedText(w, '+', 'center', 'center', [100 100 100]); % Draw a central fixation cross
            Screen('Flip',w);   % Present onscreen
            
            WaitSecs(ini.ITItime);
            
            %%%%%%%%%%%%%%% Present stimuli %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Draw items
            Screen('FillRect', w, [128 128 128]',trial_stim(:,1:4)');    % Draw the squares
            for i = 1:size(trial_stim,1)    % Draw the digits on the squares
                Screen('DrawText', w, num2str(trial_stim(i,8)),trial_stim(i,5)-6,trial_stim(i,6)-8, [255 255 255]'); % Position of text adjusted a little to centre in each square
            end
            DrawFormattedText(w, '+', 'center', 'center', [128 128 128]);        % Also keep the fixation cross
            Screen('Flip', w); % Present onscreen
            
            %            KbStrokeWait;
            %            break;
            
            %%%%%%%%%%%%%% Collect responses %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            tic; % Start timing from onset of stimuli
            while (1) % while stim are onscreen
                [keyIsDown,~,keyCode] = KbCheck(-1);    %check for keyboard responses
                if keyIsDown
                    resp = upper(KbName(keyCode));      % Get key pressed
                    if length(resp) == 1
                        if strfind(ini.target_key,resp)>0     % If it matches one of the response keys, end trial
                            RT = toc;                   % record response time
                            break
                        end
                    end
                    if keyCode(k.escape)               % esc to close experiment window. MAYBE WE SHOULDN'T ALLOW THIS IN THE MTURK VERSION SO PPL DON'T QUIT ACCIDENTALLY
                        ListenChar(1);
                        Screen('CloseAll');
                        ShowCursor;
                        fclose('all');
                        Priority(0);
                        clear all
                        break;
                    end
                    FlushEvents('keyDown');
                end
            end
            
            
            %%%%%%%%%%% Record data %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            response = ini.target_digit(strfind(ini.target_key,resp))   % Response digit
            resptime = round(RT*1000);                  % Convert RT to milliseconds
            
            
            % Record chosen target
            if response == left_target_digit                % Chose Targ1 (usually red)
                targchoice = 1
            elseif response == right_target_digit            % Chose Targ2 (usually blue)
                targchoice = 2
            else
                targchoice = 0                      % Chose neither (ie made an error)
            end
            
            % Accuracy: If resp matches either target num
            if targchoice > 0
                Acc = 1;                               % Accuracy = 1 (correct)
                blockacc = blockacc + 1;                % record for feedback at end of block
            else
                Beeper;                                 % Play beep sound to signal incorrect response
                Acc = 0;                                % Accuracy = 0 (incorrect)
            end
            
            % Determine is choice is optimal (1) or not (0)
            if targchoice == 0
                optchoice = NaN
            else
                if targchoice == optimal_side
                    optchoice = 1
                else
                    optchoice = 0
                end
            end
            
            % Determine if choice is switch or repeat
            
            if (prevchoice == 0)||(Acc == 0)              % if this is the first trial of the block, or this or previous trial was an error
                switchrep = NaN
            elseif targchoice == prevchoice             % If target was same as target chosen on previous trial
                switchrep = 1                          % Code as Repeat
            else
                switchrep = 2                           % Else code as wwitch
            end
            prevchoice = targchoice;                    % record current choice as previous choice for next trial
            
            
            % Print data to text file
            fprintf(ini.datafilepointer, ...
                '%s\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\t%i\n', ...
                sub_no, totaltrialcount, trial, block, left_target_ecc, ...
                right_target_ecc, ratio, left_target_pos, ...
                right_target_pos, left_target_digit, ...
                right_target_digit, response, targchoice, Acc, ...
                resptime, optchoice, switchrep);
            
            % Count total number of trials
            totaltrialcount = totaltrialcount + 1;
            
        end     % End trials
        %%%%%%%%%%% Break %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Present at the end of the block
        if (block > 0)
            blockacc = round(blockacc/trial*100);
            Screen('TextSize', w,30);
            if block < nblocks
                message = strcat('In this block, your accuracy was\n', ...
                    num2str(blockacc),'%.\n\nHave a short break.\n\nPress SPACE to start the next block');
            else
                message = strcat('In this block, your accuracy was\n', ...
                    num2str(blockacc),'%.\n\nGreat job! You have finished the experiment!');
            end
            DrawFormattedText(w, message, 'center', 'center', [255 255 255]);
            Screen('Flip', w);
            WaitSecs(.5);
            while (1)
                [~,~,keyCode ] = KbCheck;
                if keyCode(k.space)
                    break
                elseif keyCode(k.escape)
                    ListenChar(1);
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0);
                    clear all
                    break;
                end
            end
            FlushEvents('keyDown');
        end
        
    end         % End blocks
    
    
    %%%%%%%%%%%%%%%%%%%%% END EXPERIMENT %%%%%%%%%%%%%%%%%%%%%%%%%%
    ListenChar(1);
    Priority(0);
    ShowCursor
    Screen('CloseAll');
    fclose('all');
    clear all
catch % If something goes wrong within try/catch loop
    psychrethrow(psychlasterror);   % throw up error to command window
    ListenChar(1);
    Priority(0);
    ShowCursor
    Screen('CloseAll');
    clear all
end