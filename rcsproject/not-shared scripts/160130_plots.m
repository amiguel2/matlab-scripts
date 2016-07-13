% data
list = dir('im*.mat');
cs = get_data(list,4,0.08)
plotsave = 'im-'

% length plots
figure;
all_length = [];
all_time = [];

for i = 1:numel(cs)
    plot(cs{i}.time,cs{i}.length,'Color',cs{i}.color)
    hold on;
    all_length = [all_length cs{i}.length];
    all_time = [all_time cs{i}.time];
end

for i = unique(all_time)
    idx = find(i == all_time);
    scatter(i,median(all_length(idx)),10,'black','filled')
    hold on;
end

ylabel('Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([0 8])
export_fig([plotsave 'length.pdf'])

% growthrate plots
figure;
all_lambda = [];
all_avg_lambda = [];
all_lamtime = [];

for i = 1:numel(cs)
    plot(cs{i}.time(1:end-1),cs{i}.lambda,'Color',cs{i}.color)
    hold on;
    all_lambda = [all_lambda cs{i}.lambda];
    all_avg_lambda = [all_avg_lambda mean(cs{i}.lambda)];
    all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
end

for i = unique(all_lamtime)
    idx = find(i == all_lamtime);
    scatter(i,median(all_lambda(idx)),10,'black','filled')
    hold on;
end

ylabel('Instantaneous Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([-0.01 0.06])
export_fig([plotsave 'growthrate.pdf'])

% division time
figure;
all_dt = [];
all_finalt = [];

for i = 1:numel(cs)
    scatter(cs{i}.finalt,cs{i}.divtime,50,cs{i}.color','filled')
    hold on;
    all_dt = [all_dt cs{i}.divtime];
    all_finalt = [all_finalt cs{i}.finalt];
end

for i = unique(all_finalt)
    idx = find(i == all_finalt);
    scatter(i,median(all_dt(idx)),70,'black','filled')
    hold on;
end
xlabel('Final Time (min)')
ylabel('Division Time t(f)-t(i) (min)')
set(gcf,'color','white')
ylim([0 60])
export_fig([plotsave 'divisiontime.pdf'])

% deltalength
figure;
all_deltal = [];
all_finalt = [];

for i = 1:numel(cs)
    scatter(cs{i}.finalt,cs{i}.deltalength,50,cs{i}.color','filled')
    hold on;
    all_deltal = [all_deltal cs{i}.deltalength];
    all_finalt = [all_finalt cs{i}.finalt];
end

for i = unique(all_finalt)
    idx = find(i == all_finalt);
    scatter(i,median(all_deltal(idx)),70,'black','filled')
    hold on;
end
ylabel('Delta Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
ylim([-2 6])
export_fig([plotsave 'deltalength.pdf'])

%
%     for j = 1:numel(startt)
%         scatter(all_dt(j),log(2)./all_avg_lambda(j),50,c,'filled')
%         hold on;
%         %text(all_dt(j),log(2)./all_lambda(j),int2str(all_cid(j)))
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

% average growthrate
figure;
    hist_transparent(all_avg_lambda,100,[0 1 0])
    hold on;
    plot(ones(1,2)*nanmedian(all_avg_lambda),[0 0.25],':','Color',[0 1 0])
    xlabel('Average Growthrate')
    xlim([-0.01 0.06])
    export_fig([plotsave 'hist-avggrowthrate.pdf'])
    close