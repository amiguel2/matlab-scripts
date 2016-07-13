function plot_cell(f,cid)
if isa(f,'char')
    f = load(f);
end
cellfr = f.cells(cid).frame;
cellob = f.cells(cid).object;
for i = 1:numel(cellfr)
    thisframe = cellfr(i);
    thisob = cellob(i);
    plot(f.frame(thisframe).object(thisob).Xcont,f.frame(thisframe).object(thisob).Ycont)
    hold on;
    pause(.1)
end
end