function l = get_startlen(f,c)
% get_startlen(f,c) where f is contour and c is cell number. requires f.cell
% structure
l = [];

if ~isfield(f,'cell')
    f.cell = f.cells;
end

for i = 1:numel(c)
    try
    fr = f.cell(c(i)).frames(1);
    cid = f.cell(c(i)).bw_label(1);
    catch
        fr = f.cell(c(i)).frame(1);
    cid = f.cell(c(i)).object(1);
    end
    l = [l f.frame(fr).object(cid).cell_length];
end
end