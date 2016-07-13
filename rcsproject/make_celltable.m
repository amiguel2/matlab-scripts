function contour = make_celltable(f)
% creates a cell table the way morphometrics 2015 version does.
if ~isstruct(f)
    contour = load(f);
else
    contour = f;
end
if ~isfield(f,'Ncell')
    contour = convert_celltable(contour);
    return
end

for i=1:contour.Ncell
    q=0;
    for j=1:length(contour.frame)
        if isfield(f.frame(1),'num_cells')
            contour.frame(j).num_objs = contour.frame(j).num_cells;
        end
        for k=1:contour.frame(j).num_objs
            ind1=contour.frame(j).object(k).cellID;
            
            if ind1==i
                q=q+1;
                contour.cells(i).frame(q)=j;
                contour.cells(i).object(q)=k;
            end
        end
    end
end
if isstruct(f)
    name = strsplit(contour.outname,'/');
    save(name{end},'-struct','contour');
else
    save(f,'-struct','contour');
end
end