function output = AC_get_grid_pos(screen_x, screen_y)
    %AC_get_grid_pos
    % Given 
    % Syntax: output = myFun(input)
    %
    % Long description
    
    % Initialize output
    gridpos = [];
    
    % Set local variables
    innerradius = 240; % Radius of the inner ring in pixels. Might need to adjust to fit display. Default is 240 (had been used successfully with monitor resolutions of 1920x1080 and 1280x1024).
    % innerrad also determines radius of middle ring (innerrad*1.5) and outer ring (innerrad*2)
    ringitemnum = [12,18,24];
    inneritems = ringitemnum(1);    % items in inner ring

    % Compute necessary parameters
    x_center = screen_x/2;
    y_center = screen_y/2;

    % inner ring of display
    for item = 1:inneritems
        gridpos(item,1) = (x_center+innerradius*sind(item*360/inneritems));  % X position
        gridpos(item,2) = (y_center-1*innerradius*cosd(item*360/inneritems));% Y position
        gridpos(item,3) = 1; % variable used to code ring number: 1 = inner ring
        gridpos(item,4) = item; % number used to track item location in the display (1-54)
    end
    % middle ring
    miditems = ringitemnum(2);
    midradius = innerradius*1.5;
    for item = 1:miditems
        gridpos(item+inneritems,1) = (x_center+midradius*sind(item*360/miditems));  % X position
        gridpos(item+inneritems,2) = (y_center-1*midradius*cosd(item*360/miditems));% Y position
        gridpos(item+inneritems,3) = 2; % ring number: 2 = middle ring
        gridpos(item+inneritems,4) = item+inneritems; % number used to track item location in the display (1-54)
    end
    % outer ring
    outeritems = ringitemnum(3);
    outerradius = innerradius*2;
    for item = 1:outeritems
        gridpos(item+miditems+inneritems,1) = (x_center+outerradius*sind(item*360/outeritems));  % X position
        gridpos(item+miditems+inneritems,2) = (y_center-1*outerradius*cosd(item*360/outeritems));% Y position
        gridpos(item+miditems+inneritems,3) = 3; % ring number: 3 = outer ring
        gridpos(item+miditems+inneritems,4) = item+miditems+inneritems; % number used to track item location in the display (1-54)
    end
    
    num = size(gridpos,1);
    output = zeros(num,5);
    for i = 1:num
        if gridpos(i,1) ~= screen_x/2 % If it is not on the center column, record it in the output
            output(i,1:4) = gridpos(i,:);
            if gridpos(i,1) < screen_x/2
                output(i,5) = 1; % Left
            else
                output(i,5) = 2; % right
            end
        end
    end
    
    output = output(~all(output == 0, 2),:);
    

end