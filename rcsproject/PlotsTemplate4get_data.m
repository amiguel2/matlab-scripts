% data
clear all
close all
cd('/Users/amiguel/sherlock_scratch/Working_Folder/Rcs_system/RCS30/')
list1 = dir('1-*CONTOURS.mat'); % EM
list2 = dir('2-*CONTOURS.mat'); % WT
list3 = dir('3-*CONTOURS.mat'); % Peri
list4 = dir('4-*CONTOURS.mat'); % IM
%  
% mesh_contours
%fluor_contours
%%
c = cbrewer('qual','Set1',4);
em = get_data(list1,2,0.08,'onecolor',c(1,:),'fluor_on',0,'lineage',1);
wt = get_data(list2,2,0.08,'onecolor',c(2,:),'fluor_on',0,'lineage',1);
peri = get_data(list3,2,0.08,'onecolor',c(3,:),'fluor_on',0,'lineage',1);
im = get_data(list4,2,0.08,'onecolor',c(4,:),'fluor_on',0,'lineage',1);
save('RCS30-data.mat')
%load('RCS30-data.mat')
%% length plots

% filtidx = find([cellfun(@(x) mean(x.avg_fluor),peri)> 800]);
% cs = {peri{filtidx}};
cs=em;
plotsave = 'em-';
j = 1; % color
% x = find(cell2mat(cellfun(@(X) mean(X.area) < 2,cs,'UniformOutput',false))==1);
% bad_cells = [1507 2970 x];
% allcells =1:numel(cs);
% filtcells = setdiff(allcells,bad_cells);
% cs = {cs{filtcells}};

%

c0 = cbrewer('qual','Set1',4);
c = c0;
% c(4,:) = c0(3,:);
% c(3,:) = c0(4,:);

tF = 120;
tS = 0;
lineage_on = 0;
save_plot = 1;
fluor_on = 0;
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
all_fluor = [];
figure('Position',[0 0 300 250])
for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage == 1
            plot(cs{i}.time,cs{i}.length,'Color',c,'UserData',i)
            all_length = [all_length cs{i}.length];
            all_time = [all_time cs{i}.time];
            all_width = [all_width cs{i}.width];
            all_lambda = [all_lambda cs{i}.instant_lambda];
            if fluor_on
                all_fluor = [all_fluor cs{i}.avg_fluor];
            end
            
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
            
            plot(cs{i}.time,cs{i}.length,'Color',[0.5 0.5 0.5],'UserData',i)
            all_length = [all_length cs{i}.length];
            all_time = [all_time cs{i}.time];
            all_width = [all_width cs{i}.width];
            all_lambda = [all_lambda cs{i}.instant_lambda];
            if fluor_on
                all_fluor = [all_fluor cs{i}.avg_fluor];
            end
            
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
        
        plot(cs{i}.time,cs{i}.length,'Color',c(j,:),'UserData',i)
        all_length = [all_length cs{i}.length];
        all_time = [all_time cs{i}.time];
        all_width = [all_width cs{i}.width];
        if fluor_on
           all_fluor = [all_fluor cs{i}.avg_fluor]; 
        end
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

med_length = [];
for i = 1:max(all_time)
    idx = find(i == all_time);
    med_length = [med_length;[i,nanmedian(all_length(idx))]];
    hold on;
end
idx1 = ~isnan(med_length(:,2));
plot(med_length(idx1,1),med_length(idx1,2),'black','LineWidth',2,'UserData',i)


% for i = min(all_time):max(all_time)
%     idx = find(i == all_time);
%     scatter(i,median(all_length(idx)),10,'black','filled')
%     hold on;
% end
set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
ylabel('Length (µm)','FontSize',20)
xlabel('Time (min)','FontSize',20)
set(gcf,'color','white')
ylim([1 7])
xlim([tS tF])
if save_plot
    export_fig([plotsave 'length.pdf'])
    savefig([plotsave 'length.fig'])
end

% width plots
figure('Position',[0 0 300 250])

for i = 1:numel(cs)
    if cs{i}.time(end) < tF
        if lineage_on
            if cs{i}.lineage
                plot(cs{i}.time,cs{i}.width,'Color',cs{i}.color,'UserData',i)
            else
                plot(cs{i}.time,cs{i}.width,'Color',[0.5 0.5 0.5],'UserData',i)
            end
            
        else
            plot(cs{i}.time,cs{i}.width,'Color',cs{i}.color,'UserData',i)
        end
    end
    hold on;
