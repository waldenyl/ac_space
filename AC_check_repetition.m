function output_bool = AC_check_repetition(matrix, column, threshold)
%AC_CHECK_REPITITION Summary of this function goes here
%   Detailed explanation goes here
output_bool = false;
i = 1;
rep = 1;
last_entry = matrix(1, column);

while i < size(matrix, 1)
    i = i + 1;
    if matrix(i, column) == last_entry
        rep = rep + 1;
    else
        rep = 1;
    end
    if rep > threshold
        output_bool = true;
        break;
    end
end
end

