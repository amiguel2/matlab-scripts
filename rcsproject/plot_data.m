function plot_data(cs,lineage_on,save_plot,plotsave,varargin)

if numel(varargin) == 1
    tS = varargin{1};
    x = cellfun(@(x) extractfield(x,'time'),cs,'UniformOutput',false);
    tF = max(cellfun(@max,x));
elseif numel(varargin) == 2
    tS = varargin{1};
    tF = varargin{2};
elseif numel(varargin) > 2
    fprintf('Too many arguments')
    return
else
    x = cellfun(@(x) extractfield(x,'time'),cs,'UniformOutput',false);
    tS = min(cellfun(@min,x));
    tF = max(cellfun(@max,x));
end

% variable set up
close all;
all_length = [];
all_time = [];
all_width = [];
all_lambda = [];
all_avg_lambda = [];
all_lamtime = [];
all_lambda_fit = [];
all_dt = [];
all_finalt = [];
all_startt = [];
all_deltal = [];

%checked = plot_data_gui

%% length plots
for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage == 1
            plot(cs{i}.time,cs{i}.length,'Color',cs{i}.color)
            all_length = [all_length cs{i}.length];
            all_time = [all_time cs{i}.time];
            all_width = [all_width cs{i}.width];
            all_lambda = [all_lambda cs{i}.instant_lambda];
            try
                all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)];
            catch
                all_lambda_fit = [all_lambda_fit NaN];
            end
            all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda)];
            all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
            all_dt = [all_dt cs{i}.divtime];
            all_finalt = [all_finalt cs{i}.finalt];
            all_startt = [all_startt cs{i}.startt];
            all_deltal = [all_deltal cs{i}.deltalength];
        else
            plot(cs{i}.time,cs{i}.length,'Color',[0.5 0.5 0.5])
            all_length = [all_length cs{i}.length];
            all_time = [all_time cs{i}.time];
            all_width = [all_width cs{i}.width];
            all_lambda = [all_lambda cs{i}.instant_lambda];
            try
                all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)];
            catch
                all_lambda_fit = [all_lambda_fit NaN];
            end
            all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda)];
            all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
            all_dt = [all_dt cs{i}.divtime];
            all_finalt = [all_finalt cs{i}.finalt];
            all_startt = [all_startt cs{i}.startt];
            all_deltal = [all_deltal cs{i}.deltalength];
        end
        hold on;
        
    else
        
        plot(cs{i}.time,cs{i}.length,'Color',cs{i}.color)
        all_length = [all_length cs{i}.length];
        all_time = [all_time cs{i}.time];
        all_width = [all_width cs{i}.width];
        all_lambda = [all_lambda cs{i}.instant_lambda];
        try
            all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)];
        catch
            all_lambda_fit = [all_lambda_fit NaN];
        end
        all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda)];
        all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
        all_dt = [all_dt cs{i}.divtime];
        all_finalt = [all_finalt cs{i}.finalt];
        all_startt = [all_startt cs{i}.startt];
        all_deltal = [all_deltal cs{i}.deltalength];
    end
    hold on;
    
end


for i = min(all_time):max(all_time)
    idx = find(i == all_time);
    scatter(i,median(all_length(idx)),10,'black','filled')
    hold on;
end

ylabel('Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([0 10])
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
            if cs{i}.lineage == 2
                plot(cs{i}.time,cs{i}.width,'Color',cs{i}.color)
            else
                plot(cs{i}.time,cs{i}.width,'Color',[0.5 0.5 0.5])
            end
            
        else
            plot(cs{i}.time,cs{i}.width,'Color',cs{i}.color)
        end
    end
    hold on;
end


for i = 1:max(all_time)
    idx = find(i == all_time);
    scatter(i,median(all_width(idx)),10,'black','filled')
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
figure('Color',[1 1 1],'Position', [100, 100, 800, 400]);
subplot(1,2,1)
for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage
            plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',cs{i}.color)
        else
            plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',[0.5 0.5 0.5])
        end
    else
        plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',cs{i}.color)
    end
    hold on;
end

median_growthrate = [];
for i = 1:max(all_lamtime)
    idx = find(i == all_lamtime);
    median_growthrate = [median_growthrate; [i,median(all_lambda(idx))]];
    scatter(i,median(all_lambda(idx)),10,'black','filled')
    
    hold on;
end
idx = ~isnan(median_growthrate(:,2));
plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2)

