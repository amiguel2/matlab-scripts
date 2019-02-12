function contour = make_celltable(f)
% creates a cell table the way morphometrics 2015 version does.

recalc = 0;

% takes either string or morph structure
if ~isstruct(f)
    contour = load(f);
else
    contour = f;
end

%

if isfield(contour,'cell')
    fprintf('Found field ''cell''. Converted cells to cells, did not recalculate\n')
    contour.cells = contour.cell;
    contour = rmfield(contour,'cell');
    return
end

if recalc
contour = rmfield(contour,'Ncell');
contour = rmfield(contour,'cells');
end

% calc Ncell
if ~isfield(contour,'Ncell')
    contour.Ncell = calc_Ncell(contour);
end

% calc cell IDS
contour = calc_cellid(contour);

% save structure
if isstruct(f)
    if isfield(contour,'outname')
        name = strsplit(contour.outname,'/');
        save(name{end},'-struct','contour');
    end
        
else
    save(f,'-struct','contour');
end
end

function maxcell = calc_Ncell(contour)
% counts of the number of cells unique cell IDs
maxcell = 0;
    for i= 1:numel(contour.frame)
        if contour.frame(i).num_objs > 0
            tempmax = max([contour.frame(i).object.cellID]);
            maxcell = max([maxcell tempmax]);
        end
    end
end

function contour = calc_cellid(contour)
% creates a structure field 'cells' that represents a unique cell id
% and puts the frames it shows up in 'frames' and the index placement in
% 'object'

for i=1:contour.Ncell
    q=0;
    for j=1:length(contour.frame)
        if isfield(contour.frame(1),'num_cells')
            contour.frame(j).num_objs = contour.frame(j).num_cells;
        end
        for k=1:contour.frame(j).num_objs
            if isfield(contour.frame(j).object(k),'cellID')
                ind1=contour.frame(j).object(k).cellID;
                
                if ind1==i
                    q=q+1;
                    contour.cells(i).frame(q)=j;
                    contour.cells(i).object(q)=k;
                end
            end
        end
    end
end
end