end

med_width = [];
for i = 1:max(all_time)
    idx = find(i == all_time);
    med_width = [med_width;[i,nanmedian(all_width(idx))]];
    hold on;
end
idx1 = ~isnan(med_width(:,2));
plot(med_width(idx1,1),med_width(idx1,2),'black','LineWidth',2)
set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
ylabel('Width (µm)','FontSize',20)
xlabel('Time (min)','FontSize',20)
set(gcf,'color','white')
ylim([0.5 2])
xlim([tS tF])
if save_plot
    export_fig([plotsave 'width.pdf'])
    savefig([plotsave 'width.fig'])
end

if fluor_on
    % fluor plots
    figure('Position',[0 0 300 250])
    
    for i = 1:numel(cs)
        if cs{i}.time(end) < tF
            if lineage_on
                if cs{i}.lineage
                    plot(cs{i}.time,smooth(cs{i}.avg_fluor)','Color',cs{i}.color,'UserData',i)
                else
                    plot(cs{i}.time,smooth(cs{i}.avg_fluor)','Color',[0.5 0.5 0.5],'UserData',i)
                end
                
            else
                plot(cs{i}.time,smooth(cs{i}.avg_fluor)','Color',cs{i}.color,'UserData',i)
            end
        end
        hold on;
    end
    
    med_fluor = [];
    for i = 1:max(all_time)
        idx = find(i == all_time);
        if ~isempty(idx)
        med_fluor = [med_fluor;[i,nanmedian(all_fluor(idx))]];
        end
        hold on;
    end
    idx1 = ~isnan(med_fluor(:,2));
    plot(med_fluor(idx1,1),med_fluor(idx1,2),'black','LineWidth',2)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylabel('Fluorescence','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([300 350])
    xlim([tS tF])
    if save_plot
        export_fig([plotsave 'fluor.pdf'])
        savefig([plotsave 'fluor.fig'])
    end
end

% growthrate plots
figure('Color',[1 1 1],'Position',[0 0 300 250])

%figure('Color',[1 1 1],'Position', [100, 100, 800, 800]);
% subplot(2,2,1)
% for i = 1:numel(cs)
%     if lineage_on
%         if cs{i}.lineage
%             plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',cs{i}.color)
%         else
%             plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',[0.5 0.5 0.5])
%         end
%     else
%         plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',cs{i}.color)
%     end
%     hold on;
% end
% 
% median_growthrate = [];
% for i = 1:max(all_lamtime)
%     idx = find(i == all_lamtime);
%     median_growthrate = [median_growthrate; [i,median(all_lambda(idx))]];
%     scatter(i,median(all_lambda(idx)),10,'black','filled')
%     
%     hold on;
% end
% idx = ~isnan(median_growthrate(:,2));
% plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2)
% 
% ylabel('Instantaneous Growthrate')
% xlabel('Time (min)')
% set(gcf,'color','white')
% xlim([tS tF])
% ylim([-0.01 0.05])
% 
% subplot(2,2,2)
% fitted growthrate
for i = 1:numel(cs)
    if lineage_on
        if cs{i}.lineage
            if ~isnan(cs{i}.lambda.beta) 
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,cs{i}.color','UserData',i)
            end
        else
            if ~isnan(cs{i}.lambda.beta)
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    else
        if ~isnan(cs{i}.lambda.beta)
            scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,c(j,:),'filled','UserData',i); hold on;
        end
    end
end


median_growthrate = [];
for i = 1:max(all_startt)
    idx = find(i == all_startt);
    median_growthrate = [median_growthrate; [i,nanmedian(all_lambda_fit(idx))]];
    scatter(i,nanmedian(all_lambda_fit(idx)),10,'black','filled');
    
    hold on;
end
idx = ~isnan(median_growthrate(:,2));
h2 = plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2);
p = polyfit(median_growthrate(idx,1),median_growthrate(idx,2),1);
x1 = linspace(tS,tF);
y1 = polyval(p,x1);
% h3 = plot(x1,y1,'Color','black','LineStyle',':');

% legend([h2,h3],{'Median','Linear Polyfit'})

set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
ylabel('Fitted Growthrate','FontSize',20)
xlabel('Time (min)','FontSize',20)
set(gcf,'color','white')
xlim([tS tF])
ylim([0.01 0.04])

% subplot(2,2,3)
% % avg growthrate
% for i = 1:numel(cs)
%     if lineage_on
%         if cs{i}.lineage
%             if ~isempty(cs{i}.instant_lambda)
%                 scatter(cs{i}.time(1),mean(cs{i}.instant_lambda),50,cs{i}.color)
%             end
%         else
%             if ~isempty(cs{i}.instant_lambda)
%                 scatter(cs{i}.time(1),mean(cs{i}.instant_lambda),50,[0.5 0.5 0.5])
%             end
%         end
%         hold on;
%     else
%         if ~isempty(cs{i}.instant_lambda)
%             scatter(cs{i}.time(1),mean(cs{i}.instant_lambda),50,cs{i}.color,'filled'); hold on;
%         end
%     end
% end
% 
% 
% median_growthrate = [];
% for i = 1:max(all_startt)
%     idx = find(i == all_startt);
%     median_growthrate = [median_growthrate; [i,nanmedian(all_avg_lambda(idx))]];
%     scatter(i,nanmedian(all_avg_lambda(idx)),10,'black','filled')
%     
%     hold on;
% end
% idx = ~isnan(median_growthrate(:,2));
% h2 = plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2);
% p = polyfit(median_growthrate(idx,1),median_growthrate(idx,2),1);
% x1 = linspace(tS,tF);
% y1 = polyval(p,x1);
% h3 = plot(x1,y1,'Color','black','LineStyle',':');
% 
% legend([h2,h3],{'Median','Linear Polyfit'})
% 


