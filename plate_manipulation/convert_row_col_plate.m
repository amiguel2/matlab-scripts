function well = convert_row_col_plate(row,column,wellformat)
% converts a well index number into a row/column format
if ~exist('wellformat')
    wellformat = 96;
end
if wellformat == 96
    well = 12*(row-1) + column;
elseif wellformat == 384
    well = 24*(row-1) + column;
end
end