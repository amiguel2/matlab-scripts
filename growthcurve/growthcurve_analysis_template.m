
close all;
clear;

folder = '/Users/amiguel/Dropbox/Research/Projects/Rcs_System/RCS04_GrowthCurves/2018-11-27 A22_IPTG_experiment/';
reps = {'2018-11-27 Rcs A22 IPTG.xlsx'};
datasource = 1; % tecan = 0, epoch = 1
blankwells = [79:84 91:96];

cd(folder)

%%%%%%%%%%%%%%%%%%%%%%%%%
growthcurvedata = struct;
fname = {};
for i = 1:numel(reps)
    fname = [fname sprintf('rep%d',i)];
end
count = 0;

for rep = reps
    count = count + 1;
    file = rep{:};
    % data
    if datasource
        [num1,t] = readEpochdata([folder file]);
    else
        [num1,t] = readTecandata([folder file]);
    end
    % plots
    od = num1-repmat(smooth(mean(num1(:,blankwells),2)),[1,96]);
    logod = od(1:end,:);
    for i = 1:96
        logod(:,i) = smooth(real(log(od(:,i))));
    end
    data{count} = od;
    time{count} = t;
end
%%
plot_od_96well(data,time)


