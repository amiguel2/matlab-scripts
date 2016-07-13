function data = histogram_growthrates(filelist,group,params)

% colors
c0 = params.color0; %[1 0 0];
c1 = params.color1; %[0 1 1];

% pixel size
sc = params.pxl_size;

fprintf('\n');
for q=1:numel(filelist)
    count = 0;
    fprintf('Analyzing file %s...\n',filelist(q).name);
    s = load(filelist(q).name);
    frame = s.frame;
    
    % process frames
    nc = numel(s.cell);

    clear Mlength;
    for j=1:nc
        fprintf('Analyzing cell %d...\n',j);
        c = c0+(c1-c0)*(j-1)/(nc-1);
        clear length time;
        for k=1:numel(s.cell(j).frames)
            framenum = s.cell(j).frames(k);
            cellnum = s.cell(j).bw_label(k);
            ob = frame(framenum).object(cellnum);
            if ob.on_edge==0 
                if isfield(ob,'cell_length') & numel(ob.cell_length)>0
                    length(k) = ob.cell_length;
                elseif isfield(ob,'MT_length') & numel(ob.MT_length)>0
                    length(k) = ob.MT_length;
                else
                    length(k) = NaN;
                end
            else
                length(k) = NaN;
            end
            time(k) = framenum;
        end

        length = length*sc;
        fi = find(~isnan(length));

        if numel(fi)>2
            count = count+1;
            ts = time-time(fi(1));
            
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
            length_curves{j} = NaN;
            time_curves{j} = NaN;
        end
        % compile into a bulk matrix
        %for l=numel(time)+1:20
        %    length(l) = NaN;
        %end
        %Mlength(count,:) = length(1:20);
    end
    hold off;
    
    %% replot all curves that pass filter
    maxres = 0.5;
    
    % loop over all curves to find out which ones pass the filter
    for j=1:numel(res)
        if ~isnan(length_curves{j})
            maxdiff(j) = max(abs(diff(length_curves{j}/length_curves{j}(1))));
        else
            maxdiff(j) = 1000000;
        end
    end
    
    
    fi = find(res'<maxres & betas(:,2)<300 & maxdiff'<0.1);

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
    scatter(betas(fi,1),betas(fi,2),10+100*(maxres-res(fi)'),res(fi)'/maxres*[1 ...
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
    pause;
end

% histograms of average growth rates
for q=1:numel(group)
    growth_rates{q} = [];
    gq = group{q};
    for j=1:numel(gq)
        growth_rates{q} = [growth_rates{q} beta_all{gq(j)}(:,2)'];
    end
end    
maxg = 0;
ming = 100000;
numbins = 100;
for j=1:numel(group)
    maxg = max(maxg,max(growth_rates{j}'));
    ming = min(ming,min(growth_rates{j}'));
end
for j=1:numel(group)
    [gt,nt] = hist(growth_rates{j},ming:(maxg-ming)/numbins:maxg);
    ghist{j} = gt;
    nhist{j} = nt;
    
    sumhist{j} = sum(gt);
    ghist{j} = ghist{j}/sumhist{j};
    meang(j) = nanmean(growth_rates{j});
    mediang(j) = median(growth_rates{j});
end

figure;
hold on;
for j=1:numel(group)
    if numel(group)>1
        c = c0+(c1-c0)*(j-1)/(numel(group)-1);
    else 
        c = 0.5*(c1+c0);
    end
    
    stairs(nhist{1},ghist{j}','Color',c);
    disp(j);
end
yl = ylim;

data.group_hist_growth = ghist;
data.group_hist_growth_values = nhist;

xlabel('Doubling time (min)');
ylabel('Frequency');
% draw averages
for j=1:numel(group)
    if numel(group)>1
        c = c0+(c1-c0)*(j-1)/(numel(group)-1);
    else 
        c = 0.5*(c1+c0);
    end

    plot(meang(j)*ones(1,2),yl,'Color',c,'LineWidth',2);
    plot(mediang(j)*ones(1,2),yl,'LineStyle',':','Color',c,'LineWidth',1.5);
end
hold off;
print('-dpdf','growth_rates.pdf');
