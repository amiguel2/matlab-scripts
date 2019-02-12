
close all;
clear;
cd '/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC07 Metformin/'
file = '2017-03-29 LB metformin 40mM MG MreB FACS 10000 dilution rep1.xlsx';
ph = 0;
tinterval = 6.033333333;
savename = 'cinorep1';
savefiles = 1;
wellformat = 96; % 96 or 384
gompertz = 1;
savepeakgr = 0;
savemaxgr = 1;
grtimeindex = 27; % used only only if savepeakgr = 0;


[~,wells] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/analysis scripts/wells.xlsx');
blankwells = [15];


% data
[num1,txt1,raw1] = xlsread(file,'C35:NV240'); % label 1 (OD)
if ph
    [num2,txt2,raw2] = xlsread(file,'C231:CT381'); % label 2 (F1)
    [num3,txt3,raw3] = xlsread(file,'C416:CT566'); % label 3 (F2)
end


t = (0:size(num1,1)-1)*tinterval;% time in minutes
%cellshape data
load('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC01 Shape Growth Curve Imaging BW and MG/MC01.1/MC01.mat');

% plots
od = num1-repmat(num1(:,15),[1,wellformat]);
logod = od(1:end,:);
for i = 1:wellformat
    logod(:,i) = smooth(real(log(od(1:end,i))),10);