% ylabel('Average Cell Growthrate'
% xlabel('Time (min)','FontSize',20)
% set(gcf,'color','white')
% xlim([tS tF])
% ylim([-0.01 0.05])

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
            scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color,'filled')
        else
            scatter(cs{i}.startt,cs{i}.divtime,50,[0.5 0.5 0.5],'filled')
        end
    else
        scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color,'filled')
    end
    hold on;
    %end
    %     all_dt = [all_dt cs{i}.divtime];
    %     all_finalt = [all_finalt cs{i}.finalt];
    %     all_startt = [all_startt cs{i}.startt];
end

for i = unique(all_startt)
    idx = find(i == all_startt);
    scatter(i,median(all_dt(idx)),70,'black','filled')
    hold on;
end


%make_kymograph(all_startt,all_dt,4,11,11,0,120,50);

xlabel('Start Time (min)','FontSize',20)
ylabel('Division Time t(f)-t(i) (min)','FontSize',20)
set(gcf,'color','white')
%ylim([0 25])
if save_plot
    export_fig([plotsave 'divisiontime.pdf'])
    savefig([plotsave 'divisiontime.fig'])
end
%% deltalength
figure('Position',[0 0 300 250])
% all_deltal = [];
% all_finalt = [];
% all_startt = [];

for i = 1:numel(cs)
    %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
    if lineage_on
        if cs{i}.lineage
            scatter(cs{i}.startt,cs{i}.deltalength,50,cs{i}.color,'filled')
            hold on;
        else
            scatter(cs{i}.startt,cs{i}.deltalength,50,[0.5 0.5 0.5],'filled')
            hold on;
        end
        %     all_deltal = [all_deltal cs{i}.deltalength];
        %     all_startt = [all_startt cs{i}.startt];
        %     all_finalt = [all_finalt cs{i}.finalt];
    else
        scatter(cs{i}.startt,cs{i}.deltalength,50,c(j,:),'filled')
        hold on;
        
    end
    %end
end

for i = unique(all_startt)
    idx = find(i == all_startt);
    scatter(i,median(all_deltal(idx)),70,'black','filled')
    hold on;
end
set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
ylabel('Delta Length (µm)','FontSize',20)
xlabel('Time (min)','FontSize',20)
set(gcf,'color','white')
ylim([0 4])
xlim([tS tF])
if save_plot
    export_fig([plotsave 'deltalength.pdf'])
end
%% dl/sl

