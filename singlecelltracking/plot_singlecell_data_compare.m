function plot_singlecell_data_compare(exp,paramx,paramy,varargin)
ylimval = [0 8];
legnam = cell(1, 5); legnam(:) = {'mut'};
normalizey = 0;
normalizex = 0;
plot_histogram = 1;
c = cbrewer('qual','Set1',numel(exp)); 
lineage = 0;
slidingmean =1;
color_subset = 0;
Numsubset = 500;

% varargin{1} = ylim;
% varargin{2} = legend;
% varargin{3} = normalizey;
% varargin{4} = normalizex;
% varargin{5} = histogram
% varargin{6} = slidingmean
% varargin{7} = color
% varargin{8} = lineage
if numel(varargin) >= 1
    ylimval = varargin{1};
end
if numel(varargin) >=2
    legnam = varargin{2};
end
if numel(varargin) >= 3
    normalizey = varargin{3};
end
if numel(varargin) >= 3
    normalizex = varargin{4};
end
if numel(varargin) >= 5
    plot_histogram = varargin{5};
end

if numel(varargin) >= 6
    slidingmean = varargin{6};
end
if numel(varargin) >= 7
    c = varargin{7};
end

if numel(varargin) >= 8
    lineage = varargin{8};
end



if numel(exp) >10
    subplotN = 4;
    subplotM = 5;
    figure('Position',[100 100 250*subplotM 250*subplotN]);
elseif numel(exp) >7
    subplotN = 3;
    subplotM = 5;
    figure('Position',[100 100 250*subplotM 250*subplotN]);
elseif numel(exp) > 4
    subplotN = 2;
    subplotM = 5;
    figure('Position',[100 100 250*subplotM 250*subplotN]);
else
    subplotN = 1;
    subplotM = numel(exp)+1;
    figure('Position',[100 100 250*subplotM 250]);
end



for a = 1:numel(exp)
    ax = subplot(subplotN,subplotM,a);
    cs = exp{a};
    
    if lineage
        idx = find(cellfun(@(x) extractfield(x,'lineage'),cs));
        cs = cs(idx);
    end
    
    % get data
    
    paramy_data = get_paramdata(cs,paramy,0);
    
    
    if contains(paramy,'lambda')
        paramx_data = get_paramdata(cs,paramx,1);
         %% assumes paramy is time here.
        plot_histogram = 1;
        % bin data
                 bin_paramdata(paramx_data,paramy_data,get_seq_color(c(a,:),72),ax);
    else
        paramx_data = get_paramdata(cs,paramx,0);
        %         plot_traces(cs,paramx,c(a,:))
    end
    
    % normalize
    if normalizey
        if a == 1
            controly = paramy_data;
            controlt = get_paramdata(cs,'time',0);
        end
        [paramy_data] = get_median_param_norm(paramy_data,get_paramdata(cs,'time',0),0,controly,controlt);
        
    end
    if normalizex
        if a == 1
            controlx = paramx_data;
        end
        [paramx_data] = get_median_param_norm(paramx_data,get_paramdata(cs,'time',0),0,controlx,controlt);
    end
    
    % plot
    if plot_histogram
        bin_paramdata(paramy_data,paramx_data,get_seq_color(c(a,:),72),ax);
    else
        if normalizey && ~normalizex
            
            if color_subset
                plot_traces_normy(cs,paramy,paramx,[0.5 0.5 0.5],0,controly,controlt)
                plot_traces_normy(datasample(cs,Numsubset),paramy,paramx,c(a,:),0,controly,controlt)
            else
                plot_traces_normy(cs,paramy,paramx,c(a,:),0,controly,controlt)
            end
        elseif normalizex
            if color_subset
                plot_traces_norm(cs,paramy,paramx,[0.5 0.5 0.5],0,controly,controlx,controlt)
                plot_traces_norm(datasample(cs,Numsubset),paramy,paramx,c(a,:),0,controly,controlx,controlt)
            else
                plot_traces_norm(cs,paramy,paramx,c(a,:),0,controly,controlx,controlt)
            end
        else
            if color_subset
                plot_traces(cs,paramy,paramx,[0.5 0.5 0.5])
                plot_traces(datasample(cs,Numsubset),paramy,paramx,c(a,:))
            else
                plot_traces(cs,paramy,paramx,c(a,:)); hold on;
            end
        end
    end
    
    % plot median
    if contains(paramx,'time') || slidingmean
            plot_slidingmedian(paramx_data,paramy_data,paramx_data,[0 0 0],0)
    else
        plot_scattermedian(paramy_data,paramx_data,[0 0 0])
    end
    
    % labels
    xlim([0 max(paramx_data)])
    xlabel(strrep(paramx,'_','.'))
    if normalizey
        ylabel(['norm.' strrep(paramy,'_','.')])
    else
        ylabel(strrep(paramy,'_','.'))
    end
    try
        ylim(ylimval)
        title(legnam{a})
    catch
    end
    set(gcf,'color','white')
    
    subplot(subplotN,subplotM,numel(exp)+1)
    if contains(paramx,'time')  || slidingmean
        if normalizex == 1 & normalizey == 1
            if a ~=1
                plot_scattererrormedian(get_paramdata(cs,'time',0),paramy_data,paramx_data,c(a,:),1); hold on;
            end
        else
            plot_scattererrormedian(paramx_data,paramy_data,paramx_data,c(a,:),1); hold on;    
        end
    % plot_slidingmedian(get_paramdata(cs,'time',0),paramy_data,paramx_data,c(a,:),1); hold on;
    else
        if normalizex == 1 & normalizey == 1
            if a ~=1
                plot_scattermedian(paramy_data,paramx_data,c(a,:))
            end
        else
            plot_scattermedian(paramy_data,paramx_data,c(a,:))
        end
    end