end
t1 = t(1:end);
maxgr = zeros(wellformat,1);
finalod = zeros(wellformat,1);
for i = 1:wellformat
    if find(i == blankwells)
        maxgr(i,1) = NaN;
    else
        subplot(1,2,1)
        plot(t1/60,logod(:,i)); hold on;
        subplot(1,2,2)
        rate = diff(logod(:,i))/(t1(2)-t1(1));
        plot(t1(2:end)/60,smooth(rate)); hold on;
        rate = rate(30:100);
        idx = find(isinf(rate));
        rate(idx) = NaN;
        finalod(i,1) = od(end,i);
        srate = smooth(rate,10);
        if gompertz
            [fitresult,gof] = fitGompertzModel(t(~isinf(l))',l(~isinf(l)));
            maxgr(i,1) = fitresult.mu(1);
        elseif savepeakgr
            %             findpeaks(smooth(rate),'Npeaks',1,'MinPeakProminence',0.005);
            %             pause;
            P = findpeaks(smooth(rate),'Npeaks',1,'MinPeakProminence',0.003);
            if numel(P) ~= 1
                P = findpeaks(smooth(rate),'Npeaks',1,'MinPeakProminence',0.002);
                if numel(P) ~= 1
                    P = findpeaks([flip(smooth(rate));smooth(rate)],'Npeaks',1,'MinPeakProminence',0.002);
                end
            end
            
            if isempty(P)
                maxgr(i,1) = NaN;
            else
                maxgr(i,1) = P;
            end
        elseif savemaxgr
            maxgr(i,1) = max(rate)
        else
            maxgr(i,1) = srate(grtimeindex);
        end
    end
    %     pause;
end
subplot(1,2,1)
xlabel('Time (hr)')
ylabel('OD (A.U)')
xlim([0 20])

subplot(1,2,2)
xlabel('Time (hr)')
ylabel('Growthrate d(log(OD-blank))/dt')
xlim([0 20])
if ~savemaxgr
    plot([t1(grtimeindex)/60 t1(grtimeindex)/60],[-0.15 0.1],'Color','black','LineStyle',':')
end
ylim([-0.15 0.1])
if savefiles
    savefig([savename,'-od.fig'])
    export_fig([savename,'-od.pdf'])
end
figure;
bar(maxgr)
title('Max Growthrate')
if savefiles
    savefig([savename,'-maxgr.fig'])
    export_fig([savename,'-maxgr.pdf'])
end

eval(sprintf('%smaxgr = maxgr;',savename));
save(sprintf('%smaxgr',savename),sprintf('%smaxgr',savename))
eval(sprintf('%sfinalod = finalod;',savename));
save(sprintf('%sfinalod',savename),sprintf('%sfinalod',savename))
origmaxgr = maxgr;
origfinalod = finalod
%%
close all
% wellformat = 96;
% maxgr = origmaxgr(cwells2);
% finalod = origfinalod(cwells2);
% savename = 'Met40mMrep1-C2';
% length
figure('Color',[1 1 1],'Position',[0 0 700 400])
celldata = cell(1,6);
celldata{1} = NaN(1,wellformat);
celldata{2} = NaN(1,wellformat);
celldata{3} = NaN(1,wellformat);
celldata{4} = NaN(1,wellformat);
celldata{5} = NaN(1,wellformat);
celldata{6} = NaN(1,wellformat);

grdata = cell(1,6);
grdata{1} = NaN(1,wellformat);
grdata{2} = NaN(1,wellformat);
grdata{3} = NaN(1,wellformat);
grdata{4} = NaN(1,wellformat);
grdata{5} = NaN(1,wellformat);
grdata{6} = NaN(1,wellformat);

for i = 1:wellformat
    well = eval(sprintf('data.%s',wells{i}));
    idx = find(strcmp(well(:,2),'MG1655'));
    for j = idx'
        if well{j,3} == 0
            subplot(2,3,1)
            scatter(median(well{j,4}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{1}(1,i) = maxgr(i);
            celldata{1}(1,i) = median(well{j,4});
        elseif well{j,3} == 30
            subplot(2,3,2)
            scatter(median(well{j,4}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{2}(1,i) = maxgr(i);
            celldata{2}(1,i) = median(well{j,4});
        elseif well{j,3} == 60
            subplot(2,3,3)
            scatter(median(well{j,4}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{3}(1,i) = maxgr(i);
            celldata{3}(1,i) = median(well{j,4});
        elseif well{j,3} == 90
            subplot(2,3,4)
            scatter(median(well{j,4}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{4}(1,i) = maxgr(i);
            celldata{4}(1,i) = median(well{j,4});
        elseif well{j,3} == 120
            subplot(2,3,5)
            scatter(median(well{j,4}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{5}(1,i) = maxgr(i);
            celldata{5}(1,i) = median(well{j,4});
        elseif well{j,3} == 150
            subplot(2,3,6)
            scatter(median(well{j,4}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{6}(1,i) = maxgr(i);
            celldata{6}(1,i) = median(well{j,4});
        end
        
    end
end

% length
subplot(2,3,1)
x = celldata{1};
y = grdata{1};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(1,6,100),polyval(flip(model.Coefficients),linspace(1,6,100)))
[r,p] = corrcoef(x1,y1);
ylim([0.005 0.055])
% xlim([0.5 2.5])
text(4,0.01,sprintf('p=%5.2e',p(1,2)))
text(4,0.012,sprintf('c=%0.4f',r(1,2)))
text(4,0.008,sprintf('R2=%0.4f',model.AdjustedR2))

xlabel('Length (um)')
ylabel('Max Growth')
title('Timepoint 0')

subplot(2,3,2)
x = celldata{2};
y = grdata{2};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(1,6,100),polyval(flip(model.Coefficients),linspace(1,6,100)))

[r,p] = corrcoef(x1,y1);
text(4,0.01,sprintf('p=%5.2e',p(1,2)))
text(4,0.012,sprintf('c=%0.4f',r(1,2)))
text(4,0.008,sprintf('R2=%0.4f',model.AdjustedR2))
ylim([0.005 0.055])
% xlim([0.5 2.5])
xlabel('Length (um)')
ylabel('Max Growth')
title('Timepoint 30')

subplot(2,3,3)
x = celldata{3};
y = grdata{3};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(1,6,100),polyval(flip(model.Coefficients),linspace(1,6,100)))

[r,p] = corrcoef(x1,y1);
text(4,0.01,sprintf('p=%5.2e',p(1,2)))
text(4,0.012,sprintf('c=%0.4f',r(1,2)))
text(4,0.008,sprintf('R2=%0.4f',model.AdjustedR2))
ylim([0.005 0.055])
% xlim([0.5 2.5])
xlabel('Length (um)')
ylabel('Max Growth')
title('Timepoint 60')

subplot(2,3,4)
x = celldata{4};
y = grdata{4};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(1,6,100),polyval(flip(model.Coefficients),linspace(1,6,100)))

[r,p] = corrcoef(x1,y1);
text(4,0.01,sprintf('p=%5.2e',p(1,2)))
text(4,0.012,sprintf('c=%0.4f',r(1,2)))
text(4,0.008,sprintf('R2=%0.4f',model.AdjustedR2))
ylim([0.005 0.055])
% xlim([0.5 2.5])
xlabel('Length (um)')
ylabel('Max Growth')
title('Timepoint 90')

subplot(2,3,5)
x = celldata{5};
y = grdata{5};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(1,6,100),polyval(flip(model.Coefficients),linspace(1,6,100)))

[r,p] = corrcoef(x1,y1);
text(4,0.01,sprintf('p=%5.2e',p(1,2)))
text(4,0.012,sprintf('c=%0.4f',r(1,2)))
text(4,0.008,sprintf('R2=%0.4f',model.AdjustedR2))
ylim([0.005 0.055])
% xlim([0.5 2.5])
xlabel('Length (um)')
ylabel('Max Growth')
title('Timepoint 120')

subplot(2,3,6)
x = celldata{6};
y = grdata{6};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(1,6,100),polyval(flip(model.Coefficients),linspace(1,6,100)))

[r,p] = corrcoef(x1,y1);
text(4,0.01,sprintf('p=%5.2e',p(1,2)))
text(4,0.012,sprintf('c=%0.4f',r(1,2)))
text(4,0.008,sprintf('R2=%0.4f',model.AdjustedR2))
ylim([0.005 0.055])
% xlim([0.5 2.5])
xlabel('Length (um)')
ylabel('Max Growth')
title('Timepoint 150')

if savefiles
    savefig([savename,'-maxgrVScelllength.fig'])
    export_fig([savename,'maxgrVScelllength.pdf'])
end

% width vs growthrate
figure('Color',[1 1 1],'Position',[0 0 700 400])
celldata = cell(1,6);
celldata{1} = NaN(1,wellformat);
celldata{2} = NaN(1,wellformat);
celldata{3} = NaN(1,wellformat);
celldata{4} = NaN(1,wellformat);
celldata{5} = NaN(1,wellformat);
celldata{6} = NaN(1,wellformat);

grdata = cell(1,6);
grdata{1} = NaN(1,wellformat);
grdata{2} = NaN(1,wellformat);
grdata{3} = NaN(1,wellformat);
grdata{4} = NaN(1,wellformat);
grdata{5} = NaN(1,wellformat);
grdata{6} = NaN(1,wellformat);

for i = 1:wellformat
    well = eval(sprintf('data.%s',wells{i}));
    idx = find(strcmp(well(:,2),'MG1655'));
    for j = idx'
        if well{j,3} == 0
            subplot(2,3,1)
            scatter(median(well{j,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{1}(1,i) = maxgr(i);
            celldata{1}(1,i) = median(well{j,5});
        elseif well{j,3} == 30
            subplot(2,3,2)
            scatter(median(well{j,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{2}(1,i) = maxgr(i);
            celldata{2}(1,i) = median(well{j,5});
        elseif well{j,3} == 60
            subplot(2,3,3)
            scatter(median(well{j,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{3}(1,i) = maxgr(i);
            celldata{3}(1,i) = median(well{j,5});
        elseif well{j,3} == 90
            subplot(2,3,4)
            scatter(median(well{j,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{4}(1,i) = maxgr(i);
            celldata{4}(1,i) = median(well{j,5});
        elseif well{j,3} == 120
            subplot(2,3,5)
            scatter(median(well{j,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{5}(1,i) = maxgr(i);
            celldata{5}(1,i) = median(well{j,5});
        elseif well{j,3} == 150
            subplot(2,3,6)
            scatter(median(well{j,5}),maxgr(i),50,[0 0 1],'filled'); hold on;
            grdata{6}(1,i) = maxgr(i);
            celldata{6}(1,i) = median(well{j,5});
        end
        
    end
end

% width
subplot(2,3,1)
x = celldata{1};
y = grdata{1};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
[r,p] = corrcoef(x1,y1);
text(1.7,0.037,sprintf('c=%0.4f',r(1,2)))
text(1.7,0.033,sprintf('p=%5.2e',p(1,2)))
ylim([0.005 0.055])
xlim([0.5 2.5])
text(1.7,0.035,sprintf('R2=%0.4f',model.AdjustedR2))

xlabel('Width (um)')
ylabel('Max Growth')
title('Timepoint 0')

subplot(2,3,2)
x = celldata{2};
y = grdata{2};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,0.037,sprintf('c=%0.4f',r(1,2)))
text(1.7,0.035,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,0.033,sprintf('p=%5.2e',p(1,2)))
ylim([0.005 0.055])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Max Growth')
title('Timepoint 30')

subplot(2,3,3)
x = celldata{3};
y = grdata{3};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,0.035,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,0.037,sprintf('c=%0.4f',r(1,2)))
text(1.7,0.033,sprintf('p=%5.2e',p(1,2)))
ylim([0.005 0.055])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Max Growth')
title('Timepoint 60')

subplot(2,3,4)
x = celldata{4};
y = grdata{4};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,0.035,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,0.037,sprintf('c=%0.4f',r(1,2)))
text(1.7,0.033,sprintf('p=%5.2e',p(1,2)))
ylim([0.005 0.055])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Max Growth')
title('Timepoint 90')

subplot(2,3,5)
x = celldata{5};
y = grdata{5};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,0.035,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,0.037,sprintf('c=%0.4f',r(1,2)))
text(1.7,0.033,sprintf('p=%5.2e',p(1,2)))
ylim([0.005 0.055])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Max Growth')
title('Timepoint 120')

subplot(2,3,6)
x = celldata{6};
y = grdata{6};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,0.035,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,0.037,sprintf('c=%0.4f',r(1,2)))
text(1.7,0.033,sprintf('p=%5.2e',p(1,2)))
ylim([0.005 0.055])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Max Growth')
title('Timepoint 150')

if savefiles
    savefig([savename,'-maxgrVScellwidth.fig'])
    export_fig([savename,'-maxgrVScellwidth.pdf'])
end

% width vs finalod
figure('Color',[1 1 1],'Position',[0 0 700 400])
celldata = cell(1,6);
celldata{1} = NaN(1,wellformat);
celldata{2} = NaN(1,wellformat);
celldata{3} = NaN(1,wellformat);
celldata{4} = NaN(1,wellformat);
celldata{5} = NaN(1,wellformat);
celldata{6} = NaN(1,wellformat);

foddata = cell(1,6);
foddata{1} = NaN(1,wellformat);
foddata{2} = NaN(1,wellformat);
foddata{3} = NaN(1,wellformat);
foddata{4} = NaN(1,wellformat);
foddata{5} = NaN(1,wellformat);
foddata{6} = NaN(1,wellformat);

for i = 1:wellformat
    well = eval(sprintf('data.%s',wells{i}));
    idx = find(strcmp(well(:,2),'MG1655'));
    for j = idx'
        if well{j,3} == 0
            subplot(2,3,1)
            scatter(median(well{j,5}),finalod(i),50,[0 0 1],'filled'); hold on;
            foddata{1}(1,i) = finalod(i);
            celldata{1}(1,i) = median(well{j,5});
        elseif well{j,3} == 30
            subplot(2,3,2)
            scatter(median(well{j,5}),finalod(i),50,[0 0 1],'filled'); hold on;
            foddata{2}(1,i) = finalod(i);
            celldata{2}(1,i) = median(well{j,5});
        elseif well{j,3} == 60
            subplot(2,3,3)
            scatter(median(well{j,5}),finalod(i),50,[0 0 1],'filled'); hold on;
            foddata{3}(1,i) = finalod(i);
            celldata{3}(1,i) = median(well{j,5});
        elseif well{j,3} == 90
            subplot(2,3,4)
            scatter(median(well{j,5}),finalod(i),50,[0 0 1],'filled'); hold on;
            foddata{4}(1,i) = finalod(i);
            celldata{4}(1,i) = median(well{j,5});
        elseif well{j,3} == 120
            subplot(2,3,5)
            scatter(median(well{j,5}),finalod(i),50,[0 0 1],'filled'); hold on;
            foddata{5}(1,i) = finalod(i);
            celldata{5}(1,i) = median(well{j,5});
        elseif well{j,3} == 150
            subplot(2,3,6)
            scatter(median(well{j,5}),finalod(i),50,[0 0 1],'filled'); hold on;
            foddata{6}(1,i) = finalod(i);
            celldata{6}(1,i) = median(well{j,5});
        end
        
    end
end

% finalod
subplot(2,3,1)
x = celldata{1};
y = foddata{1};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,1.28,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,1.25,sprintf('c=%0.4f',r(1,2)))
text(1.7,1.23,sprintf('p=%5.2e',p(1,2)))
ylim([0 1.3])
xlim([0.5 2.5])

xlabel('Width (um)')
ylabel('Final OD')
title('Timepoint 0')

subplot(2,3,2)
x = celldata{2};
y = foddata{2};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,1.28,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,1.25,sprintf('c=%0.4f',r(1,2)))
text(1.7,1.23,sprintf('p=%5.2e',p(1,2)))
ylim([0 1.3])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Final OD')
title('Timepoint 30')

subplot(2,3,3)
x = celldata{3};
y = foddata{3};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,1.28,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,1.25,sprintf('c=%0.4f',r(1,2)))
text(1.7,1.23,sprintf('p=%5.2e',p(1,2)))
ylim([0 1.3])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Final OD')
title('Timepoint 60')

subplot(2,3,4)
x = celldata{4};
y = foddata{4};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,1.28,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,1.25,sprintf('c=%0.4f',r(1,2)))
text(1.7,1.23,sprintf('p=%5.2e',p(1,2)))
ylim([0 1.3])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Final OD')
title('Timepoint 90')

subplot(2,3,5)
x = celldata{5};
y = foddata{5};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,1.28,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,1.25,sprintf('c=%0.4f',r(1,2)))
text(1.7,1.23,sprintf('p=%5.2e',p(1,2)))
ylim([0 1.3])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Final OD')
title('Timepoint 120')

subplot(2,3,6)
x = celldata{6};
y = foddata{6};
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
text(1.7,1.28,sprintf('R2=%0.4f',model.AdjustedR2))
[r,p] = corrcoef(x1,y1);
text(1.7,1.25,sprintf('c=%0.4f',r(1,2)))
text(1.7,1.23,sprintf('p=%5.2e',p(1,2)))
ylim([0 1.3])
xlim([0.5 2.5])
xlabel('Width (um)')
ylabel('Final OD')
title('Timepoint 150')

if savefiles
    savefig([savename,'-finalodVScellwidth.fig'])
    export_fig([savename,'-finalodVScellwidth.pdf'])
end

if ph
    figure('Color',[1 1 1],'Position',[0 0 700 400])
    [blank1,~,~] = xlsread('021617 pH7 rep1 1000 dilution.xlsx','Q195:Q335'); % label 2 (F1)
    [blank2,~,~] = xlsread('021617 pH7 rep1 1000 dilution.xlsx','Q344:Q484'); % label 3 (F2)
    
    t1 = (1:size(num2,1))*10.433333333;% time in minute
    for i = 1:wellformat
        F1 = num2(:,i)-repmat(blank1(1), size(num2,1),1);
        F2 = num3(:,i)-repmat(blank2(1), size(num2,1),1);
        F3 = F1./F2;
        pH = pH_calibration_H1(F3(~isnan(F3)));
        t = t1(~isnan(F3))/60;
        subplot(1,2,1)
        xlim([0 10])
        plot(t,pH); hold on;
        ylabel('pH');
        xlabel('Time (hrs)');
        title('pH 5.1');
        subplot(1,2,2)
        if ~isempty(t)
            rate = diff(pH)/(t(2)-t(1));
            plot(t(2:end),rate); hold on;
            xlim([0 10])
            ylabel('pH');
            xlabel('Time (hrs)');
            title('pH 5.1');
        end
        
    end
    if savefiles
        savefig([savename,'-pHreadings.fig'])
        export_fig([savename,'-pHreadings.pdf'])
    end
end