figure;
% all_deltal = [];
% all_finalt = [];
% all_startt = [];
dlsl = [];
for i = 1:numel(cs)
    %if cs{i}.time(end) < tF
    if lineage_on
        if cs{i}.lineage
            scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color,'filled')
        end
    else
        scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color,'filled')
    end
    hold on;
    dlsl = [dlsl cs{i}.deltalength/cs{i}.length(1)];
    %end
    %     all_deltal = [all_deltal cs{i}.deltalength];
    %     all_startt = [all_startt cs{i}.startt];
    %     all_finalt = [all_finalt cs{i}.finalt];
end

for i = unique(all_startt)
    idx = find(i == all_startt);
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

%% average growthrate
figure;
hist_transparent(all_avg_lambda,100,[0 1 0])
hold on;
plot(ones(1,2)*nanmedian(all_avg_lambda),[0 0.25],':','Color',[0 1 0])
xlabel('Average Growthrate')
xlim([-0.01 0.06])
if save_plot
    export_fig([plotsave 'hist-avggrowthrate.pdf'])
    savefig([plotsave 'hist-avggrowthrate.fig'])
end
close

%% growthrate vs division time
figure;
make_kymograph(all_dt,all_avg_lambda,4,10,20);
title('Growthrate vs Divistion Time')
xlabel('Division Time')
ylabel('Growthrate')

%% division time
close all
make_kymograph(all_startt,all_dt,4,11,11,0,140,80);
title('Divistion Time vs startT')
xlabel('Start Time')
ylabel('Division Time')
set(gcf,'color','white')
if save_plot
    export_fig([plotsave 'div-kymo.pdf'])
end

%% Median Comparisons
figure('Color',[1 1 1],'Position', [100, 100, 800, 800]);
exp = {em, wt, im, peri};
tS = 0;
tF = 120;
lineage_on = 1; 
fluor_on = 0;
for j = 1:numel(exp)
    cs = exp{j};
        if lineage_on
        idx = cell2mat(cellfun(@(X) X.lineage == 1,cs,'UniformOutput',false));
        cs = {cs{idx}}
        end
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
    all_fluor = [];
    for i = 1:numel(cs)
        if fluor_on
        all_fluor = [all_fluor cs{i}.avg_fluor];
        end
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
    colors = cs{1}.color;
    
    % length
    subplot(2,2,1)
    
    med_length = [];
    err_length = [];
    for i = 1:max(all_time)
        idx = find(i == all_time);
        med_length = [med_length;[i,nanmedian(all_length(idx))]];
        err_length = [err_length; [i,nanstd(all_length(idx))]];
        hold on;
    end
    idx1 = ~isnan(med_length(:,2));
    
    xlen = med_length(idx1,1);
    yupperbound = med_length(idx1,2)+(err_length(idx1,2)/2);
    ylowerbound = med_length(idx1,2)-(err_length(idx1,2)/2);
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],colors,'FaceAlpha',0.2,'EdgeColor','none');
    h(j) = plot(med_length(idx1,1),med_length(idx1,2),'Color',colors,'LineWidth',2);



    %width
    subplot(2,2,2)
    med_width = [];
    err_width = [];
    for i = 1:max(all_time)
        idx = find(i == all_time);
        med_width = [med_width;[i,nanmedian(all_width(idx))]];
        err_width = [err_width; [i,nanstd(all_width(idx))]];
        hold on;
    end
    idx1 = ~isnan(med_width(:,2));
    xlen = med_width(idx1,1);
    yupperbound = med_width(idx1,2)+(err_width(idx1,2)/2);
    ylowerbound = med_width(idx1,2)-(err_width(idx1,2)/2);
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],colors,'FaceAlpha',0.2,'EdgeColor','none');
    h1(j) = plot(med_width(idx1,1),med_width(idx1,2),'Color',colors,'LineWidth',2);
    
    if fluor_on
       %fluor
    subplot(2,2,4)
    med_fluor = [];
    err_fluor = [];
    for i = 1:max(all_time)
        idx = find(i == all_time);
        if ~isempty(idx)
        med_fluor = [med_fluor;[i,nanmedian(all_fluor(idx))]];
        err_fluor = [err_fluor; [i,nanstd(all_fluor(idx))]];
        hold on;
        end
    end
    idx1 = ~isnan(med_fluor(:,2));
    xlen = med_fluor(idx1,1);
    yupperbound = med_fluor(idx1,2)+(err_fluor(idx1,2)/2);
    ylowerbound = med_fluor(idx1,2)-(err_fluor(idx1,2)/2);
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],colors,'FaceAlpha',0.2,'EdgeColor','none');
    h3(j) = plot(med_fluor(idx1,1),med_fluor(idx1,2),'Color',colors,'LineWidth',2);
    
    end
    
    subplot(2,2,3)    
    % growthrate
    median_growthrate = [];
    err_growthrate = [];
    for i = 1:max(all_lamtime)
        idx = find(i == all_lamtime);
        median_growthrate = [median_growthrate; [i,nanmedian(all_lambda(idx))]];
        err_growthrate = [err_growthrate; [i,nanstd(all_lambda(idx))]];
        %scatter(i,nanmedian(all_lambda_fit(idx)),10,'black','filled')
        
        hold on;
    end
    idx1 = ~isnan(median_growthrate(:,2));
    xlen = med_width(idx1,1);
    yupperbound = median_growthrate(idx1,2)+(err_growthrate(idx1,2)/2);
    ylowerbound = median_growthrate(idx1,2)-(err_growthrate(idx1,2)/2);
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],colors,'FaceAlpha',0.2,'EdgeColor','none');
    h2(j) = plot(median_growthrate(idx1,1),median_growthrate(idx1,2),'Color',colors,'LineWidth',2);
    
