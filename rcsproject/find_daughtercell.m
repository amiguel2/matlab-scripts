function [daughtercell] = find_daughtercell(f,c)
% finds daughter cells of a specified cellid in contour file using overlap
% method and checking if area of daughter/mother looks correct. Ignores overlap less
% than 10%

if ~isfield(f,'cell')
    f.cell = f.cells;
end

try
    fr = f.cell(c).frames;
    cid = f.cell(c).bw_label;
catch
    fr = f.cell(c).frame;
    cid = f.cell(c).object;
end
xstart = f.frame(fr(end)).object(cid(end)).Xcont;
ystart = f.frame(fr(end)).object(cid(end)).Ycont;
targetcellmask = poly2mask(xstart,ystart,1002,1004);
linked_cid = [];
p_overlap = [];

    % for all cells after target cell
    idx = find(cellfun(@numel,{f.cells(1:end).object}) > 3);
    temp = cellfun(@(x) x(1),{f.cells(idx).frame},'UniformOutput',false);
    pot_cells = idx(find([temp{:}] == fr(end)+1));
    for a = pot_cells
        try
            frnew = f.cell(a).frames(f.cell(a).frames == fr(end)+1); %get mask of new cell
            cidnew = f.cell(a).bw_label(f.cell(a).frames == fr(end)+1);
        catch
            frnew = f.cell(a).frame(f.cell(a).frame == fr(end)+1); %get mask of new cell
            cidnew = f.cell(a).object(f.cell(a).frame == fr(end)+1);
        end
        if numel(frnew) > 1 %some cells have bad labelling. Using this to skip them
            daughtercell = [];
            return
        end
        
        if ~isempty(f.frame(frnew).object(cidnew).area)
            xnewcell = f.frame(frnew).object(cidnew).Xcont;
            ynewcell = f.frame(frnew).object(cidnew).Ycont;
            newcellmask = poly2mask(xnewcell,ynewcell,1002,1004);
            summatrix = targetcellmask + newcellmask;
            percent_overlap = numel(find(summatrix == 2))/numel(find(targetcellmask == 1));
            if percent_overlap > 0.1 && f.frame(frnew).object(cidnew).area < f.frame(fr(end)).object(cid(end)).area%if percent overlap
                %fprintf('cell %d with cell: %d overlap = %0.2f\n',c,a,percent_overlap)
                linked_cid = [linked_cid a]; % record cell
                p_overlap = [p_overlap percent_overlap];
            end
        end
    end
    
    %fprintf('number of overlapping cells = %d\n',numel(linked_cid))
    daughtercell = [];
    for j = 1:numel(linked_cid)
        c0 = find_mothercell(f,linked_cid(j));
        %fprintf('targetcell %d daughter cell %d, mother %d\n',c,linked_cid(j),c0)
        if c == c0
            daughtercell = [daughtercell linked_cid(j)];
        end
    end
end