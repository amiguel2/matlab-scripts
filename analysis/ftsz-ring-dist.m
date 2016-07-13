%% suppress warnings
w ='MATLAB:colon:nonIntegerIndex';
warning('off',w)

% for a single time point
colors = cbrewer('qual','Set1',8); % colors on histogram

t = 1:89;
minpeakdistance = 0;
minpeakprominence = 100;

plot_cells = 0; % plot individual cells
recalc = 0; % used previously saved data
c0 = [0 0 1]; % color of fluorescence signal
c1 = [0 1 0]; % color of fluorescence signal
leg = {cond{1}.title, cond{2}.title,cond{3}.title,cond{4}.title}

%% code runs

for g = [1 2 3 4]
    condition=cond{g};
    pxl = cond{g}.pxl;
    ring_dist = [];
    if recalc
        for time = t
            index = cellfun(@(x) x==time, cond{g}.time, 'UniformOutput', false);
            for i = 1:numel(index)
                j = find(index{i} == 1);
                if ~isempty(j)

                    beg = floor(0.05*numel(condition.fluor_prof{i}{j}));
                    en = numel(condition.fluor_prof{i}{j}) - beg;
                    fluor_prof = condition.fluor_prof{i}{j}(beg:end/2);
                    fluor_prof2 = condition.fluor_prof{i}{j}(end/2+1:en);
                    Xcont1 = condition.Xcont{i}{j}(beg:end/2);
                    Ycont1 = condition.Ycont{i}{j}(beg:end/2);
                    Xcont2 = condition.Xcont{i}{j}(end/2+1:en);
                    Ycont2 = condition.Ycont{i}{j}(end/2+1:en);
                    [pks1,loc1]=findpeaks(fluor_prof,'minpeakdistance',minpeakdistance,'minpeakprominence',minpeakprominence);
                    [pks2,loc2]=findpeaks(fluor_prof2,'minpeakdistance',minpeakdistance,'minpeakprominence',minpeakprominence);
                    if numel(pks1) > 1 && numel(pks2) > 1 && numel(pks1) == numel(pks2)
                        N = max(numel(loc1));
                        for k = 1:N-1
                            d1 = sum(sqrt(sum(diff([mean(Xcont1(loc1(k):loc1(k+1),:),2),mean(Ycont1(loc1(k):loc1(k+1),:),2)]).^2,2)));
                            d2 = sum(sqrt(sum(diff([mean(Xcont2(loc2(k):loc2(k+1),:),2),mean(Ycont2(loc2(k):loc2(k+1),:),2)]).^2,2)));
                            % plot the distance
                            if plot_cells
                                figure(2)
                                subplot(1,2,1)
                                plotSingleCell_image_frame([condition.cfile{i}(1:end-19) '_Phase.tif'],condition.cfile{i},condition.cid{i}(j),(condition.time{i}(j)+1)/2)
                                hold on;
                                a = log(condition.fluor_prof{i}{j} - min(condition.fluor_prof{i}{j}))/max(log(condition.fluor_prof{i}{j} - min(condition.fluor_prof{i}{j})));
                                c = repmat(c0,[numel(a),1]) + (repmat(c1,[numel(a),1]) - repmat(c0,[numel(a),1])).*repmat(a,[1,3]);
                                NN = max(size(condition.mesh{i}{j},2),size(c,1));
                                scatter(condition.Xcont{i}{j}(1:NN,:),condition.Ycont{i}{j}(1:NN,:),5,c(1:NN,:));
                                plot(Xcont1(loc1(k):loc1(k+1),:),Ycont1(loc1(k):loc1(k+1),:),'Color','r')
                                plot(Xcont2(loc2(k):loc2(k+1),:),Ycont2(loc2(k):loc2(k+1),:),'Color','b')
                                fprintf('Cell Length: %1.2f µm \tPeak Distance1: %1.2f µm \tPeak Distance2: %1.2f µm\n\n',condition.lengths{i}(j),d1*pxl,d2*pxl)
                                hold off;
                                subplot(1,2,2)
                                plotSingleCell_image_frame([condition.cfile{i}(1:end-19) '_GFP.tif'],condition.cfile{i},condition.cid{i}(j),(condition.time{i}(j)+1)/2)
                                hold on;
                                scatter(condition.Xcont{i}{j}(1:NN,:),condition.Ycont{i}{j}(1:NN,:),5,c(1:NN,:));
                                plot(Xcont1(loc1(k):loc1(k+1),:),Ycont1(loc1(k):loc1(k+1),:),'Color','r')
                                plot(Xcont2(loc2(k):loc2(k+1),:),Ycont2(loc2(k):loc2(k+1),:),'Color','b')
                                hold off;
                                pause
                            end
                            if ~isempty(d1) && ~isempty(d2)
                                ring_dist = [ring_dist mean([d1,d2])*pxl];
                            elseif isempty(d1)
                                ring_dist = [ring_dist d2*pxl];
                            elseif isempty(d2)
                                ring_dist = [ring_dist d1*pxl];
                            end
                            close;
                        end
                    end
                end
            end
        end

        %% plot histogram    
        if ~isempty(ring_dist)
            fprintf('%s: %d\n',cond{g}.title,length(ring_dist))
            [counts,centers] = hist(ring_dist,round(sqrt(numel(ring_dist))));
            fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors(g,:),'FaceAlpha',0.1,'EdgeColor',colors(g,:));
            hold on;
            Ylim = get(gca,'Ylim');
            [hpk,hloc] = findpeaks([counts,centers],'minpeakprominence',50);
            for l = 1:numel(hpk)
                h = plot(centers(hloc(l))*ones(1,2),[0 Ylim(2)],'LineStyle',':','Color',colors(g,:));
                set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
                fprintf('Peak: %1.2f\n',centers(hloc(l)))
            end
            save([cond{g}.title '_dist.mat'],'ring_dist')
        end
    else
        % reload from previous saved data
        load([cond{g}.title '_dist.mat'])
        figure(1)
        fprintf('%s: %d\n',cond{g}.title,length(ring_dist))
        [counts,centers] = hist(ring_dist,round(sqrt(numel(ring_dist))));
        fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors(g,:),'FaceAlpha',0.1,'EdgeColor',colors(g,:));
        hold on;
        Ylim = get(gca,'Ylim');
        [hpk,hloc] = findpeaks([counts,centers],'minpeakprominence',30);
        for l = 1:numel(hpk)
            h = plot(centers(hloc(l))*ones(1,2),[0 Ylim(2)],'LineStyle',':','Color',colors(g,:));
            set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            fprintf('Peak: %1.2f\n',centers(hloc(l)))
        end
    end
    
end
legend(leg)
