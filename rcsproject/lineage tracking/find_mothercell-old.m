function mothercell = find_mothercell(f,c)

fr = f.cell(c).frames; %target cell
cid = f.cell(c).bw_label;

xstart = f.frame(fr(1)).object(cid(1)).Xcont; %get segmented image for target cell
ystart = f.frame(fr(1)).object(cid(1)).Ycont;
targetcellmask = poly2mask(xstart,ystart,1002,1004);
p_overlap = 0;
mothercell = [];
for a = 1:c %for all cells that appear before target cell
    idx = find(f.cell(a).frames == fr(1)-1); % if cell appears in previous frame
    if ~isempty(idx) %if cell is found
        frnew = f.cell(a).frames(idx);
        cidnew = f.cell(a).bw_label(idx);
        %get segmented image for target cell
        xnewcell = f.frame(frnew).object(cidnew).Xcont;
        ynewcell = f.frame(frnew).object(cidnew).Ycont;
        newcellmask = poly2mask(xnewcell,ynewcell,1002,1004);
        summatrix = targetcellmask + newcellmask; % add masks together
        percent_overlap = numel(find(summatrix == 2))/numel(find(targetcellmask == 1)); %find percentage of cells where matrix is additive
        if percent_overlap > p_overlap
            mothercell = a; %record that cell
            p_overlap = percent_overlap;
        end
        
    end
end
end