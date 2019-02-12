function data = histogram_growthrates_AM(filelist,group,params)

% if filelist is a filename, then make filelist
if ischar(filelist)
    filelist = dir(filelist);
end

% make all plots start when the cell appears
if isfield(params,'shifttime')
    shifttime = params.shifttime;
else
    shifttime = 1;
end

% colors
c0 = params.color0; %[1 0 0];
c1 = params.color1; %[0 1 1];

% pixel size
sc = params.pxl_size;

% minarea
minarea = 500;

fprintf('\n');
% loop over all files

for q=1:numel(filelist)
    w = [];
    w_n = [];
    f = [];
    t = [];
    
    count = 0;
    fprintf('Analyzing file %s...\n',filelist(q).name);
    s = load(filelist(q).name);
    frame = s.frame;
    
    % process frames
    nc = numel(s.cell);

    clear Mlength;
    % loop over all cells
        
    for j=1:nc
        fprintf('Analyzing cell %d...\n',j);
        c = c0+(c1-c0)*(j-1)/(nc-1);
        clear Length time fluor_int prox;
        
        for k=1:numel(s.cell(j).frames)
            
            framenum = s.cell(j).frames(k);
            cellnum = s.cell(j).bw_label(k);
            ob = frame(framenum).object(cellnum);
            
            % ROC filter and rod-shape filter
            if params.roc_filter==1
                [test,not_rod] = test_roc(ob);
            else
                test = 1;
                not_rod = NaN;
            end
            
            if ob.on_edge==0 
                if isfield(ob,'mesh') & numel(ob.mesh)>0 & test==1
                    
                 m = ob.mesh;
                    distance = sqrt((m(:,3)-m(:,1)).^2 + (m(:,4)-m(:,2)).^2);
                    p = round(0.1*length(distance)); %20 in from the poles
                    m_d = mean(distance(p:length(distance)-p));
                    st = std(distance(p:length(distance)-p));
                    if isfield(ob,'width') & numel(ob.width)>0 & test==1 & ob.area>minarea & st < 0.1*ob.width
                        width(k) = ob.width;
                        Length(k) = ob.length;
                        if isfield(ob,'fluor_interior') & numel(ob.ave_fluor)>0 & test==1 & ob.area>minarea
                            fluor_int(k) = ob.ave_fluor;
                        else
                            fluor_int(k) = NaN;
                        end

                        if isfield(ob, 'area') & numel(ob.area)>0 & test==1 & ob.area>minarea
                           area(k) = ob.area;
                        else
                            area(k) = NaN;
                        end
                        if not_rod==0
                            not_rods(k) = 0;
                        else
                            not_rods(k) = 1;
                        end
                    else
                        Length(k) = NaN;
                        width(k) = NaN;
                        fluor_int(k) = NaN;
                        area(k) = NaN;
                        not_rods(k) = NaN;
                    end
                        
%                 if isfield(ob,'length') & numel(ob.length)>0 & test==1 & ob.area>minarea
%                     Length(k) = ob.length;
%                 elseif isfield(ob,'MT_length') & numel(ob.MT_length)>0 & test==1 & ob.area>minarea
%                     Length(k) = ob.MT_length;
%                 else
%                     Length(k) = NaN;
%                 end
                
