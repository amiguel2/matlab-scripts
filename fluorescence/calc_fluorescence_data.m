function fluordata = calc_fluorescence_data(dataset,remove_1peaks)
% remove_1peaks = 1;

%dataset = {em,wt,peri,im};
colorcount = 1;
fluordata = struct;
datalabel = {'D78V','D78VdrcsF','V316A','V316AdrcsF','P314L','P314LdrcsF'};%{'em','wt','peri','im'};
bins = [50 50 50 50 50 50];
c = cbrewer('qual','Paired',6);
for a = dataset
    l = [];
    ring_dist = [];
    ring_time = [];
    numpeaks = [];
    time = [];
    data = [a{:}];
    for i = 1:numel(data)
        cell = data{i};
        for j = 1:numel(cell.flr_profile)
            cont = cell.cont{j};
            flr = cell.flr_profile{j};
            if ~isnan(flr)
                
                % calc number of rings
                N = numel(flr)/2;
                fprofile = flr(1:N) + flipud(flr(N+1:end));
                midline = (cont(1:N,:) + flipud(cont(N+1:end,:)))./2;
%                 findpeaks(smooth(fprofile),'MinPeakProminence',2000);
                [pks,locs] = findpeaks(smooth(fprofile),'MinPeakProminence',2000);
                if ~isempty(pks)
                    
                    numpeaks = [numpeaks numel(pks)];
                else
                    numpeaks = [numpeaks NaN];
                end
                
                % calc ring disstance
                if numel(pks) > 1
                    d = sqrt(sum(diff(midline(locs,:),1).^2,2))';
                    ring_dist = [ring_dist d];
                    ring_time = [ring_time ones(1,numel(d))*cell.time(j)];
                end
            else
                numpeaks = [numpeaks NaN];
            end
        end
        time = [time cell.time];
        l = [l cell.length];
    end
    
    rings = zeros(numel(min(time):2:max(time)),3);
    count = 0;
    for i = min(time):2:30
        idx = find(time == i);
%         scatter(i,sum(numpeaks(idx))/sum(l(idx))); hold on;
        temp_numpeaks = numpeaks(idx);
        temp_l = l(idx);
        count = count +1;
        if remove_1peaks
           idx1 = find(temp_numpeaks > 1);
           rings(count,1) = i;
           rings(count,2) = nansum(temp_numpeaks(idx1)); % number of peaks
           rings(count,3) = sum(temp_l(idx1));
            
        else
        rings(count,1) = i; %time
        rings(count,2) = nansum(temp_numpeaks); % number of peaks
        rings(count,3) = sum(temp_l); % total length
        end
    end
    subplot(1,3,1)
    scatter(rings(:,2),rings(:,3),50,c(colorcount,:)); hold on;
    subplot(1,3,2)
    hist_transparent(ring_dist(~isnan(ring_dist)),bins(colorcount),c(colorcount,:)); hold on;
    fluordata.(datalabel{colorcount}).rings = rings;
    fluordata.(datalabel{colorcount}).ringdist = [ring_time;ring_dist];
    colorcount = colorcount + 1;
end
subplot(1,3,1)
xlabel('Total Number of Rings in all Cells')
ylabel('Total Length of all Cells')
prettifyplot
subplot(1,3,2)
xlabel('Ring Distance (pxl)')
ylabel('Normalized Frequency')


subplot(1,3,3)
cla
colorcount = 1;

for a = dataset
    totfluor = [];
    time = [];
    data = [a{:}];
    for i = 1:numel(data)
        cell = data{i};
        totfluor = [totfluor cell.avg_fluor];
        time = [time cell.time];
    end
    fluordata.(datalabel{colorcount}).totfluor = totfluor(time < 32);
    hist_transparent(totfluor(time < 60),bins(colorcount),c(colorcount,:)); hold on;
    plot(ones(1,2)*median(totfluor(time < 60)),[0 0.2],'Color',c(colorcount,:))
    colorcount = colorcount +1;
end
xlabel('Average Fluorescence')
ylabel('Normalized Frequency')
prettifyplot
end