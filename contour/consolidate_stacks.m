function newf = consolidate_stacks(list)
list = list(~cellfun(@(x) strcmp(x(1),'.'),{list.name})); % remove hidden files
newf = struct();
newf.frame = [];
for i = 1:numel(list)
    f = load(list(i).name);
    newf.frame = [newf.frame f.frame];
end
end