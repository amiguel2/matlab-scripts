function output = check_lineage_splitcells(f,j,l)
% performs the lineage tracking for split cells. output will be a cell
% array with 1 and 0s fi cell passes lineage tracking. right now only
% really concerns starting split cell and ending split cell.
% l = cell trajectory length

output = {};
n = numel(l);
for k = 1:n
    % check lineage
    if isempty(l{k})
        output{k} = 0;
    else
        if k == 1 % second cell is in the first slot
            if ~isempty(find_mothercell(f,j))
                output{k} = 1;
            else
                output{k} = 0;
            end
        elseif k == n %first cell in the second slot
            if ~isempty(find_daughtercell(f,j))
                output{k} = 1;
            else
                output{k} = 0;
            end
        end
    end
end
end