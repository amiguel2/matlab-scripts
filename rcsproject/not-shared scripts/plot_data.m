function  [all_length,all_time,all_deltalength,all_avg_lambda,all_lambda_t,all_cid,finalt,startt,cell_marker]=plot_data(f,tframe,pxl,plots)
% plots the data for a loaded contour file

if ~isstruct(f)
    if iscell(f)
        plotsave = f{1:end-25};
    else
        plotsave = f(1:end-25);
    end
    f = load(f);
elseif isfield(f,'directory')
    temp = strsplit(f.directory,'/');
    temp = strsplit(temp{end},'.');
    plotsave=temp{1};
else
    plotsave = strsplit(f.outname,'/');
    plotsave = plotsave{end};
    plotsave = plotsave(1:end-25);
end

%tframe = 2;
%pxl = 0.08;
c1=[0 1 1];
c2 =[1 0 0];


%%
maxt = numel(f.frame)*tframe;
all_avg_lambda = [];
all_dt = [];
finalt = [];
startt = [];
all_lambda = [];
all_lambda_t = [];
all_length = [];
all_deltalength = [];
all_time = [];
all_cid = [];
cell_marker = []; % find individual cells in a combined array (all length, time, etc. )


f1 = figure(1);
f2 = figure(2);
f3 = figure(3);
f4 = figure(4);
f5 = figure(5);
for cid = 1:numel(f.cells)
    [l,t] = splitcells(f,cid);
    if ~isempty(l) && ~iscell(l)
        l_temp = l*pxl;
        t_temp = t*tframe;
        all_length = [all_length l_temp];
        all_deltalength = [all_deltalength l_temp(end) - l_temp(1)];
        all_time = [all_time t_temp];
        cell_marker_temp = zeros(1,numel(l_temp));
        cell_marker_temp(1) = 1;
        cell_marker = [cell_marker cell_marker_temp];
        c = c1 + (c2-c1)*double(t_temp(1))/double(maxt);
        
        if plots
            figure(f1)
            plot(t_temp,l_temp,'Color',c)
            hold on;
            %text(t(1),l(1),int2str(cid))
            figure(f5)
            scatter(t_temp(end),l_temp(end) - l_temp(1),50,c,'filled')
            hold on;
        end
        smoothl = smooth(l_temp)';
        lambda = log(smoothl(2:end)./smoothl(1:end-1))./double(diff(t_temp));
        
        if plots
            figure(f2);
            plot(t_temp(1:end-1),lambda,'Color',c)
            hold on;
        end
        
        divtime = t_temp(end)-t_temp(1);
        
        if plots
            figure(f3)
            scatter(t_temp(end),divtime,50,c,'filled')
            hold on;
        end
        %text(t(end),divtime,int2str(cid))
        all_cid = [all_cid cid];
        startt = [startt t_temp(1)];
        all_lambda = [all_lambda lambda];
        all_lambda_t = [all_lambda_t t_temp(1:end-1)];
        all_avg_lambda = [all_avg_lambda mean(lambda)];
        all_dt = [all_dt divtime];
        finalt = [finalt t_temp(end)];
    else
        n = numel(l);
        for k = 1:n
            if ~isempty(l{k})
                l_temp = l{k}*pxl;
                t_temp = double(t{k}*tframe);
                all_length = [all_length l_temp];
                all_deltalength = [all_deltalength l_temp(end) - l_temp(1)];
                all_time = [all_time t_temp];
                cell_marker_temp = zeros(1,numel(l_temp));
                cell_marker_temp(1) = 1;
                cell_marker = [cell_marker cell_marker_temp];
                c = c1 + (c2-c1)*(t_temp(1)/maxt);
                if plots
                    figure(f1)
                    plot(t_temp,l_temp,'Color',c)
                    hold on;
                    figure(f5)
                    scatter(t_temp(end),l_temp(end) - l_temp(1),50,c,'filled')
                    hold on;
                end
                %text(t(1),l(1),int2str(cid))
                
                smoothl = smooth(l_temp)';
                lambda = log(smoothl(2:end)./smoothl(1:end-1))./diff(t_temp);
                if plots
                    figure(f2);
                    plot(t_temp(1:end-1),lambda,'Color',c)
                    
                    hold on;
                end
                %text(t(1),lambda(1),int2str(cid))
                
                divtime = t_temp(end)-t_temp(1);
                if plots
                    figure(f3)
                    scatter(t_temp(end),divtime,50,c,'filled')
                    hold on;
                end
                %text(t(end),divtime,int2str(cid))
                all_cid = [all_cid cid];
                startt = [startt t_temp(1)];
                all_lambda = [all_lambda lambda];
                all_lambda_t = [all_lambda_t t_temp(1:end-1)];
                all_avg_lambda = [all_avg_lambda mean(lambda)];
                all_dt = [all_dt divtime];
                finalt = [finalt t_temp(end)];
            end
        end
    end