%                 if isfield(ob,'width') & numel(ob.width)>0 & test==1 & ob.area>minarea
%                     width(k) = ob.width;
%                 elseif isfield(ob,'MT_width') & numel(ob.MT_width)>0 & test==1 & ob.area>minarea
%                     width(k) = ob.MT_width;
%                 else
%                     width(k) = NaN;
%                 end            
                else
                    Length(k) = NaN;
                    width(k) = NaN;
                    fluor_int(k) = NaN;
                    area(k) = NaN;
                    not_rods(k) = NaN;
                end

            else
                Length(k) = NaN;
                width(k) = NaN;
                fluor_int(k) = NaN;
                area(k) = NaN;
                not_rods(k) = NaN;
            end
            time(k) = framenum;
            if numel(ob.proxID)==0 
                prox(k) = 0;
            else
                prox(k) = 1;
            end
        end

        Length = Length*sc;
        width = width*sc;
        area = area*sc;
        fi = find(~isnan(Length)); 
        if numel(fi)>2 % make sure there are >=3 data points
            count = count+1; % count this as a tracked cell
            if shifttime
                ts = time-time(fi(1));
            else
                ts = time;
            end
            
            time_curves{j} = ts(fi);
            length_curves{j} = Length(fi);
            width_curves{j} = width(fi);
            area_curves{j} = area(fi);
            prox_curves{j} = prox;
            rod_curves{j} = not_rods(fi);
            
            
            % fit area curves
            beta = [area(fi(1)) 20];     
            [beta,r] = nlinfit(ts(fi),area(fi),@expfit,beta);
            
            %plot(time-time(1),expfit(beta,time-time(1))/beta(1),'Color',[0 0 0]);
            
            betas(j,:) = beta;
            res(j) = sqrt(sum(r.*r)/beta(1)^2);

        else
            length_curves{j} = [];
            width_curves{j} = [];
            area_curves{j} = [];
            prox_curves{j} = [];
            time_curves{j} = [];
            rod_curves{j} = [];
            betas(j,:) = [-1 0];
            res(j) = 1000000;
            
        end
        
        % make curves of fluor
        fii = find(~isnan(fluor_int)); 
        if numel(fii)>2
            
            fluor_curves{j} = fluor_int(fii);
            width_fluor_curves{j} = width(fii);
            if shifttime
                ts = time-time(fii(1));
            else
                ts = time;
            end
            
            fluor_time{j} = ts(fii);
        else
            
            fluor_curves{j} = [];
            width_fluor_curves{j} = [];
            fluor_time{j} = [];
        end
        
        % compile into a bulk matrix
        %for l=numel(time)+1:20
        %    Length(l) = NaN;
        %end
        %Mlength(count,:) = Length(1:20);
    end
    

    
    [path,name,ext] = fileparts(filelist(q).name);    
    
    

%plot growth curves    
    % area
%      figure;
%     %subplot(1,3,1);
%     hold on;
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi));
%         plot(time_curves{fi(j)},area_curves{fi(j)}/area_curves{fi(j)}(1),'Color',c,'LineWidth',0.5);
%     end
%     % overlay average
%    
%     average_area = expfit([1 mean(betas(fi,2))],0:30);
%     plot(0:30,average_area,'Color',[0 0 0],'LineWidth',2);
%     
%     hold off;
%     xlabel('Time (min)');
%     ylabel('Fractional growth');
%     title(['Growth curves for expt ',num2str(q)]);
%     xlim([0 30])
%     ylim([0.8 2.5]);
%     %print('-dpdf',[name,'_growth_curves_area',int2str(q),'.pdf']);
%     close
    
    
    %% make plots of width as a function of time
%     figure(1);
%     hold on;
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi));
%         plot(time_curves{fi(j)},smooth(width_curves{fi(j)},5),'Color',c);
%     end
%     hold off;
%     xlabel('Time (frames)');
%     ylabel('Width (um)');
%     hold off
%     %print('-dpdf',[name,'_width',int2str(q),'.pdf']);
%     
%     
     %% make plots of normalized width as a function of time
    %figure(1);
    %hold on;
 
    %xlabel('Time (min)');
    %ylabel('Fractional growth');
    %title(['Growth curves for expt ',num2str(q)]);
    %xlim([20 60])
    %ylim([0.5 3.5]);
    %print('-dpdf',[name,'_growth_curves_area',int2str(q),'.pdf']);
    
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
%         plot(time_curves{fi(j)},smooth(width_curves{fi(j)},5)/width_curves{fi(j)}(1),'Color',c);
%     end
    
    %average_width = expfit([1 mean(betasw(fiw,2))],0:60);
    %plot(0:60,average_width,'Color',[0 0 0],'LineWidth',2);
    
    
    %hold off;
%     xlabel('Time (frames)');
%     ylabel('Normalized width (um)');
    %print('-dpdf',[name,'_norm_width',int2str(q),'.pdf']);
    %close
    
    %% make plots of fluor and width as a function of time