end

subplot(2,2,1)
legend([h(1),h(2),h(3),h(4)],'Empty','WT','IM','Peri')
ylabel('Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([0 tF])
ylim([0 6])

subplot(2,2,2)
ylabel('Width (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
legend([h1(1),h1(2),h1(3),h1(4)],'Empty','WT','IM','Peri')
ylim([0.8 1.5])
xlim([0 tF])

subplot(2,2,3)
ylabel('Median Instantaneous Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
%ylim([-0.01 0.06])
%ylim([0.02 0.04])
ylim([-0.01 0.05])
legend([h2(1),h2(2),h2(3),h2(4)],'Empty','WT','IM','Peri')

subplot(2,2,4)

title('Max Fluorescence')
ylabel('Max Fluorescence')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
%ylim([-0.01 0.06])
%ylim([0.02 0.04])
legend([h3(1),h3(2),h3(3),h3(4)],'Empty','WT','IM','Peri')

% subplot(2,2,4)
% 
% title('FtsZ-Ring-distance')
% hist_transparent(em_ring_dist*pxl,50,c(1,:))
% hold on;
% hist_transparent(wt_ring_dist*pxl,70,c(2,:))
% hist_transparent(peri_ring_dist*pxl,20,c(3,:))
% hist_transparent(im_ring_dist*pxl,50,c(4,:))
% xlim([0 20])
% legend('Empty(N=539)','WT(N=432)','IM(N=663)','Peri(N=176)')
export_fig([ 'RCS29-compare-all.tif'])
export_fig([ 'RCS29-compare-all.pdf'])
savefig([ 'RCS29-compare-all.fig'])

%% plot ftsz distances

pxl = 0.08;
ring_dist = [];
for i = 1:numel(list1)
    f = load(list1(i).name);
    for id = 1:numel(f.cells)
        ring_dist = [ring_dist calc_ring_distance(f,id)];
    end
end
figure;
hist(ring_dist*pxl)

%% width fluor plot

close all
cs = a22_2;
c1=[0 1 1];
c2 =[1 0 0];
maxt = 60;
plot_save = 'A22-2-';
for i = 1:numel(cs)
    c = c1 + (c2-c1)*double(cs{i}.avg_fluor)/double(maxt);
    plot(smooth(cs{i}.time),smooth(cs{i}.avg_fluor),'Color',c)
    hold on;
end

xlabel('Width (µm)')
ylabel('Fluorescence')
colorbar('TickLabels',strread(num2str(0:12:120),'%s'))
cb = repmat(c1,[maxt,1]) + (repmat(c2,[maxt,1])-repmat(c1,[maxt,1])).*repmat(((1:maxt)./maxt)',[1,3]);
colormap(cb)
ylim([0 1400])
title('Width vs Fluorescence')
export_fig([plotsave 'width-fluor.pdf'])
savefig([plotsave 'width-fluor.fig'])


