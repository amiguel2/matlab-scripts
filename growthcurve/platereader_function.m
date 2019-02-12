function data = platereader_function(file,savename,blankwells)

wellformat = 96; % 96 or 384
[~,wells] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/analysis scripts/wells.xlsx');

% data
data.all_gr = zeros(numel(file),96);
data.all_lag = zeros(numel(file),96);
data.all_finalod = zeros(numel(file),96);
data.all_auc = zeros(numel(file),96);
for j = 1:numel(file)
    fprintf('%s\n',file{j})
    [num1,t] = readEpochdata(file{j});
    idx = find(t ==0,2);
    if numel(idx) == 2
        t = t(1:idx(2)-1);
    end
    
    % log od
    od = num1-repmat(mean(mean(num1(:,blankwells))),[size(num1,1),wellformat]);
    logod = od(1:end,:);
    for i = 1:wellformat
        logod(:,i) = smooth(real(log(od(1:end,i))),10);
        plot(t*60,logod(:,i)); hold on;
    end
    prettifyplot
    ylabel('ln(OD)')
    xlabel('Time (hr')
    saveplots(sprintf('%s-od-%d',savename,j))

    % get growtrate
    close all;
    maxgr = zeros(1,96);
    lag = zeros(1,96);
    final_od = zeros(1,96);
    auc = zeros(1,96);
    for i = 1:96
        [tempmaxgr,templag] = get_maxgrowthrate(logod(:,i),t); %pause;
        maxgr(1,i) = tempmaxgr(2); % fit linear to log
        lag(1,i) = templag(2);
        final_od(1,i) = od(end,i);
        auc(1,i) = trapz(t, od(:,i));
    end
    data.all_gr(j,:) = maxgr;
    data.all_lag(j,:) = lag;
    data.all_finalod(j,:) = final_od;
    data.all_auc(j,:) = auc;
end

[metate_cellwidth,metate_mut] = get_metate_widths();
metate_cellwidth = metate_cellwidth';
end