%     figure(1);
%     hold on;
%     
%     for j=1:numel(fi)
%         nnn=numel(fluor_curves{fi(j)});
%         for k=2:nnn-1
%             fluor_rate{fi(j),1}(k) = (fluor_curves{fi(j)}(k+1) - fluor_curves{fi(j)}(k-1))/(time_curves{fi(j)}(k+1) - time_curves{fi(j)}(k-1));
%             width_change{fi(j),1}(k) = (width_curves{fi(j)}(k+1) - width_curves{fi(j)}(k-1))/(time_curves{fi(j)}(k+1) - time_curves{fi(j)}(k-1));
%         end
%         
%         fluor_rate{fi(j),1}(1) = NaN;
%         width_change{fi(j),1}(1) = NaN;
%         if nnn > 0
%             fluor_rate{fi(j),1}(nnn) = NaN;
%             width_change{fi(j),1}(nnn) = NaN;
%         end
%         fluor_rate{fi(j)} = fluor_rate{fi(j)}';
%         width_change{fi(j)} = width_change{fi(j)}';
%         
%     end
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
%         fi2 = find(~isnan(width_curves{fi(j)}));
%         maxf = max(fluor_curves{fi(j)});
%         minf = min(fluor_curves{fi(j)});
%         %        if numel(width_curves{fi(j)})==numel(fluor_curves{fi(j)}) & ...
%         %        numel(fi2)>12 & maxf>2*minf & prox_curves{fi(j)}(1)>=0
%         if numel(width_curves{fi(j)})==numel(fluor_curves{fi(j)}) & ...
%                 numel(fi2)>6 & maxf>1*minf & prox_curves{fi(j)}(1)==0
%             maxw = max(smooth(width_curves{fi(j)},5));
%             minw = min(smooth(width_curves{fi(j)},5));
%             smooth_width = smooth(width_curves{fi(j)},5);
%             %plot(smooth(width_curves{fi(j)},5),(fluor_curves{fi(j)}-minf)/(maxf-minf),'Color',c,'LineWidth',0.5);
%             colors{fi(j)} = rand(1,3);
%             lw{fi(j)} = 0.5+5*(smooth_width(1)-1)^2;
%             %plot(smooth(width_curves{fi(j)},5),(fluor_curves{fi(j)}/fluor_curves{fi(j)}(1)),'Color',colors{fi(j)},'LineWidth',lw{fi(j)});
%             %plot(smooth_width-smooth_width(1),(fluor_curves{fi(j)}-fluor_curves{fi(j)}(1)),'Color',colors{fi(j)},'LineWidth',lw{fi(j)});
%             %plot(smooth(width_curves{fi(j)},5),fluor_curves{fi(j)},'Color',c,'LineWidth',0.5);
%             
%             
%             try
%                 %plot(smooth(width_curves{fi(j)},5),(smooth(fluor_rate{fi(j)},5)),'Color',c,'LineWidth',0.5);
%                 %plot(smooth(width_change{fi(j)},5),(smooth(fluor_rate{fi(j)},5)),'Color',c,'LineWidth',0.5);
%                 %plot(smooth(width_change{fi(j)},5),smooth(fluor_rate{fi(j)},5),'Color',c,'LineWidth',0.5);
%             catch err
%             end
%                 
%             plot(smooth(width_curves{fi(j)},5),(fluor_curves{fi(j)}/fluor_curves{fi(j)}(1)),'Color',c,'LineWidth',0.5);
%             %plot(width_curves{fi(j)}/width_curves{fi(j)}(1),(fluor_curves{fi(j)}/fluor_curves{fi(j)}(1)),'Color',c,'LineWidth',0.5);
%             %plot((smooth(width_curves{fi(j)},5)-minw)/(maxw-minw),(fluor_curves{fi(j)}-minf)/(maxf-minf),'Color',c,'LineWidth',0.5);        
%         end
%     end
%     
%     hold off;
%     xlabel('Width (um)');
%     %ylabel('Normalized Fluorescence');
%     ylabel('Fluorescence');
% %     %print('-dpdf',[name,'_width_fluor',int2str(q),'.pdf']);
% 
%     
%     for j=1:numel(fi)
%         w = [w, width_curves{fi(j)}];
%         t = [t, time_curves{fi(j)}];
%         w_n = [w_n, width_curves{fi(j)}/width_curves{fi(j)}(1)];
%         f = [f,fluor_curves{fi(j)}/fluor_curves{fi(j)}(1)];    
%     end
%     
    
    
    % make plots of width vs FP rate of accumulation
   
    
    
    %% Length and fluor
    
