function [meanl,meanw] = averages_of_stack(prefix)
list = dir(prefix);
pixel = 0.08;

meanw = []; meanl = [];
for i = 1:numel(list)
    f = load(list(i).name);
    w = []; l = [];
    for j = 1:numel(f.frame)
        w = [ w extractfield(f.frame(j).object,'cell_width')];
        l = [ l extractfield(f.frame(j).object,'cell_length')];
    end
    fprintf('%s: %f %f\n',list(i).name,mean(l*pixel),mean(w*pixel))
    subplot(1,2,1)
    histogram(l); hold on; title('Length')
    subplot(1,2,2)
    histogram(w); hold on; title('Width')
    meanw = [meanw mean(w*pixel)];
    meanl = [meanl mean(l*pixel)];
end

end