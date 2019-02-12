function f = convert_celltable(f)
% convert old cell table to new cell table, including changing cellID in
% frames to cellID reference in 'cells'

if ~isstruct(f)
    f = load(f);
else
    f = f;
end

f.cells = struct('frame','object');

f.Ncell = numel(f.cell);
for i = 1:numel(f.cell)
    frames = f.cell(i).frames;
    objects = f.cell(i).bw_label;
    
    %repopulate new cell table
    f.cells(i).frame = frames;
    f.cells(i).object = objects;
    
    % change cellID appropriately
    for k = 1:numel(frames)
        f.frame(frames(k)).object(objects(k)).cellID = i;
    end
end

% dealing with cell vs string
name = strsplit(f.outname,'/');
save(name{end},'-struct','f');

end