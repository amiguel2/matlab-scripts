filelist = dir('*.mat');
sc = 0.064; % pixel scaling
for q=1:numel(filelist)
    count = 0;
    load(filelist(q).name);
    
    % process frames
    nc = numel(cell)
    c0 = [1 0 0];
    c1 = [0 0 1];
    %%figure;
    clear Mlength;
    %%hold on;
    for j=1:nc
        fprintf('Analyzing cell %d...\n',j);
        c = c0+(c1-c0)*(j-1)/(nc-1);
        clear length time;
        for k=1:numel(cell(j).frames)
            if ...
                    frame(cell(j).frames(k)).object(cell(j) ...
                                                    .bw_label(k)).on_edge==0 & numel(frame(cell(j).frames(k)).object(cell(j).bw_label(k)).MT_length)>0
                length(k) = ...
                    frame(cell(j).frames(k)).object(cell(j).bw_label(k)).MT_length;
            else
                length(k) = NaN;
            end
            time(k) = cell(j).frames(k);
        end

        length = length*sc;
        fi = find(~isnan(length));
        if numel(fi)>2
            count = count+1;
            ts = time-time(fi(1));
            %%KCplot(ts(fi),length(fi)/length(fi(1)),'Color',c);
            
            time_curves{j} = ts(fi);
            length_curves{j} = length(fi);
            
            % fit length curves
            beta = [length(fi(1)) 20];
            
            [beta,r] = nlinfit(ts(fi),length(fi),@expfit,beta);
            %plot(time-time(1),expfit(beta,time-time(1))/beta(1),'Color',[0 0 0]);
            
            betas(j,:) = beta;
            res(j) = sqrt(sum(r.*r)/beta(1)^2);
        else
            betas(j,:) = [-1 0];
            res(j) = 1000000;
        end
        % compile into a bulk matrix
        %for l=numel(time)+1:20
        %    length(l) = NaN;
        %end
        %Mlength(count,:) = length(1:20);
    end
    hold off;
    
    %% replot all curves that pass filter
    maxres = 0.2;
    fi = find(res'<maxres & betas(:,2)<300);

    [path,name,ext] = fileparts(filelist(q).name);    
    figure;
    %subplot(1,3,1);
    hold on;
    for j=1:numel(fi)
        c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
        plot(time_curves{fi(j)},length_curves{fi(j)}/length_curves{fi(j)}(1),'Color',c,'LineWidth',0.5);
    end
    % overlay average
    average_length = expfit([1 mean(betas(fi,2))],0:30);
    plot(0:30,average_length,'Color',[0 0 0],'LineWidth',2);
    
    hold off;
    xlabel('Time (min)');
    ylabel('Fractional growth');
    title(['Growth curves for expt ',num2str(q)]);
    xlim([0 30])
    ylim([0.8 2.5]);
    print('-dpdf',[name,'_growth_curves',int2str(q),'.pdf']);
    
    %subplot(1,3,2);
    figure;
    hist(betas(fi,2),10:2:60);
    xlim([10 50]);
    xlabel('Doubling time (min)');
    ylabel('Number of cells');
    % add average
    mean_time(j) = mean(betas(fi,2));
    title(['Mean doubling time = ',num2str(mean_time(j))]);
    hold on;
    yl = ylim;
    plot([mean_time(j) mean_time(j)],[0 yl(2)],'Color',[0.5 0.5 0],'LineWidth',2);
    print('-dpdf',[name,'_doubling_times_hist',int2str(q),'.pdf']);
    
    %subplot(1,3,3);
    figure;
    scatter(betas(fi,1),betas(fi,2),10+maxres-res(fi)',res(fi)'/maxres*[1 ...
                        1 1],'filled');
    xlim([1 6]);
    ylim([10 50]);
    xlabel('Initial length (um)');
    ylabel('Growth rate (um/min)');
    title('Size and color indicate goodness of fit');
    print('-dpdf',[name,'_scatter_length_doubling_times',int2str(q),'.pdf']);
    
    % save fits
    beta_all{q} = betas(fi,:);
    res_all{q} = res(fi);
    
    %[path,name,ext] = fileparts(filelist(q).name);
    %fileout = [name,'.pdf'];
    %    axis([0 20 1 2]);
    %print('-dpdf',fileout);
    
    %mean_length(q,:) = nanmean(Mlength);
    %    close all;
end

pause;
% histograms of average growth rates
growth_rates{1} = beta_all{1}(:,2)';
growth_rates{2} = [beta_all{3}(:,2)' beta_all{4}(:,2)'];
growth_rates{3} = [beta_all{5}(:,2)' beta_all{6}(:,2)'];
maxg = 0;
ming = 100000;
numbins = 100;
for j=1:3
    maxg = max(maxg,max(growth_rates{j}'));
    ming = min(ming,min(growth_rates{j}'));
end
for j=1:3
    [gt,nt] = hist(growth_rates{j},ming:(maxg-ming)/numbins:maxg);
    ghist{j} = gt;
    nhist{j} = nt;
    
    sumhist{j} = sum(gt);
    ghist{j} = ghist{j}/sumhist{j};
    meang(j) = nanmean(growth_rates{j});
    mediang(j) = median(growth_rates{j});
end
colors(1,:) = [0 0 1];
colors(2,:) = [0 1 0];
colors(3,:) = [1 0 0];

figure;
stairs(nhist{1},[ghist{1};ghist{2};ghist{3}]','LineWidth',1);
legend('empty','wt','mut');
hold on;
xlabel('Doubling time (min)');
ylabel('Frequency');
% draw averages
maxy = 0.35;
for j=1:3
    plot(meang(j)*ones(1,2),[0 maxy],'Color',colors(j,:),'LineWidth',2);
    plot(mediang(j)*ones(1,2),[0 maxy],'LineStyle',':','Color',colors(j,:),'LineWidth',1.5);
end
hold off;
xlim([10 50]);
ylim([0 0.3]);
print('-dpdf','growth_rates.pdf');

% $$$ figure;
% $$$ % plot average growth curves
% $$$ c0 = [1 0 0];
% $$$ c1 = [0 1 0];
% $$$ hold on;
% $$$ for q=1:numel(filelist)
% $$$     c = c0+(c1-c0)*(q-1)/(numel(filelist)-1);  
% $$$     plot(1:20,mean_length(q,:));
% $$$ end
