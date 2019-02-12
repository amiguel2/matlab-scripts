function [cellstructure] = get_SLIPdata(folder,pxl,varargin) 

well = 384;
list = dir([folder '/*CONTOURS.mat']);
fluor = 0;
count = 0;
cellstructure = {};

for i = 1:numel(list) 
    count = count + 1;
    [l,w] = processfile;
    cellstructure(count) = {'filename',list(1).name,'mutant',mutant,'length',l,'width',w};
end

end

function [l,w] = processfile(file)
    l = [];
    w = [];
    f = load(file);
    for j = 1:numel(f.frame)
        l = [l extractfield(f.frame(j).object,'cell_length')];
        w = [w extractfield(f.frame(j).object,'cell_width')];
    end
end

function get_mut_names(well,strain,reference)

end

count = 0;
for i = 1:24
    for j = 1:16
        count = count +1;
        strain384(i,j) = plates25IDs.Keio96plate(count);
    end
end

