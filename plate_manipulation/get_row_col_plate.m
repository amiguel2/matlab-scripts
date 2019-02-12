function [row,column] = get_row_col_plate(wellformat,well)
% converts a well index number into a row/column format

load('/Users/amiguel/Dropbox/MATLAB/matlab_scripts/plate_manipulation/wellformat.mat')

if wellformat == 96
    for i = 1:numel(12)
        for j = 1:numel(8)
            if strcmp(well96format{j,i},well)
                row = j;
                column = i;
                return
            end
        end
    end
elseif wellformat == 384
    for i = 1:numel(24)
        for j = 1:numel(16)
            if strcmp(well384format{j,i},well)
                row = j;
                column = i;
                return
            end
        end
    end
end

end