end

% errors for microbej outputs because of type changes. Some values are
% int16 instead of double;
all_dt = double(all_dt);
all_time = double(all_time);
finalt = double(finalt);
all_lambda_t = double(all_lambda_t);

if plots
    figure(f4)
    
    for j = 1:numel(startt)
        c = c1 + (c2-c1)*(double(startt(j))/double(maxt));
        scatter(all_dt(j),log(2)./all_avg_lambda(j),50,c,'filled')
        hold on;
        %text(all_dt(j),log(2)./all_lambda(j),int2str(all_cid(j)))
    end
    Xlim = xlim;
    Ylim = ylim;
    m = max(max(Xlim),max(Ylim));
    plot([0 m],[0,m])
    xlim(Xlim)
    ylim(Ylim)
    xlabel('Division Time (min)')
    ylabel('Estimated Division Time from lambda')
    set(gcf,'color','white')
    export_fig([plotsave 'grvsdt.pdf'])
    
    figure(1)
    for i = tframe:tframe:maxt
        idx = find(i == all_time);
        scatter(i,median(all_length(idx)),50,[0 0 0],'filled')
    end
    ylabel('Length (µm)')
    xlabel('Time (min)')
    set(gcf,'color','white')
    ylim([0 8])
    export_fig([plotsave 'length.pdf'])
    
    figure(2)
    for i = tframe:tframe:maxt
        idx = find(i == all_lambda_t);
        scatter(i,median(all_lambda(idx)),50,[0 0 0],'filled')
    end
    ylabel('Instantaneous Growthrate')
    xlabel('Time (min)')
    set(gcf,'color','white')
    ylim([-0.01 0.06])
    export_fig([plotsave 'growthrate.pdf'])
    
    figure(3)
    for i = tframe:tframe:maxt
        idx = find(i == all_dt);
        scatter(i,median(all_dt(idx)),50,[0 0 0],'filled')
    end
    xlabel('Final Time (min)')
    ylabel('Division Time t(f)-t(i) (min)')
    set(gcf,'color','white')
    export_fig([plotsave 'divisiontime.pdf'])
    
    figure(5)
    
    for i = tframe:tframe:maxt
        idx = find(i == finalt);
        scatter(i,median(all_deltalength(idx)),50,[0 0 0],'filled')
    end
    ylabel('Delta Length (µm)')
    xlabel('Time (min)')
    set(gcf,'color','white')
    ylim([-2 6])
    export_fig([plotsave 'deltalength.pdf'])
    
    %%
    figure(6)
    hist_transparent(all_avg_lambda,100,[0 1 0])
    hold on;
    plot(ones(1,2)*nanmedian(all_avg_lambda),[0 0.25],':','Color',[0 1 0])
    xlabel('Average Growthrate')
    xlim([-0.01 0.06])
    export_fig([plotsave 'hist-avggrowthrate.pdf'])
    close
    %
    figure(6)
    hist_transparent(all_dt,25,[0 1 0])
    hold on;
    plot(ones(1,2)*nanmedian(all_dt),[0 0.15],':','Color',[0 1 0])
    xlabel('Division Time')
    export_fig([plotsave 'hist-divisiontime.pdf'])
    close
    %
    figure(6)
    idx = find(all_time == maxt);
    N = round(sqrt(numel(all_time(idx))));
    [k_count,k_center] = hist(all_length(idx),N);
    
    xbins = linspace(0,10,N*2);
    kymo = zeros(maxt,N*2);
    for i = tframe:tframe:maxt
        idx = find(i == all_time);
        [k_count,k_center] = hist(all_length(idx),xbins);
        if ~isempty(k_count)
            kymo(i/2,:)= smooth(k_count,5);
        end
    end
    kymo = kymo(find(sum(kymo,2)>0),:);
    imagesc([tframe maxt],[0,10],kymo');
    colormap(hot);
    colorbar;
    set(gca,'Ydir','normal')
    xlabel('Time (min)')
    ylabel('Length µm')
    set(gcf,'color','white')
    export_fig([plotsave 'kymolength.pdf'])
    close
    
    figure(6)
    idx = find(all_lambda_t == maxt);
    N = round(sqrt(numel(all_lambda_t(idx))));
    [k_count,k_center] = hist(all_lambda(idx),N);
    if N
        xbins = linspace(0,0.06,N*2);
        kymo = zeros(maxt,N*2);
        for i = tframe:tframe:maxt
            idx = find(i == all_lambda_t);
            [k_count,k_center] = hist(all_lambda(idx),xbins);
            kymo(i/2,:)= smooth(k_count,5);
        end
        kymo = kymo(find(sum(kymo,2)>0),:);
        imagesc([2 maxt],[0,0.06],kymo');
        colormap(hot);
        colorbar;
        set(gca,'Ydir','normal')
        xlabel('Time (min)')
        ylabel('Growthrate µm')
        set(gcf,'color','white')
        export_fig([plotsave 'kymogrowthrate.pdf'])
    end
    close
    
    
    %
    figure(6)
    idx = find(finalt == maxt);
    N = round(sqrt(numel(finalt(idx))));
    if N
        [k_count,k_center] = hist(all_dt(idx),N);
        
        xbins = linspace(0,45,N*2);
        kymo = zeros(maxt,N*2);
        for i = tframe:tframe:maxt
            idx = find(i == finalt);
            [k_count,k_center] = hist(all_dt(idx),xbins);
            kymo(i/2,:)= smooth(k_count,5);
        end
        kymo = kymo(find(sum(kymo,2)>0),:);
        imagesc([tframe maxt],[0,45],kymo');
        colormap(hot);
        colorbar;
        set(gca,'Ydir','normal')
        xlabel('Final Time point of cell (min)')
        ylabel('Division Time (min)')
        set(gcf,'color','white')
        export_fig([plotsave 'kymodivision-time.pdf'])
    end
    close
    
    idx = find(finalt == maxt);
    N = round(sqrt(numel(finalt(idx))));
    if N
        [k_count,k_center] = hist(all_deltalength(idx),N);
        
        xbins = linspace(-2,6,N*2);
        kymo = zeros(maxt,N*2);
        for i = tframe:tframe:maxt
            idx = find(i == finalt);
            [k_count,k_center] = hist(all_deltalength(idx),xbins);
            kymo(i/2,:)= smooth(k_count,5);
        end
        kymo = kymo(find(sum(kymo,2)>0),:);
        imagesc([tframe maxt],[-2,6],kymo');
        colormap(hot);
        colorbar;
        set(gca,'Ydir','normal')
        xlabel('Final Time point of cell (min)')
        ylabel('Delta Length (µm)')
        set(gcf,'color','white')
        export_fig([plotsave 'kymodeltalength.pdf'])
    end
    close
    
end



end