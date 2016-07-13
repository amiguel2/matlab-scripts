function plotdata = get_data_plot(cs,plotsave,varargin)
% get_data_plot(cs,plotsave,[lineage_on],[save_plot],[tF],[tS],
% Default Values:
% lineage_on = 1;
% save_plot = 1;
% tF = max(cs{end}.time);
% tS = 1;


suppress_plot = 0;

%% length plots
if numel(varargin) == 0
lineage_on = 1;
save_plot = 1;
tF = max(cs{end}.time);
tS = 1;
elseif numel(varargin) == 1
lineage_on = varargin{1};
save_plot = 1;
tF = max(cs{end}.time);
tS = 1;
elseif numel(varargin) == 2
lineage_on = varargin{1};
save_plot = varargin{2};
tF = max(cs{end}.time);
tS = 1;
elseif numel(varargin) == 3
lineage_on = varargin{1};
save_plot = varargin{2};
tF = varargin{3};
tS = 1;    
elseif numel(varargin) == 5
lineage_on = varargin{1};
save_plot = varargin{2};
tF = varargin{3};
tS = varargin{4};      
else
    fprintf('Too many arguments')
    return
end


close all;
plotdata.all_length = [];
plotdata.all_time = [];
plotdata.all_width = [];
plotdata.all_lambda = [];
plotdata.all_lambda_area = [];
plotdata.all_avg_lambda = [];
plotdata.all_lamtime = [];
plotdata.all_lambda_fit = [];
plotdata.all_dt = [];
plotdata.all_finalt = [];
plotdata.all_startt = [];
plotdata.all_deltal = [];
plotdata.all_dAdt_A = [];
plotdata.all_lineage = [];
plotdata.cid = [];
plotdata.cf = [];
for i = 1:numel(cs)
    %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
    if lineage_on
        if cs{i}.lineage == 1
            plot(cs{i}.time,cs{i}.length,'Color',[1 0 0])
            plotdata.all_lineage = [plotdata.all_lineage 1];
            plotdata.all_length = [plotdata.all_length cs{i}.length];
            plotdata.all_time = [plotdata.all_time cs{i}.time];
            plotdata.all_width = [plotdata.all_width cs{i}.width];
            plotdata.all_lambda = [plotdata.all_lambda cs{i}.instant_lambda];
            plotdata.all_lambda_area = [plotdata.all_lambda_area cs{i}.instant_lambda./cs{i}.area(1:end-1)];
            plotdata.all_dAdt_A = [plotdata.all_dAdt_A (diff(cs{i}.area)./diff(cs{i}.time))./cs{i}.area(1:end-1)];
            try
                plotdata.all_lambda_fit = [plotdata.all_lambda_fit cs{i}.lambda.beta(2)];
            catch
                plotdata.all_lambda_fit = [plotdata.all_lambda_fit NaN];
            end
            plotdata.all_avg_lambda = [plotdata.all_avg_lambda mean(cs{i}.instant_lambda)];
            plotdata.all_lamtime = [plotdata.all_lamtime cs{i}.time(1:end-1)];
            plotdata.all_dt = [plotdata.all_dt cs{i}.divtime];
            plotdata.cid = [plotdata.cid cs{i}.cid];
            plotdata.cf = [plotdata.cf cs{i}.contourfile];
            plotdata.all_finalt = [plotdata.all_finalt cs{i}.finalt];
            plotdata.all_startt = [plotdata.all_startt cs{i}.startt];
            plotdata.all_deltal = [plotdata.all_deltal cs{i}.deltalength];
        else
            plot(cs{i}.time,cs{i}.length,'Color',[0.5 0.5 0.5])
            plotdata.all_lineage = [plotdata.all_lineage 0];
            plotdata.all_length = [plotdata.all_length cs{i}.length];
            plotdata.all_time = [plotdata.all_time cs{i}.time];
            plotdata.all_width = [plotdata.all_width cs{i}.width];
            plotdata.all_lambda = [plotdata.all_lambda cs{i}.instant_lambda];
            plotdata.all_lambda_area = [plotdata.all_lambda_area cs{i}.instant_lambda./cs{i}.area(1:end-1)];
            try
                plotdata.all_lambda_fit = [plotdata.all_lambda_fit cs{i}.lambda.beta(2)];
            catch
                plotdata.all_lambda_fit = [plotdata.all_lambda_fit NaN];
            end
            plotdata.all_avg_lambda = [plotdata.all_avg_lambda mean(cs{i}.instant_lambda)];
            plotdata.all_lamtime = [plotdata.all_lamtime cs{i}.time(1:end-1)];
            plotdata.all_dt = [plotdata.all_dt cs{i}.divtime];
            plotdata.cid = [plotdata.cid cs{i}.cid];
            plotdata.cf = [plotdata.cf {cs{i}.contourfile}];
            plotdata.all_finalt = [plotdata.all_finalt cs{i}.finalt];
            plotdata.all_startt = [plotdata.all_startt cs{i}.startt];
            plotdata.all_deltal = [plotdata.all_deltal cs{i}.deltalength];
        end
        hold on;
    end
    hold on;
    
end

if suppress_plot
    return
end

for i = min(plotdata.all_time):max(plotdata.all_time)
    idx = find(i == plotdata.all_time);
    scatter(i,median(plotdata.all_length(idx)),10,'black','filled')
    hold on;
end

ylabel('Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([0 8])
xlim([0 tF])
if save_plot
    export_fig([plotsave 'length.pdf'])
    savefig([plotsave 'length.fig'])
end

% width plots
figure;

for i = 1:numel(cs)
    if cs{i}.time(end) < tF
        if lineage_on
            if cs{i}.lineage == 1
                plot(cs{i}.time,cs{i}.width,'Color',[1 0 0])
            else
                plot(cs{i}.time,cs{i}.width,'Color',[0.5 0.5 0.5])
            end
        end
    else
        plot(cs{i}.time,cs{i}.width,'Color',cs{i}.color)
    end
    hold on;
end


for i = 1:max(plotdata.all_time)
    idx = find(i == plotdata.all_time);
    scatter(i,median(plotdata.all_width(idx)),10,'black','filled')
    hold on;
end

ylabel('Width (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([0.5 1.2])
xlim([0 tF])
if save_plot
    export_fig([plotsave 'width.pdf'])
    savefig([plotsave 'width.fig'])
end

% growthrate plots
% plotdata.all_lambda = [];
% plotdata.all_avg_lambda = [];
% plotdata.all_lamtime = [];
figure('Color',[1 1 1],'Position', [100, 100, 800, 400]);
subplot(1,2,1)
for i = 1:numel(cs)
    %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
    if lineage_on
        if cs{i}.lineage
            plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',[1 0 0])
        else
            plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',[0.5 0.5 0.5])
        end
    else
        plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',cs{i}.color)
    end
    hold on;
    %end
    %     plotdata.all_lambda = [plotdata.all_lambda cs{i}.lambda];
    %     plotdata.all_avg_lambda = [plotdata.all_avg_lambda mean(cs{i}.lambda)];
    %     plotdata.all_lamtime = [plotdata.all_lamtime cs{i}.time(1:end-1)];
end

median_growthrate = [];
for i = 1:max(plotdata.all_lamtime)
    idx = find(i == plotdata.all_lamtime);
    median_growthrate = [median_growthrate; [i,median(plotdata.all_lambda(idx))]];
    scatter(i,median(plotdata.all_lambda(idx)),10,'black','filled')
    
    hold on;
end
idx = ~isnan(median_growthrate(:,2));
plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2)

ylabel('Instantaneous Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
%ylim([-0.01 0.06])
%ylim([0.02 0.04])
ylim([-0.01 0.05])
% if save_plot
%     export_fig([plotsave 'growthrate.pdf'])
%     savefig([plotsave 'growthrate.fig'])
% end
% %%
subplot(1,2,2)
% fitted growthrate
for i = 1:numel(cs)
    %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
    if lineage_on
        if cs{i}.lineage
            if ~isempty(cs{i}.lambda.beta)
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,[1 0 0],'filled')
            end
        else
            if ~isempty(cs{i}.lambda.beta)
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,[0.5 0.5 0.5],'filled')
            end
        end
        hold on;
    end
    %     plotdata.all_lambda = [plotdata.all_lambda cs{i}.lambda];
    %     plotdata.all_avg_lambda = [plotdata.all_avg_lambda mean(cs{i}.lambda)];
    %     plotdata.all_lamtime = [plotdata.all_lamtime cs{i}.time(1:end-1)];
end

median_growthrate = [];
for i = 1:max(plotdata.all_startt)
    idx = find(i == plotdata.all_startt);
    median_growthrate = [median_growthrate; [i,nanmedian(plotdata.all_lambda_fit(idx))]];
    scatter(i,nanmedian(plotdata.all_lambda_fit(idx)),10,'black','filled')
    
    hold on;
end
idx = ~isnan(median_growthrate(:,2));
plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2)