%     figure;
%     hold on;
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
%         fi2 = find(~isnan(length_curves{fi(j)}));
%         maxf = max(fluor_curves{fi(j)});
%         minf = min(fluor_curves{fi(j)});
%         %        if numel(length_curves{fi(j)})==numel(fluor_curves{fi(j)}) & ...
%         %        numel(fi2)>12 & maxf>2*minf & prox_curves{fi(j)}(1)>=0
%         if numel(length_curves{fi(j)})==numel(fluor_curves{fi(j)}) & ...
%                 numel(fi2)>6 & maxf>1*minf & prox_curves{fi(j)}(1)==0
%             maxw = max(smooth(length_curves{fi(j)},5));
%             minw = min(smooth(length_curves{fi(j)},5));
%             smooth_length = smooth(length_curves{fi(j)},5);
%             %plot(smooth(length_curves{fi(j)},5),(fluor_curves{fi(j)}-minf)/(maxf-minf),'Color',c,'LineWidth',0.5);
%             %plot(smooth_length-smooth_length(1),(fluor_curves{fi(j)}-fluor_curves{fi(j)}(1)),'Color',colors{fi(j)},'LineWidth',lw{fi(j)});
%             %plot(smooth(length_curves{fi(j)},5),fluor_curves{fi(j)},'Color',c,'LineWidth',0.5);
%             %plot((smooth(length_curves{fi(j)},5)-minw)/(maxw-minw),(fluor_curves{fi(j)}-minf)/(maxf-minf),'Color',c,'LineWidth',0.5);        
%         end
%     end
%     hold off;
%     xlabel('Length (um)');
%     ylabel('Fluorescence (a.u.)');
%     %print('-dpdf',[name,'_length_fluor',int2str(q),'.pdf']);
%     close
%     
    %% make plots of fluor as a function of time
%     figure(1);
%     hold on;
%     for j=1:numel(fluor_curves)
%         c = c0+(c1-c0)*(j-1)/(numel(width_curves)-1);
%         if numel(fluor_time{j})>0
%             %plot(fluor_time{j},fluor_curves{j}/fluor_curves{j}(1), ...
%             %     'Color',c);
%             plot(fluor_time{j},fluor_curves{j},'Color',c);            
%         end
%     end
%    
%     %ylim([0.5 1]);
%     xlabel('Time (frames)');
%     ylabel('Fluoresence');
%     %print('-dpdf',[name,'_fluor',int2str(q),'.pdf']);
%     close
    
    %% make plots of fluor as a function of time
%     figure;
%     hold on;
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
%         if numel(fluor_time{fi(j)})>0
%             plot(fluor_time{fi(j)},fluor_curves{fi(j)}/fluor_curves{fi(j)}(1),'Color',c);
%         end
%     end
%     hold off;
%     %ylim([0.5 1]);
%     xlabel('Time (frames)');
%     ylabel('Fluoresence');
%     %print('-dpdf',[name,'_norm_fluor',int2str(q),'.pdf']);
%     close
    

%% Doubling time histogram
%     %subplot(1,3,2);
%     figure;
%     hist(betas(fi,2),10:2:60);
%     xlim([10 50]);
%     xlabel('Doubling time (min)');
%     ylabel('Number of cells');
%     % add average
%     mean_time(j) = mean(betas(fi,2));
%     title(['Mean doubling time = ',num2str(mean_time(j))]);
%     hold on;
%     yl = ylim;
%     plot([mean_time(j) mean_time(j)],[0 yl(2)],'Color',[0.5 0.5 0],'LineWidth',2);
%     %print('-dpdf',[name,'_doubling_times_hist',int2str(q),'.pdf']);
%     close
    
    %subplot(1,3,3);
    
