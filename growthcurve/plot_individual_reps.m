function plot_individual_reps(data,savename)

shapedata = get_shapegrowthcurve_data({'MG1655'},120);
mgwidths = shapedata.widths;
muts = shapedata.mut;

%% growthrate
figure('Position',[680 706 360 272])
for i = 1:size(data.all_gr)
    param1 = data.all_gr(i,:);
    plotfxn(param1,mgwidths)
    ylim([0 0.06])
    text(1.8,0.03,sprintf('corr= %.2f',r(2)))
    text(1.8,0.027,sprintf('pval= %2.2e',p(2)))
    prettifyplot
    xlabel('Cell width (µm)')
    ylabel('µ_max')
    saveplots(sprintf('%s-gr-rep%d',savename,num))
end

% lag
figure('Position',[680 706 360 272])
for i = 1:size(data.all_lag)
    param1 = data.all_lag(i,:);
    plotfxn(param1,mgwidths)
    text(1.8,60,sprintf('corr= %.2f',r(2)))
    text(1.8,40,sprintf('pval= %2.2e',p(2)))
    prettifyplot
    xlabel('Cell width (µm)')
    ylabel('Lag')
    saveplots(sprintf('%s-lag-rep%d',savename,num))
end

% finalod
figure('Position',[680 706 360 272])
for i = 1:size(data.all_finalod)
    param1 = data.all_finalod(i,:);
    plotfxn(param1,mgwidths)
    % ylim([0 300])
    text(1.8,0.8,sprintf('corr= %.2f',r(2)))
    text(1.8,0.7,sprintf('pval= %2.2e',p(2)))
    prettifyplot
    xlabel('Cell width (µm)')
    ylabel('Final OD (A.U)')
    saveplots(sprintf('%s-finalod-rep%d',savename,num))
end

% auc
figure('Position',[680 706 360 272])
for i = 1:size(data.all_auc)
    param1 = data.all_auc(i,:);
    plotfxn(param1,mgwidths)
    text(1.8,400,sprintf('corr= %.2f',r(2)))
    text(1.8,300,sprintf('pval= %2.2e',p(2)))
    prettifyplot
    xlabel('Cell width (µm)')
    ylabel('Area under the Curve')
    saveplots(sprintf('%s-auc-rep%d',savename,num))
end

end

function plotfxn(param1,cellwidths)
idx = find(param1(1,:) > 0.01 & param1(1,:) < 0.06);%1:96%find(startingod >= 0);
param2 = param1(:,idx);
if size(param2,1) > 1
    scatter(cellwidths(idx),mean(param2),50,[0 0 1],'filled'); hold on;
    errorbar(cellwidths(idx),mean(param2),std(param2)./sqrt(2),'.')
else
    scatter(cellwidths(idx)',param2,50,[0 0 1],'filled'); hold on;
end
% scatter(metate_cellwidth(idx),maxgr(idx),100,[0 0 0]);
x = cellwidths(idx);
if size(param2,1) > 1
    y = mean(param2)';
else
    y = param2';
end
x1 = x(~isnan(y)&~isnan(x));
y1 = y(~isnan(y)&~isnan(x));
model = polyfitn(x1',y1','constant, x');
plot(linspace(0.5,2.5,100),polyval(flip(model.Coefficients),linspace(0.5,2.5,100)))
[r,p] = corrcoef(x1,y1);
text(1.8,0.03,sprintf('corr= %.2f',r(2)))
text(1.8,0.027,sprintf('pval= %2.2e',p(2)))
prettifyplot
end