
close all;
clear;

folder = '/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/MC14 Cefsulodin/';
reps = {'2017-07-27 cefsulodin12 MG lib rep1.xlsx','2017-07-28 cefsulodin12 MG lib rep2.xlsx'};
datasource = 1; % tecan = 0, epoch = 1
savename = 'cef';
savefiles = 1;
wellformat = 96; % 96 or 384
blankwells = [15];
maxgr_type = 1;%1 = fit a linear curve to logod over a window size N(=5), 2 = find max peak of the growthrate, 3 = gompertz fit
debug = 0; % will make plots
% this function will also plot each if you turn makeplots == 1. 

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
% t = t(1:size(num1,1))
% [~,wells] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/analysis scripts/wells.xlsx');
% load('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC01 Shape Growth Curve Imaging BW and MG/MC01.1/MC01.mat');
if debug
    figure('Position',[22 136 1217 562],'Color',[1 1 1])
end
% plots
od = num1-repmat(smooth(mean(num1(:,blankwells),2)),[1,wellformat]);
logod = od(1:end,:);
for i = 1:wellformat
    logod(:,i) = smooth(real(log(od(:,i))));
end
result = struct('maxgr',NaN,'lag',NaN,'finalod',NaN);
result = repmat(result,[1,96]);
for i = 1:wellformat
    if find(i == blankwells)
        result(i).maxgr = {NaN,NaN,NaN};
        result(i).lag = {NaN,NaN,NaN};
    else
        if debug
        subplot(2,3,1)
        plot(t,smooth(od(:,i))); hold on;
        title('OD');
        subplot(2,3,2)
        plot(t,logod(:,i)); hold on;
        ylim([-8 0])
        title('ln(OD)')
        subplot(2,3,3)
        rate = diff(logod(:,i))/diff(t);
        plot(t(2:end),rate); hold on;
        title('Growthrate')
        ylim([-.01 0.06])
        [result(i).maxgr,result(i).lag] = get_maxgrowthrate(logod(:,i),t,'makeplots',1,'subplotN',2,'subplotM',3,'subplotK',[4 5 6]);
        pause(.1);
        else
            [result(i).maxgr,result(i).lag] = get_maxgrowthrate(logod(:,i),t);
        end
        result(i).finalod = logod(end,i);
    end
    
end
% xlabel('Time (hr)')
% ylabel('OD (A.U)')
% xlim([0 20])
% 

% figure;

% subplot(1,3,1)
% bar(maxgr)
% title('Max Growthrate')
% subplot(1,3,2)
% bar(finalod)
% title('FinalOD')
% subplot(1,3,3)
% bar(lag)
% title('Lag')
% if savefiles
%     savefig([savename,'-maxgr.fig'])
%     export_fig([savename,'-maxgr.pdf'])
% end
growthcurvedata.(fname{count}) = result;

end
%%
cellwidth = get_metate_widths();
%%
figure('Color',[1 1 1],'Position',[0 0 1500 400])

if numel(reps) > 1
    maxgr = mean([cellfun(@(x) x.maxgr(2),growthcurvedata.rep1,'UniformOutput',false);cellfun(@(x) x.maxgr(2),growthcurvedata.rep2,'UniformOutput',false)]);
    maxgr_std = std([cellfun(@(x) x.maxgr(2),growthcurvedata.rep1,'UniformOutput',false);cellfun(@(x) x.maxgr(2),growthcurvedata.rep2,'UniformOutput',false)])/2;
    lag = mean([cellfun(@(x) x.lag(2),growthcurvedata.rep1,'UniformOutput',false);cellfun(@(x) x.lag(2),growthcurvedata.rep2,'UniformOutput',false)]);
    lag_std = std([cellfun(@(x) x.lag(2),growthcurvedata.rep1,'UniformOutput',false);cellfun(@(x) x.lag(2),growthcurvedata.rep2,'UniformOutput',false)])/2;
    finalod = mean([growthcurvedata.rep1.finalod ;growthcurvedata.rep2.finalod]);
    finalod_std = std([growthcurvedata.rep1.finalod;growthcurvedata.rep2.finalod])/2;
else
    maxgr =  cellfun(@(x) x.maxgr(2),growthcurvedata.rep1,'UniformOutput',false);
    lag = cellfun(@(x) x.lag(2),growthcurvedata.rep1,'UniformOutput',false);
    finalod = growthcurvedata.rep1.finalod;
end

[c1,r1,p1] = calcCorr(cellwidth,maxgr);
[c2,r2,p2] = calcCorr(cellwidth,lag);
[c3,r3,p3] = calcCorr(cellwidth,finalod);

idx = find(lag < 300);
subplot(1,3,1)
scatter(cellwidth(idx),maxgr(idx),50,[0 0 1],'filled'); hold on;
if numel(reps) > 1
errorbar(cellwidth(idx),maxgr(idx),maxgr_std(idx),'.')
end
plotlindatafit_cellwidth(cellwidth(idx),maxgr(idx));
title('Growthrate')
ylabel('Growthrate min^-1')
xlabel('Cell Width (µm)')
ylim([0.005 0.035])
text(0.05,0.015,sprintf('c = %0.2f',c1))
text(0.05,0.01,sprintf('p = %0.2e',p1))
prettifyplot
subplot(1,3,2)
scatter(cellwidth(idx),lag(idx),50,[0 0 1],'filled'); hold on;
if numel(reps) > 1
errorbar(cellwidth(idx),lag(idx),lag_std(idx),'.')
end
plotlindatafit_cellwidth(cellwidth(idx),lag(idx))
text(0.05,110,sprintf('c = %0.2f',c2))
text(0.05,90,sprintf('p = %0.2e',p2))
title('Lag')
ylabel('Lag time (min)')
xlabel('Cell width (µm)')
ylim([0 300])
prettifyplot
subplot(1,3,3)
scatter(cellwidth(idx),finalod(idx),50,[0 0 1],'filled'); hold on;
if numel(reps) > 1
errorbar(cellwidth(idx),finalod(idx),finalod_std(idx),'.')
end
plotlindatafit_cellwidth(cellwidth(idx),finalod(idx))
text(0.05,0.6,sprintf('c = %0.2f',c3))
text(0.05,0.4,sprintf('p = %0.2e',p3))
ylabel('OD (A.U.)')
ylim([0.2 1.2])
title('Final OD')
xlabel('Cell Width (µm)')
prettifyplot

% export_fig(sprintf('%s.pdf',savename))
% savefig(sprintf('%s.fig',savename))

% %%%%%%%%%%%%%%%%%%%%%%%% using MC01.mat data
% for i = 1:wellformat
%     if lag(i) < 300
%     well = eval(sprintf('data.%s',wells{i}));
%     idx = find(strcmp(well(:,2),'MG1655'));
%     mgwell = well(idx,:);
%     tpidx = find([mgwell{:,3}] == 90);
%     if tpidx
%         cellwidth = [cellwidth mean(mgwell{tpidx,5})];
%         subplot(1,3,1)
%         scatter(mean(mgwell{tpidx,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
%         subplot(1,3,2)
%         scatter(mean(mgwell{tpidx,5}),lag(i),50,[0 0 1],'filled'); hold on;
%         subplot(1,3,3)
%         scatter(mean(mgwell{tpidx,5}),finalod(i),50,[0 0 1],'filled'); hold on;
%     else
%         cellwidth = [cellwidth NaN];
%     end
%     else
%         cellwidth = [cellwidth NaN];
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%

