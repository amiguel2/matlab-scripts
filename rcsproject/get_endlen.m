function l = get_endlen(f,c)
% get_endlen(f,c) where f is contour and c is cell number. requires f.cell
% structure
l = [];

if ~isfield(f,'cell')
    f.cell = f.cells;
end
for i = 1:numel(c)

    try
    fr = f.cell(c(i)).frames(end);
    cid = f.cell(c(i)).bw_label(end);
    catch
        fr = f.cell(c(i)).frame(end);
    cid = f.cell(c(i)).object(end);
    end
    l = [l f.frame(fr).object(cid).cell_length];
end
end