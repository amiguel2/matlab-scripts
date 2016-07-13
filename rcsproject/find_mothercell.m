function [mothercell] = find_mothercell(f,c)
% Finds mothercell of specified cellid in contour file using an overlap
% method and checking if area of daughter/mother looks correct. Ignores overlap less
% than 10%

% checks if cells exists
if ~isfield(f,'cell')
    f.cell = f.cells;
end


% switches between old and new version of cell table
try
    fr = f.cell(c).frames; %target cell
    cid = f.cell(c).bw_label;
catch
    fr = f.cell(c).frame; %target cell
    cid = f.cell(c).object;
end


% looks at cell and segments it.
xstart = f.frame(fr(1)).object(cid(1)).Xcont; %get segmented image for target cell
ystart = f.frame(fr(1)).object(cid(1)).Ycont;
targetcellmask = poly2mask(xstart,ystart,1002,1004);
p_overlap = 0; % sets p_overlap
mothercell = [];

idx = find(cellfun(@numel,{f.cells(1:c).object}) > 3);
temp = cellfun(@(x) x(end),{f.cells(idx).frame},'UniformOutput',false);
pot_cells = idx(find([temp{:}] == fr(1)-1));
for a = pot_cells %for all cells that appear before target cell
    
    try
        frnew = f.cell(a).frames(f.cell(a).frames == fr(1)-1);
        cidnew = f.cell(a).bw_label(f.cell(a).frames == fr(1)-1);
    catch
        frnew = f.cell(a).frame(f.cell(a).frame == fr(1)-1);
        cidnew = f.cell(a).object(f.cell(a).frame == fr(1)-1);
    end
    if numel(frnew) > 1 %some cells have bad labelling. Using this to skip them
        return
    end
    if ~isempty(f.frame(frnew).object(cidnew).area)
    %get segmented image for target cell
    xnewcell = f.frame(frnew).object(cidnew).Xcont;
    ynewcell = f.frame(frnew).object(cidnew).Ycont;
    newcellmask = poly2mask(xnewcell,ynewcell,1002,1004);
    summatrix = targetcellmask + newcellmask; % add masks together
    percent_overlap = numel(find(summatrix == 2))/numel(find(targetcellmask == 1)); %find percentage of cells where matrix is additive
    if percent_overlap > p_overlap && percent_overlap > 0.1 && f.frame(frnew).object(cidnew).area > f.frame(fr(1)).object(cid(1)).area % at least overlap greater than 10%
        mothercell = a; %record that cell
        p_overlap = percent_overlap;
    end
    end
end
end