end

% for i = 1:numel(exp)+1
%     ax = subplot(subplotN,subplotM,i)
%     ax.Position(1) = ax.Position(1)-0.07;
% end

% labels for median
xlim([0 max(paramx_data)])
title('Median Comparison')

if normalizey
    ylabel(['norm.' strrep(paramy,'_','.')])
    xlabel(['norm.' strrep(paramx,'_','.')])
else
    ylabel(strrep(paramy,'_','.'))
    xlabel(strrep(paramx,'_','.'))
end
try
    ylim(ylimval)
    h = legend(legnam,'Location','west');
    pos = get(h,'Position');
    h.Position = [pos(1)+0.15, pos(2) pos(3) pos(4)];
catch
end
set(gcf,'color','white')


end

function paramdata = get_paramdata(cs,param,diff)
paramdata = [];
for i = 1:numel(cs)
    if strcmp(param,'deltavol')
        temp = get_deltavol(cs{i}.volume);
    else
        temp = cs{i}.(param);
    end
    
    if diff
        paramdata = [paramdata temp(1:end-1)];
    else
        paramdata = [paramdata temp];
    end
end

end

function bin_paramdata(param,time,histc,ax)
[n,binctrs] = hist3([time;param]',[100 200]);
edges1 = [binctrs{1}-(binctrs{1}(2)-binctrs{1}(1))/2 binctrs{1}(end)+(binctrs{1}(2)-binctrs{1}(1))/2];
edges2 = [binctrs{2}-(binctrs{2}(2)-binctrs{2}(1))/2 binctrs{2}(end)+(binctrs{2}(2)-binctrs{2}(1))/2];
x = discretize(time,edges1);
y = discretize(param,edges2);

y(isnan(y)) = 1;
x(isnan(x)) = 1;
scatter_size = zeros(numel(time),1)';
scatter_col = zeros(numel(time),1)';

for i = 1:numel(time)
    scatter_size(i) = 30;
    scatter_col(i) = n(x(i),y(i)); hold on;
end
scatter(time,param,scatter_size,scatter_col,'filled')
colormap(ax,histc)
end

function plot_scattermedian(paramy,paramx,c)
% [n,binctrs] = hist3([time;param]',[100 200]);
% hitx = median(n,2);
% tempx = binctrs{1};
% hity = median(n,1);
% tempy = binctrs{2};
% scatter(tempx(find(max(hitx) == hitx,1)),tempy(find(max(hity) == hity,1)),100,c,'filled'); hold on;
% errorbar(tempx(find(max(hitx) == hitx,1)),tempy(find(max(hity) == hity,1)),std(tempy,hity),'Color',c)
% h = herrorbar(tempx(find(max(hitx) == hitx,1)),tempy(find(max(hity) == hity,1)),std(tempx,hitx));
scatter(median(paramx),median(paramy),100,c,'filled'); hold on;
h = errorbar(median(paramx),median(paramy),std(paramy),'Color',c)
set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
h = herrorbar(median(paramx),median(paramy),std(paramx));
h(1).Color = c;
h(2).Color = c;
set(get(get(h(1), 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
set(get(get(h(2), 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
end

function plot_scattererrormedian(time,paramy,paramx,c,plot_error)
median_param = [];
err_param = [];
T = min(time):max(time);
for i = min(time):max(time)
    idx = find(i == time);
    median_param = [median_param; [nanmedian(paramx(idx)),nanmedian(paramy(idx))]];
    err_param = [err_param; [nanstd(paramx(idx)),nanstd(paramy(idx))]];
%     err_param = [err_param; [nanstd(paramx(idx))/sqrt(numel(idx)),nanstd(paramy(idx))/sqrt(numel(idx))]];
end

idx1 = ~isnan(median_param(:,2));
if plot_error
        scatter(median_param(idx1,1),median_param(idx1,2),50,c,'filled'); hold on;
%     scatter(median_param(idx1,1),median_param(idx1,2),(T(idx1)*10)+50,c,'filled'); hold on;
    p = errorbar(median_param(idx1,1),median_param(idx1,2),err_param(idx1,2),'Color',c,'LineStyle','none')
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    p = herrorbar(median_param(idx1,1),median_param(idx1,2),err_param(idx1,1))
    p(1).Color = c;
    p(2).Color = c;
    set(get(get(p(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    set(get(get(p(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end
p = plot(median_param(idx1,1),median_param(idx1,2),'Color',c,'LineWidth',2,'LineStyle','--');
set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end

function plot_slidingmedian(time,paramy,paramx,c,plot_error)
median_param = [];
err_param = [];
for i = min(time):max(time)
    idx = find(i == time);
    median_param = [median_param; [nanmedian(paramx(idx)),nanmedian(paramy(idx))]];
    err_param = [err_param; [nanstd(paramx(idx)),nanstd(paramy(idx))]];
%     err_param = [err_param; [nanstd(paramx(idx))/sqrt(numel(idx)),nanstd(paramy(idx))/sqrt(numel(idx))]];
end

idx1 = ~isnan(median_param(:,2));
if plot_error
    xlen = median_param(idx1,1);
    yupperbound = smooth(median_param(idx1,2))+(err_param(idx1,2));
    ylowerbound = smooth(median_param(idx1,2))-(err_param(idx1,2));
    xupperbound = smooth(median_param(idx1,1))+(err_param(idx1,1));
    xlowerbound = smooth(median_param(idx1,1))-(err_param(idx1,1));
    patchc = c + 0.3;
    patchc(patchc > 1) = 1;
    p = patch([xlowerbound; flip(xupperbound)],[ylowerbound;flip(yupperbound)],patchc,'FaceAlpha',0.2,'EdgeColor','none'); hold on;
%     p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],patchc,'FaceAlpha',0.2,'EdgeColor','none'); hold on;
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end
p = plot(median_param(idx1,1),smooth(median_param(idx1,2)),'Color',c,'LineWidth',2);

end

function plot_traces(cs,paramy,paramx,c)
for i = 1:numel(cs)
    plot(cs{i}.(paramx),cs{i}.(paramy),'Color',c,'UserData',i); hold on;
end
end

function plot_traces_normy(cs,paramy,paramx,c,startt,norm_param,norm_t)

med_param_norm = [];
% control
for i = startt:max(norm_t)
    idx = find(i == norm_t);
    med_param_norm = [med_param_norm;[i,nanmedian(double(norm_param(idx)))]];
end

for i = 1:numel(cs)
    t = cs{i}.time;
    x = cs{i}.(paramx);
    temp_param = cs{i}.(paramy);
    norm_param = zeros(1,numel(cs{i}.time));
    for j = 1:numel(t)
        norm_param(j) = temp_param(j)/med_param_norm(med_param_norm(:,1) == t(j),2);
    end
    plot(x,norm_param,'Color',c,'UserData',i); hold on;
end
end

function plot_traces_norm(cs,paramy,paramx,c,startt,norm_paramy,norm_paramx,norm_t)

med_param_norm = [];
% control
for i = startt:max(norm_t)
    idx = find(i == norm_t);
    med_param_norm = [med_param_norm;[i,nanmedian(double(norm_paramy(idx))),nanmedian(double(norm_paramx(idx)))]];
end

for i = 1:numel(cs)
    t = cs{i}.time;
    temp_paramx = cs{i}.(paramx);
    temp_paramy = cs{i}.(paramy);
    newnorm_paramy = zeros(1,numel(cs{i}.time));
    newnorm_paramx = zeros(1,numel(cs{i}.time));
    for j = 1:numel(t)
        newnorm_paramy(j) = temp_paramy(j)/med_param_norm(med_param_norm(:,1) == t(j),2);
        newnorm_paramx(j) = temp_paramx(j)/med_param_norm(med_param_norm(:,1) == t(j),3);
        
    end
    plot(newnorm_paramx,newnorm_paramy,'Color',c,'UserData',i); hold on;
end
end

function [all_param] = get_median_param_norm(all_param,all_t,startt,norm_param,norm_t)
med_param = [];
err_param = [];
med_param_norm = [];
err_param_norm = [];
% control
for i = startt:max(norm_t)
    idx = find(i == norm_t);
    med_param_norm = [med_param_norm;[i,nanmedian(double(norm_param(idx)))]];
    err_param_norm = [err_param_norm; [i,nanstd(double(norm_param(idx)))/sqrt(numel(idx))]];
end
% param

for i = unique(all_t)
    idx = find(all_t == i);
    idx1 = find(i == med_param_norm(:,1));
    if idx1
        all_param(idx) = (all_param(idx))/med_param_norm(idx1,2);
    else
        all_param(idx) = NaN;
    end
end
end

function out = get_deltavol(vol)
out = vol(end)-vol(1);
end