ylabel('Fitted Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
%ylim([-0.01 0.06])
%ylim([0.02 0.04])
ylim([-0.01 0.05])


if save_plot
    export_fig([plotsave 'growthrate.pdf'])
    savefig([plotsave 'growthrate.fig'])
end

%%
figure;
for i = 1:numel(cs)
    %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
        if lineage_on
            if cs{i}.lineage
                scatter(cs{i}.startt,cs{i}.divtime,50,[1 0 0],'filled')
            else
                scatter(cs{i}.startt,cs{i}.divtime,50,[0.5 0.5 0.5],'filled')
            end
        else
            scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color','filled')
        end
        hold on;
    %end
    %     plotdata.all_dt = [plotdata.all_dt cs{i}.divtime];
    %     plotdata.all_finalt = [plotdata.all_finalt cs{i}.finalt];
    %     plotdata.all_startt = [plotdata.all_startt cs{i}.startt];
end

for i = unique(plotdata.all_startt)
    idx = find(i == plotdata.all_startt);
    scatter(i,median(plotdata.all_dt(idx)),70,'black','filled')
    hold on;
end


%make_kymograph(plotdata.all_startt,plotdata.all_dt,4,11,11,0,120,50);

xlabel('Start Time (min)')
ylabel('Division Time t(f)-t(i) (min)')
set(gcf,'color','white')
%ylim([0 25])
if save_plot
    export_fig([plotsave 'divisiontime.pdf'])
    savefig([plotsave 'divisiontime.fig'])
end
% deltalength
figure;
% plotdata.all_deltal = [];
% plotdata.all_finalt = [];
% plotdata.all_startt = [];

for i = 1:numel(cs)
    %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
        if lineage_on
            if cs{i}.lineage
                scatter(cs{i}.startt,cs{i}.deltalength,50,[1 0 0],'filled')
                hold on;
            else
                scatter(cs{i}.startt,cs{i}.deltalength,50,[0.5 0.5 0.5],'filled')
                hold on;
            end
            %     plotdata.all_deltal = [plotdata.all_deltal cs{i}.deltalength];
            %     plotdata.all_startt = [plotdata.all_startt cs{i}.startt];
            %     plotdata.all_finalt = [plotdata.all_finalt cs{i}.finalt];
        end
    %end
end

for i = unique(plotdata.all_startt)
    idx = find(i == plotdata.all_startt);
    scatter(i,median(plotdata.all_deltal(idx)),70,'black','filled')
    hold on;
end
ylabel('Delta Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([-2 6])
xlim([0 tF])
if save_plot
    export_fig([plotsave 'deltalength.pdf'])
end
%% dl/sl

figure;
% plotdata.all_deltal = [];
% plotdata.all_finalt = [];
% plotdata.all_startt = [];
dlsl = [];
for i = 1:numel(cs)
    %if cs{i}.time(end) < tF
        if lineage_on
            if cs{i}.lineage
                scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color','filled')
            end
        else
            scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color','filled')
        end
        hold on;
        dlsl = [dlsl cs{i}.deltalength/cs{i}.length(1)];
    %end
    %     plotdata.all_deltal = [plotdata.all_deltal cs{i}.deltalength];
    %     plotdata.all_startt = [plotdata.all_startt cs{i}.startt];
    %     plotdata.all_finalt = [plotdata.all_finalt cs{i}.finalt];
end

for i = unique(plotdata.all_startt)
    idx = find(i == plotdata.all_startt);
    scatter(i,median(dlsl(idx)),70,'black','filled')
    hold on;
end
ylabel('Delta Length/Start Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([-2 6])
if save_plot
    export_fig([plotsave 'deltalengthoverstartlength.pdf'])
    savefig([plotsave 'deltalength.fig'])
end
%
%     for j = 1:numel(startt)
%         scatter(plotdata.all_dt(j),log(2)./plotdata.all_avg_lambda(j),50,c,'filled')
%         hold on;
%         %text(plotdata.all_dt(j),log(2)./plotdata.all_lambda(j),int2str(plotdata.all_cid(j)))
%     end
%     Xlim = xlim;
%     Ylim = ylim;
%     m = max(max(Xlim),max(Ylim));
%     plot([0 m],[0,m])
%     xlim(Xlim)
%     ylim(Ylim)
%     xlabel('Division Time (min)')
%     ylabel('Estimated Division Time from lambda')
%     set(gcf,'color','white')
%     export_fig([plotsave 'grvsdt.pdf'])

% %% average growthrate
% figure;
% hist_transparent(plotdata.all_avg_lambda,100,[0 1 0])
% hold on;
% plot(ones(1,2)*nanmedian(plotdata.all_avg_lambda),[0 0.25],':','Color',[0 1 0])
% xlabel('Average Growthrate')
% xlim([-0.01 0.06])
% if save_plot
%     export_fig([plotsave 'hist-avggrowthrate.pdf'])
%     savefig([plotsave 'hist-avggrowthrate.fig'])
% end
% close
% 
% %% growthrate vs division time
% figure;
% make_kymograph(plotdata.all_dt,plotdata.all_avg_lambda,4,10,20);
% title('Growthrate vs Divistion Time')
% xlabel('Division Time')
% ylabel('Growthrate')
% 
% %% division time
% close all
% make_kymograph(plotdata.all_startt,plotdata.all_dt,4,11,11,0,140,80);
% title('Divistion Time vs startT')
% xlabel('Start Time')
% ylabel('Division Time')
% set(gcf,'color','white')
% if save_plot
%     export_fig([plotsave 'div-kymo.pdf'])
% end
end