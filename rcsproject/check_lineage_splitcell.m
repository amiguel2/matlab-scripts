function output = check_lineage_splitcell(f,j,l,k)
% performs the lineage tracking for split cells. output will be a cell
% array with 1 and 0s fi cell passes lineage tracking. right now only
% really concerns starting split cell and ending split cell.
% l = cell trajectory length

 output = {};
 n = numel(l);
% for k = 1:n
    % check lineage
    if isempty(l{k})
        output = 0;
    else
        if k == 1 
            if ~isempty(find_mothercell(f,j))
                output = 1;
            else
                output = 0;
            end
        elseif k == n 
            if ~isempty(find_daughtercell(f,j))
                output = 1;
            else
                output = 0;
            end
        else
            output = 1;
        end
    end
end