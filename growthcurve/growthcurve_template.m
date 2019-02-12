
close all;
clear;
folder = '/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC09 A22/';
rep1 = '2017-03-18 MG FACS MreB Library A22 0p5 10000 dilution.xlsx';
rep2 = '2017-03-27 LB A22 0p5 MG MreB FACS 10000 dilution rep2.xlsx';
datasource = 0; % tecan = 0, epoch = 1
savename = 'A22op5-growthcurves';
multireps = 1;
savefiles = 0;
wellformat = 96; % 96 or 384
blank = 15;
blankwells = [15];


%%%%%%%%%%%%%%%%%%%%%%%%%
growthcurvedata = struct;
fname = {'rep1','rep2'};
count = 0;
if multireps 
    reps = {rep1,rep2};
else
    reps = {rep1};
end
for rep = reps
    count = count + 1;
    file = rep{:};
% data
if datasource
    [num1,t] = readEpochdata([folder file]);
else
    [num1,t] = readTecandata([folder file]);
end

% [~,wells] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/analysis scripts/wells.xlsx');
% load('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC01 Shape Growth Curve Imaging BW and MG/MC01.1/MC01.mat');

% plots
od = num1-repmat(smooth(num1(:,blank)),[1,wellformat]);
logod = od(1:end,:);
for i = 1:wellformat
    logod(:,i) = real(log(od(:,i)+exp(-5)));
end
result = cell(1,96);
for i = 1:wellformat
    if find(i == blankwells)
        blankfitresult = fitresult;
        blankfitresult.mu = NaN;
        blankfitresult.lambda = NaN;
        blankfitresult.OD_sat = NaN;
        blankfitresult.OD_0 = NaN;
        result{i} = blankfitresult;
    else
        subplot(1,3,1)
        plot(t,smooth(od(:,i))); hold on;
        subplot(1,3,2)
        plot(t,logod(:,i)); hold on;
        subplot(1,3,3)
        rate = diff(logod(:,i))/diff(t);
        plot(t(2:end),rate); hold on;
        x = ~isinf(logod(:,i));
        l = logod(x,i);
        t1 = t(x);
        [fitresult,gof] = fitGompertzModel(t1(5:end),l(5:end));
        result{i} = fitresult;
%         fitresult
%         pause;
    end
end
pause

% xlabel('Time (hr)')
% ylabel('OD (A.U)')
% xlim([0 20])
% 

% figure;
maxgr = extractGompertzfitresult(result,'mu');
finalod = extractGompertzfitresult(result,'OD_sat');
lag = extractGompertzfitresult(result,'lambda');
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
growthcurvedata.(fname{count}).maxgr = maxgr;
growthcurvedata.(fname{count}).lag = lag;
growthcurvedata.(fname{count}).finalod = finalod;
end
cellwidth = get_metate_widths();

figure('Color',[1 1 1],'Position',[0 0 1500 400])

if multireps
    maxgr = mean([growthcurvedata.rep1.maxgr;growthcurvedata.rep2.maxgr]);
    maxgr_std = std([growthcurvedata.rep1.maxgr;growthcurvedata.rep2.maxgr])/2;
    lag = mean([growthcurvedata.rep1.lag;growthcurvedata.rep2.lag]);
    lag_std = std([growthcurvedata.rep1.lag;growthcurvedata.rep2.lag])/2;
    finalod = mean([growthcurvedata.rep1.finalod ;growthcurvedata.rep2.finalod]);
    finalod_std = std([growthcurvedata.rep1.finalod;growthcurvedata.rep2.finalod])/2;
else
    maxgr =  growthcurvedata.rep1.maxgr;
    lag = growthcurvedata.rep1.lag;
    finalod = growthcurvedata.rep1.finalod;
end

[c1,r1,p1] = calcCorr(cellwidth,maxgr);
[c2,r2,p2] = calcCorr(cellwidth,lag);
[c3,r3,p3] = calcCorr(cellwidth,finalod);

idx = find(lag < 300);
subplot(1,3,1)
scatter(cellwidth(idx),maxgr(idx),50,[0 0 1],'filled'); hold on;
if multireps
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
if multireps
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
if multireps
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

export_fig(sprintf('%s.pdf',savename))
savefig(sprintf('%s.fig',savename))

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

