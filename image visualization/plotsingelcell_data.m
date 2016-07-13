%%
%ind = find(data.length > 10);
ind = find(data.width < 0.85);
phase = data.file_phase(ind);
cont = data.file(ind);
cn = data.cellnum(ind);

for i=1:numel(ind)
     
    plotSingleCell_image(phase{i},cont{i},cn(i))
    pause

end

xlim([0 2560]);
ylim([0 2160]);