function plot_singlecell_data(cs,c,tF,tS,histc,varargin)
fluor_on = 0;
induction_switch = 0;
blank = 0;
% for length
mincontrol = 3;
maxcontrol = 8;

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if fluor_on
    N = 2;
    M = 3;
else
    N = 1;
    M = 3;
end

% close all;
all_length = [];
all_time = [];
all_width = [];
all_lambda = [];
all_lamtime = [];
all_fluor = [];
all_startt = [];
all_deltal = [];
figure('Color',[1 1 1],'Position', [100, 100, 1500, 600]);
for i = 1:numel(cs)
        subplot(N,M,1) % length
        plot(cs{i}.time,cs{i}.length,'Color',c,'UserData',i); hold on;
        subplot(N,M,2) % width
        plot(cs{i}.time,smooth(cs{i}.width),'Color',c,'UserData',i); hold on;
        if fluor_on
            subplot(N,M,4) % fluorescence
            plot(cs{i}.time,smooth(double(cs{i}.norm_avg_fluor-blank)),'Color',c,'UserData',i); hold on;
            subplot(N,M,5) % fluor vs width
            plot(smooth(cs{i}.width),smooth(double(cs{i}.norm_avg_fluor-blank)),'Color',c,'UserData',i); hold on;
        end
        
        all_length = [all_length cs{i}.length];
        all_time = [all_time cs{i}.time];
        all_width = [all_width cs{i}.width];
        all_fluor = [all_fluor cs{i}.avg_fluor-blank];
        all_lambda = [all_lambda cs{i}.instant_lambda_V];
        all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
        all_startt = [all_startt cs{i}.startt];
        all_deltal = [all_deltal cs{i}.deltalength];
    hold on;
    
end

subplot(N,M,1) % length
med_length = [];

