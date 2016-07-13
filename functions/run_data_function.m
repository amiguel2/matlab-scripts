%load('LM15-S32_celldata. mat');
c = cbrewer('qual','Set1',4);
for i = 1:numel(cond) 
    plot_data_over_time(cond{i},cond{i}.title,c(i,:))  
    pause 
end

%%
title = cellfun(@(x) x.title, cond, 'UniformOutput',false);
plot_growthrate_histogram(cond,title,c,[50,50,50,50])
xlim([0 0.14])
 