ylabel('Instantaneous Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
ylim([-0.01 0.05])

subplot(1,2,2)
% fitted growthrate
for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage
            if ~isempty(cs{i}.lambda.beta)
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,cs{i}.color,'filled')
            end
        else
            if ~isempty(cs{i}.lambda.beta)
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,[0.5 0.5 0.5],'filled')
            end
        end
        hold on;
    else
        if ~isempty(cs{i}.lambda.beta)
            scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,cs{i}.color,'filled'); hold on;
        end
    end
end


median_growthrate = [];
for i = 1:max(all_startt)
    idx = find(i == all_startt);
    median_growthrate = [median_growthrate; [i,nanmedian(all_lambda_fit(idx))]];
    scatter(i,nanmedian(all_lambda_fit(idx)),10,'black','filled')
    
    hold on;
end
idx = ~isnan(median_growthrate(:,2));
plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2)

ylabel('Fitted Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
ylim([-0.01 0.05])

if save_plot
    export_fig([plotsave 'growthrate.pdf'])
    savefig([plotsave 'growthrate.fig'])
end

%% Division scatter
figure('Color',[1 1 1],'Position', [100, 100, 800, 400]);
subplot(1,2,1)
for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage
            scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color,'filled')
        else
            scatter(cs{i}.startt,cs{i}.divtime,50,[0.5 0.5 0.5],'filled')
        end
    else
        scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color','filled')
    end
    hold on;
end

for i = unique(all_startt)
    idx = find(i == all_startt);
    scatter(i,median(all_dt(idx)),70,'black','filled')
    hold on;
end
xlabel('Start Time (min)')
ylabel('Division Time t(f)-t(i) (min)')
set(gcf,'color','white')

subplot(1,2,2)

% division time kymo
close all
make_kymograph(all_startt,all_dt,4,11,11,0,140,80);
title('Divistion Time vs startT')
xlabel('Start Time')
ylabel('Division Time')
set(gcf,'color','white')

if save_plot
    export_fig([plotsave 'divisiontime.pdf'])
    savefig([plotsave 'divisiontime.fig'])
end
%% deltalength
figure;

for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage
            scatter(cs{i}.startt,cs{i}.deltalength,50,cs{i}.color,'filled')
            hold on;
        else
            scatter(cs{i}.startt,cs{i}.deltalength,50,[0.5 0.5 0.5],'filled')
            hold on;
        end
    end
end

for i = unique(all_startt)
    idx = find(i == all_startt);
    scatter(i,median(all_deltal(idx)),70,'black','filled')
    hold on;
end
ylabel('Delta Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([-2 6])
if save_plot
    export_fig([plotsave 'deltalength.pdf'])
end

% %% dl/sl
% 
% figure;
% dlsl = [];
% for i = 1:numel(cs)
%     if lineage_on
%         if cs{i}.lineage
%             scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color','filled')
%         end
%     else
%         scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color','filled')
%     end
%     hold on;
%     dlsl = [dlsl cs{i}.deltalength/cs{i}.length(1)];
% end
% 
% for i = unique(all_startt)
%     idx = find(i == all_startt);
%     scatter(i,median(dlsl(idx)),70,'black','filled')
%     hold on;
% end
% ylabel('Delta Length/Start Length (µm)')
% xlabel('Time (min)')
% set(gcf,'color','white')
% ylim([-2 6])
% if save_plot
%     export_fig([plotsave 'deltalengthoverstartlength.pdf'])
%     savefig([plotsave 'deltalength.fig'])
% end

%% average growthrate
figure;
hist_transparent(all_avg_lambda,100,[0 1 0])
hold on;
plot(ones(1,2)*nanmedian(all_avg_lambda),[0 0.25],':','Color',cs{i}.color)
xlabel('Average Growthrate')
xlim([-0.01 0.06])
if save_plot
    export_fig([plotsave 'hist-avggrowthrate.pdf'])
    savefig([plotsave 'hist-avggrowthrate.fig'])
end
close all

end