h = fill([0 0 induction_switch induction_switch],[0 10 10 0],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')

for i = min(all_time):max(all_time)
    idx = find(i == all_time);
    if idx
        med_length = [med_length;[i,nanmedian(all_length(idx))]];
    end
end
idx1 = ~isnan(med_length(:,2));
% plot(med_length(idx1,1),med_length(idx1,2),'black','LineWidth',2,'UserData',i)
ylimits = ylim;
xlimits = xlim;
% plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')
plot([induction_switch xlimits(2)],ones(1,2)*mincontrol,'LineStyle',':','Color',[0.5 0.5 0.5])
plot([induction_switch xlimits(2)],ones(1,2)*maxcontrol,'LineStyle',':','Color',[0.5 0.5 0.5])


% set(gca,'FontSize',12)
set(gca,'FontName','Myriad Pro')
ylabel('Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([1 10])
xlim([tS tF])
%prettifyplot

subplot(N,M,2) % width
med_width = [];
h = fill([0 0 induction_switch induction_switch],[0 10 10 0],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')
for i = min(all_time):max(all_time)
    idx = find(i == all_time);
    med_width = [med_width;[i,nanmedian(all_width(idx))]];
    hold on;
end
idx1 = ~isnan(med_width(:,2));
plot(med_width(idx1,1),med_width(idx1,2),'black','LineWidth',2)
% set(gca,'FontSize',12)
set(gca,'FontName','Myriad Pro')
ylabel('Width (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
 ylim([0.5 3])
xlim([tS tF])
%prettifyplot

subplot(N,M,3) % growthrate
[n,binctrs] = hist3([all_lamtime;all_lambda]',[100 200]);
edges1 = [binctrs{1}-(binctrs{1}(2)-binctrs{1}(1))/2 binctrs{1}(end)+(binctrs{1}(2)-binctrs{1}(1))/2];
edges2 = [binctrs{2}-(binctrs{2}(2)-binctrs{2}(1))/2 binctrs{2}(end)+(binctrs{2}(2)-binctrs{2}(1))/2];
x = discretize(all_lamtime,edges1);
y = discretize(all_lambda,edges2);
y(isnan(y)) = 1;
x(isnan(x)) = 1;
scatter_size = zeros(numel(all_lambda),1)';
scatter_col = zeros(numel(all_lambda),1)';
h = fill([0 0 induction_switch induction_switch],[0 10 10 0],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')
for i = 1:numel(all_lambda)
    scatter_size(i) = 30;
    scatter_col(i) = n(x(i),y(i)); hold on;
end
    
scatter(all_lamtime,all_lambda,scatter_size,scatter_col,'filled')
colormap(histc)

median_growthrate = [];

for i = min(all_lamtime):max(all_lamtime)
    idx = find(i == all_lamtime);
    median_growthrate = [median_growthrate; [i,nanmedian(all_lambda(idx))]];
    scatter(i,nanmedian(all_lambda(idx)),10,'black','filled');
    hold on;
end
idx = ~isnan(median_growthrate(:,2));
h2 = plot(median_growthrate(idx,1),median_growthrate(idx,2),'black','LineWidth',2);
p = polyfit(median_growthrate(idx,1),median_growthrate(idx,2),1);
x1 = linspace(tS,tF);
y1 = polyval(p,x1);

% set(gca,'FontSize',12)
set(gca,'FontName','Myriad Pro')
ylabel('Instant. Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
ylim([0.01 0.04])
%prettifyplot

if fluor_on
subplot(N,M,4) % fluor
med_fluor = [];
h = fill([0 0 induction_switch induction_switch],[0 10 10 0],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')
for i = min(all_time):max(all_time)
    idx = find(i == all_time);
    med_fluor = [med_fluor;[i,nanmedian(all_fluor(idx))]];
    hold on;
end
idx1 = ~isnan(med_fluor(:,2));
plot(med_fluor(idx1,1),med_fluor(idx1,2),'black','LineWidth',2)
% set(gca,'FontSize',12)
set(gca,'FontName','Myriad Pro')
ylabel('Avg Fluorescence (A.U.)')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
ylim([0 100])
%prettifyplot

subplot(N,M,6) % deltaL
[n,binctrs] = hist3([all_startt;all_deltal]',[100 200]);
edges1 = [binctrs{1}-(binctrs{1}(2)-binctrs{1}(1))/2 binctrs{1}(end)+(binctrs{1}(2)-binctrs{1}(1))/2];
edges2 = [binctrs{2}-(binctrs{2}(2)-binctrs{2}(1))/2 binctrs{2}(end)+(binctrs{2}(2)-binctrs{2}(1))/2];
x = discretize(all_startt,edges1);
y = discretize(all_deltal,edges2);
y(isnan(y)) = 1;
x(isnan(x)) = 1;
scatter_size = zeros(numel(all_startt),1)';
scatter_col = zeros(numel(all_startt),1)';
h = fill([0 0 induction_switch induction_switch],[0 10 10 0],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')
for i = 1:numel(all_startt)
    scatter_size(i) = 30;
    scatter_col(i) = n(x(i),y(i)); hold on;
end
    
scatter(all_startt,all_deltal,scatter_size,scatter_col,'filled')
colormap(histc)

median_deltal = [];

for i = min(all_startt):max(all_startt)
    idx = find(i == all_startt);
    median_deltal = [median_deltal; [i,nanmedian(all_deltal(idx))]];
    scatter(i,nanmedian(all_deltal(idx)),10,'black','filled');
    hold on;
end
idx = ~isnan(median_deltal(:,2));
h2 = plot(median_deltal(idx,1),median_deltal(idx,2),'black','LineWidth',2);
p = polyfit(median_deltal(idx,1),median_deltal(idx,2),1);
x1 = linspace(tS,tF);
y1 = polyval(p,x1);

% set(gca,'FontSize',12)
set(gca,'FontName','Myriad Pro')
ylabel('Delta Length')
xlabel('Start time (min)')
set(gcf,'color','white')
xlim([tS tF])
%prettifyplot

subplot(N,M,5)
idx1 = ~isnan(med_fluor(:,2));
plot(med_width(idx1,2),med_fluor(idx1,2),'black','LineWidth',2)
scatter(med_width(end,2),med_fluor(end,2),100,'black','filled','Marker','^')
ylabel('Avg Fluorescence (A.U.)')
xlabel('Width (µm)')
set(gcf,'color','white')
ylim([-10 600])
xlim([0.5 3])
% xlim([tS tF])
%prettifyplot
end

% fluor plots
%     figure('Position',[0 0 300 250])
%     
%     for i = 1:numel(cs)
%         if cs{i}.time(end) < tF
%             if lineage_on
%                 if cs{i}.lineage
%                     plot(cs{i}.time,smooth(cs{i}.avg_fluor)','Color',c,'UserData',i)
%                 else
%                     plot(cs{i}.time,smooth(cs{i}.avg_fluor)','Color',[0.5 0.5 0.5],'UserData',i)
%                 end
%                 
%             else
%                 plot(cs{i}.time,smooth(cs{i}.avg_fluor)','Color',c,'UserData',i)
%             end
%         end
%         hold on;
%     end
%     
%     med_fluor = [];
%     for i = min(all_time):max(all_time)
%         idx = find(i == all_time);
%         if ~isempty(idx)
%         med_fluor = [med_fluor;[i,nanmedian(all_fluor(idx))]];
%         end
%         hold on;
%     end
%     idx1 = ~isnan(med_fluor(:,2));
%     plot(med_fluor(idx1,1),med_fluor(idx1,2),'black','LineWidth',2)
%     set(gca,'FontSize',15)
%     set(gca,'FontName','Myriad Pro')
%     ylabel('Fluorescence','FontSize',20)
%     xlabel('Time (min)','FontSize',20)
%     set(gcf,'color','white')
%     ylim([300 350])
%     xlim([tS tF])
% end

% %%
% figure;
% for i = 1:numel(cs)
%     %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
%     if lineage_on
%         if cs{i}.lineage
%             scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color,'filled')
%         else
%             scatter(cs{i}.startt,cs{i}.divtime,50,[0.5 0.5 0.5],'filled')
%         end
%     else
%         scatter(cs{i}.startt,cs{i}.divtime,50,cs{i}.color,'filled')
%     end
%     hold on;
%     %end
%     %     all_dt = [all_dt cs{i}.divtime];
%     %     all_finalt = [all_finalt cs{i}.finalt];
%     %     all_startt = [all_startt cs{i}.startt];
% end
% 
% for i = unique(all_startt)
%     idx = find(i == all_startt);
%     scatter(i,median(all_dt(idx)),70,'black','filled')
%     hold on;
% end
% 
% 
% %make_kymograph(all_startt,all_dt,4,11,11,0,120,50);
% 
% xlabel('Start Time (min)','FontSize',20)
% ylabel('Division Time t(f)-t(i) (min)','FontSize',20)
% set(gcf,'color','white')
% %ylim([0 25])
% if save_plot
%     export_fig([plotsave 'divisiontime.pdf'])
%     savefig([plotsave 'divisiontime.fig'])
% end
% %% deltalength
% figure('Position',[0 0 300 250])
% % all_deltal = [];
% % all_finalt = [];
% % all_startt = [];
% 
% for i = 1:numel(cs)
%     %if cs{i}.time(end) < tF & cs{i}.time(1) > tS
%     if lineage_on
%         if cs{i}.lineage
%             scatter(cs{i}.startt,cs{i}.deltalength,50,cs{i}.color,'filled')
%             hold on;
%         else
%             scatter(cs{i}.startt,cs{i}.deltalength,50,[0.5 0.5 0.5],'filled')
%             hold on;
%         end
%         %     all_deltal = [all_deltal cs{i}.deltalength];
%         %     all_startt = [all_startt cs{i}.startt];
%         %     all_finalt = [all_finalt cs{i}.finalt];
%     else
%         scatter(cs{i}.startt,cs{i}.deltalength,50,c,'filled')
%         hold on;
%         
%     end
%     %end
% end
% 
% for i = unique(all_startt)
%     idx = find(i == all_startt);
%     scatter(i,median(all_deltal(idx)),70,'black','filled')
%     hold on;
% end
% set(gca,'FontSize',15)
% set(gca,'FontName','Myriad Pro')
% ylabel('Delta Length (µm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)
% set(gcf,'color','white')
% ylim([0 4])
% xlim([tS tF])
% if save_plot
%     export_fig([plotsave 'deltalength.pdf'])
% end
% %% dl/sl
% 
% figure;
% % all_deltal = [];
% % all_finalt = [];
% % all_startt = [];
% dlsl = [];
% for i = 1:numel(cs)
%     %if cs{i}.time(end) < tF
%     if lineage_on
%         if cs{i}.lineage
%             scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color,'filled')
%         end
%     else
%         scatter(cs{i}.startt,cs{i}.deltalength/cs{i}.length(1),50,cs{i}.color,'filled')
%     end
%     hold on;
%     dlsl = [dlsl cs{i}.deltalength/cs{i}.length(1)];
%     %end
%     %     all_deltal = [all_deltal cs{i}.deltalength];
%     %     all_startt = [all_startt cs{i}.startt];
%     %     all_finalt = [all_finalt cs{i}.finalt];
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
% 
% %% average growthrate
% figure;
% hist_transparent(all_avg_lambda,100,[0 1 0])
% hold on;
% plot(ones(1,2)*nanmedian(all_avg_lambda),[0 0.25],':','Color',[0 1 0])
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
% make_kymograph(all_dt,all_avg_lambda,4,10,20);
% title('Growthrate vs Divistion Time')
% xlabel('Division Time')
% ylabel('Growthrate')
% 
% %% division time
% close all
% make_kymograph(all_startt,all_dt,4,11,11,0,140,80);
% title('Divistion Time vs startT')
% xlabel('Start Time')
% ylabel('Division Time')
% set(gcf,'color','white')
% if save_plot
%     export_fig([plotsave 'div-kymo.pdf'])
% end

% %% plot ftsz distances
% 
% pxl = 0.08;
% ring_dist = [];
% for i = 1:numel(list1)
%     f = load(list1(i).name);
%     for id = 1:numel(f.cells)
%         ring_dist = [ring_dist calc_ring_distance(f,id)];
%     end
% end
% figure;
% hist(ring_dist*pxl)
% 
% %% width fluor plot
% 
% close all
% cs = a22_2;
% c1=[0 1 1];
% c2 =[1 0 0];
% maxt = 60;
% plot_save = 'A22-2-';
% for i = 1:numel(cs)
%     c = c1 + (c2-c1)*double(cs{i}.avg_fluor)/double(maxt);
%     plot(smooth(cs{i}.time),smooth(cs{i}.avg_fluor),'Color',c)
%     hold on;
% end
% 
% xlabel('Width (µm)')
% ylabel('Fluorescence')
% colorbar('TickLabels',strread(num2str(0:12:120),'%s'))
% cb = repmat(c1,[maxt,1]) + (repmat(c2,[maxt,1])-repmat(c1,[maxt,1])).*repmat(((1:maxt)./maxt)',[1,3]);
% colormap(cb)
% ylim([0 1400])
% title('Width vs Fluorescence')
% export_fig([plotsave 'width-fluor.pdf'])
% savefig([plotsave 'width-fluor.fig'])

end