%     %% growth rate scatter
%     figure;
%     scatter(betas(fi,1),betas(fi,2),10+100*(maxres-res(fi)'),res(fi)'/maxres*[1 ...
%                         1 1],'filled');
%     xlim([1 6]);
%     ylim([10 50]);
%     xlabel('Initial Length (um)');
%     ylabel('Growth rate (um/min)');
%     title('Size and color indicate goodness of fit');
%     %print('-dpdf',[name,'_scatter_length_doubling_times',int2str(q),'.pdf']);
%     close
    
    % save fits
    beta_all{q} = betas(fi,:);
    res_all{q} = res(fi);
    
    %[path,name,ext] = fileparts(filelist(q).name);
    %fileout = [name,'.pdf'];
    %    axis([0 20 1 2]);
    %print('-dpdf',fileout);
    
    %mean_length(q,:) = nanmean(Mlength);
    %    close all;

    % record data
data.length_curves = length_curves;
data.width_curves = width_curves;
data.width_fluor_curves = width_fluor_curves;
data.fluor_curves = fluor_curves;
data.fluor_time = fluor_time;
data.time_curves = time_curves;
data.prox_curves = prox_curves;
data.area_curves = area_curves;
data.rod_curves = rod_curves;
data.betas_exp = betas;
data.res_exp = res;
%data.fi = find(res'<maxres & betas(:,2)<300 & maxdiff'<0.1);
data.fi= fi;
%data.fif = fif;
data.params.roc_filter = params.roc_filter;
data.params.shifttime = params.shifttime;
data.params.pxl_size = params.pxl_size; % pixel scaling
data.params.color0 = params.color0; % colors for plotting lines
data.params.color1 = params.color1;

display(name)
save([name,'_data.mat'],'data');

end

%  mdl = LinearModel.fit(t,w);
%  figure(2);
%  hold on;
%  plot(mdl)
%  xlim([0,60]);
%  ylim([1,2])
%  hold off;
% 
%  figure(1);
%  hold on;
%  for i=1:60
%      avg_width(i) = predict(mdl,i);
%  end
%  plot(1:60,avg_width,'Color',[0 0 0],'LineWidth',2);
% hold off;

% figure(1);
% hold on;
% t_f = sort([t;f],2);
% x1 = find(t_f(1,:)==20.0,1,'first');
% x2 = size(t_f,2);
% mdl1 = LinearModel.fit(t_f(1,x1:x2),t_f(2,x1:x2));
% for i = 1:60
%     avg_fluor(i) = predict(mdl1,i);
% end
% plot(1:60,avg_fluor,'Color',[0 0 0],'LineWidth',2);
% hold off;

% figure(1);
% hold on;
% %w_f = sort([t;f],2);
% 
% mdl2 = LinearModel.fit(w_n,f);
% for i = 1:0.1:2
%     avg_w_f(i) = predict(mdl2,i);
% end
% plot(1:0.1:2,avg_w_f,'Color',[0 0 0],'LineWidth',2);
% hold off;






% histograms of average growth rates
% for q=1:numel(group)
%     growth_rates{q} = [];
%     gq = group{q};
%     for j=1:numel(gq)
%         growth_rates{q} = [growth_rates{q} beta_all{gq(j)}(:,2)'];
%     end
% end    
% maxg = 0;
% ming = 100000;
% numbins = 100;
% for j=1:numel(group)
%     maxg = max(maxg,max(growth_rates{j}'));
%     ming = min(ming,min(growth_rates{j}'));
% end
% for j=1:numel(group)
%     [gt,nt] = hist(growth_rates{j},ming:(maxg-ming)/numbins:maxg);
%     ghist{j} = gt;
%     nhist{j} = nt;
%     
%     sumhist{j} = sum(gt);
%     ghist{j} = ghist{j}/sumhist{j};
%     meang(j) = nanmean(growth_rates{j});
%     mediang(j) = median(growth_rates{j});
% end
% 
% figure;
% hold on;
% for j=1:numel(group)
%     if numel(group)>1
%         c = c0+(c1-c0)*(j-1)/(numel(group)-1);
%     else 
%         c = 0.5*(c1+c0);
%     end
%     
%     stairs(nhist{1},ghist{j}','Color',c);
%     disp(j);
% end
% yl = ylim;
% 
% data.group_hist_growth = ghist;
% data.group_hist_growth_values = nhist;
% 
% xlabel('Doubling time (min)');
% ylabel('Frequency');
% % draw averages
% for j=1:numel(group)
%     if numel(group)>1
%         c = c0+(c1-c0)*(j-1)/(numel(group)-1);
%     else 
%         c = 0.5*(c1+c0);
%     end
% 
%     plot(meang(j)*ones(1,2),yl,'Color',c,'LineWidth',2);
%     plot(mediang(j)*ones(1,2),yl,'LineStyle',':','Color',c,'LineWidth',1.5);
% end
% hold off;
% print('-dpdf','growth_rates.pdf');


