
function mediandata = plot_median_data(exp,expname,tS,tF,lineage_on,fluor_on,varargin)
c = [];
induction_switch = 0;
fluor_blank = 0;
tshift = zeros(1,numel(exp));
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

if fluor_on == 1
    N=2;
    M=3;
    figure('Color',[1 1 1],'Position', [100, 100, 1500, 600]);
else
    N = 1;
    M = 3;
    figure('Color',[1 1 1],'Position', [100, 100, 1200, 300]);
end


%% Median Comparisons

mediandata = struct();

% control
[c_all_length,c_all_time,c_all_width,~,~,~,~,~,~,~,~,c_all_fluor,~,~] = collect_data(exp{1},fluor_on,tshift(1));
for j = 1:numel(exp)
    if ~isempty(exp{j})
    cs = exp{j};
    if lineage_on
        idx = cell2mat(cellfun(@(X) X.lineage == 1,cs,'UniformOutput',false));
        cs = {cs{idx}};
    end
    
    %collect data
    [all_length,all_time,all_width,all_lambda,all_avg_lambda,all_lamtime,all_lambda_fit,all_dt,all_finalt,all_startt,all_deltal,all_fluor,all_area,all_fluor_lambda] = collect_data(cs,fluor_on,tshift(j));

    if isempty(c)
    colors = cs{1}.color;
    else
       colors = c(j,:);
    end
    
    % length
    subplot(N,M,1);hold on;
    [med_length,err_length] = get_median_param(all_length,all_time,min(all_time),-Inf,Inf);
    plot_med(med_length,err_length,colors,1);
    ylim([2 5]);
    ylimits = ylim;
%     plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')
    %width
    subplot(N,M,2); hold on;
    [med_width,err_width] = get_median_param(all_width,all_time,min(all_time),-Inf,Inf);
    [med_width_norm,err_width_norm] = get_median_param_norm(all_width,all_time,min(all_time),c_all_width,c_all_time);
    plot_med(med_width,err_width,colors,1);
%     plot_med(med_width_norm,err_width_norm,colors,1);
    ylimits = ylim;
%     plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')
    
    % growthrate
    subplot(N,M,3); hold on;
%      [median_growthrate,err_growthrate] = get_median_param(all_lambda_fit,all_startt,min(all_startt),-0.02,0.03);
     [median_growthrate,err_growthrate] = get_median_param(all_lambda,all_lamtime,min(all_time),-Inf,Inf);%,-0.02,0.03);
    plot_med(median_growthrate,err_growthrate,colors,0);
     ylim([0.01 0.04])
    ylimits = ylim;
%     plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')
    %fluor
    if fluor_on
        subplot(N,M,4); hold on;
         [med_fluor,err_fluor] = get_median_param(all_fluor-fluor_blank,all_time,min(all_time),-Inf,Inf);
         [med_fluor_norm,err_fluor_norm] = get_median_param_norm(all_fluor,all_time,min(all_time),c_all_fluor,c_all_time);
%          plot_med(med_fluor_norm,err_fluor_norm,colors,1);
         plot_med(med_fluor,err_fluor,colors,1);

    % fluor v width
    subplot(N,M,5); hold on;
[median_growthrate,err_growthrate] = get_median_param(all_fluor_lambda,all_lamtime,min(all_time),-Inf,Inf);%,-0.02,0.03);
    plot_med(median_growthrate,err_growthrate,colors,0);
        ylimits = ylim;
        %     plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')
    
    % fluor v width
    subplot(N,M,6); hold on;
    plot_med2(med_fluor,err_fluor,med_width_norm,err_width_norm,colors,1);
    
    end
    
    % delta L
%     subplot(N,M,5); hold on;
%     [med_dl,err_dl] = get_median_param(all_deltal,all_startt,min(all_startt),-Inf,Inf);
%     plot_med(med_dl,err_dl,colors,1);
%     ylimits = ylim;
%     plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')

    % divtime
%     subplot(N,M,6); hold on;
%     
%     idx = find(all_finalt < 18 | all_finalt>96);
%     all_dt(idx) = NaN;
%     [med_dt,err_dt] = get_median_param(all_dt,all_startt,min(all_startt),-Inf,Inf);
%     plot_med(med_dt,err_dt,colors,1);
%     ylimits = ylim;
%     plot(ones(1,2)*induction_switch,[ylimits(1) ylimits(2)],'LineStyle',':','Color','black')


% if fluor_on
%     
% %     plot_med2(f,err_fluor_norm,med_width_norm,err_width_norm,colors,1);
% %     ylimits = ylim;
% %     [median_flgrowthrate,err_flgrowthrate] = get_median_param(all_fluor_lambda,all_lamtime,min(all_time),-Inf,Inf);
% %     plot_med(median_flgrowthrate,err_flgrowthrate,colors,0);
% 
% end

    % data storage
    
    mediandata.(expname{j}).l = med_length(~isnan(med_length(:,2)),:);
    mediandata.(expname{j}).w = med_width(~isnan(med_width(:,2)),:);
    mediandata.(expname{j}).w_norm = med_width_norm(~isnan(med_width_norm(:,2)),:);
    mediandata.(expname{j}).gr = median_growthrate(~isnan(median_growthrate(:,2)),:);
%     mediandata.(expname{j}).dl = med_dl(~isnan(med_dl(:,2)),:);
%     mediandata.(expname{j}).dt = med_dt(~isnan(med_dt(:,2)),:);
    mediandata.(expname{j}).e_l = err_length(~isnan(err_length(:,2)),:);
    mediandata.(expname{j}).e_w = err_width(~isnan(err_width(:,2)),:);
    mediandata.(expname{j}).e_gr = err_growthrate(~isnan(err_growthrate(:,2)),:);
%     mediandata.(expname{j}).e_dl = err_dl(~isnan(err_dl(:,2)),:);
%     mediandata.(expname{j}).e_dt = err_dt(~isnan(err_dt(:,2)),:);
    
    end
end

subplot(N,M,1)
% legend([h(1),h(2),h(3),h(4)],'Empty','WT','Peri','IM')
ylabel('Length (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([0 tF])
% ylim([2 10])
ylimits = ylim;
h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')
 

subplot(N,M,2)
ylabel('Width (µm)')
% ylabel('Normalized Width (µm)')
xlabel('Time (min)')
set(gcf,'color','white')
% ylim([1.1 1.8])
xlim([0 tF])
ylimits = ylim;
h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')

subplot(N,M,3)
ylabel('Median Instantaneous Growthrate')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([tS tF])
%ylim([-0.01 0.06])
%ylim([0.02 0.04])
% ylim([0.01 0.04])
ylimits = ylim;
h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')

if fluor_on
subplot(N,M,4)
ylabel('Fluorescence (A.U)')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([0 tF])
ylimits = ylim;
h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')

subplot(N,M,5)
ylabel('Fluorescence rate (min-1)')
xlabel('Time (min)')
set(gcf,'color','white')
xlim([0 tF])
ylimits = ylim;
h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')
subplot(N,M,6)

%  ylabel('Normalized Fluorescence (A.U)')
ylabel('Fluorescence (A.U)')
xlabel('Width (uM)')
set(gcf,'color','white')
% ylim([0 10])
% xlim([0 tF])
% ylimits = ylim;
h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
set(h,'EdgeColor','none')

end
% subplot(N,M,5)
% ylabel('Delta Length (µm)')
% xlabel('Time (min)')
% set(gcf,'color','white')
% xlim([0 tF])
% % ylim([2 8])
% ylimits = ylim;
% h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
% set(h,'EdgeColor','none')

% subplot(N,M,6)
% ylabel('Division Time (min)')
%  xlabel('Time (min)')
% % ylabel('Fluorescence rate (A.U)')
% % xlabel('Width (µm)')
% set(gcf,'color','white')
% % xlim([0 tF])
% % ylim([2 8])
% ylimits = ylim;
% h = fill([0 0 induction_switch induction_switch],[ylimits(1) ylimits(2) ylimits(2) ylimits(1)],[0.5 0.5 0.5],'FaceAlpha',0.1,'EdgeColor',[1 1 1]);
% set(h,'EdgeColor','none')

end

function [med_param,err_param] = get_median_param(all_param,all_t,startt,filt1,filt2)
    med_param = [];
    err_param = [];
    for i = startt:max(all_t)
        idx = find(i == all_t);
        temp1 = all_param(idx);
        idx1 = find(temp1 > filt1 & temp1 < filt2);
        med_param = [med_param;[i,nanmedian(double(temp1(idx1)))]];
        %          err_param = [err_param; [i,nanstd(double(all_param(idx)))]];
        err_param = [err_param; [i,nanstd(temp1(idx1))/sqrt(numel(idx1))]];
    end
end

function [med_param,err_param] = get_median_param_norm(all_param,all_t,startt,norm_param,norm_t)
    med_param = [];
    err_param = [];
    med_param_norm = [];
    err_param_norm = [];
    % control
    for i = startt:max(norm_t)
        idx = find(i == norm_t);
        med_param_norm = [med_param_norm;[i,nanmedian(double(norm_param(idx)))]];
        err_param_norm = [err_param_norm; [i,nanstd(double(norm_param(idx)))/sqrt(numel(idx))]];
    end
    % param
    count = 1;
    for i = startt:max(all_t)
        idx = find(i == all_t);
        idx1 = find(i == med_param_norm(:,1));
        if idx1
            med_param = [med_param;[i,nanmedian(double(all_param(idx))/med_param_norm(idx1,2))]];
            err_param = [err_param; [i,nanstd(double(all_param(idx))/med_param_norm(idx1,2))/sqrt(numel(idx))]];
        else
            med_param = [med_param;[i,NaN]];
            err_param = [err_param; [i,NaN]];
        end
%          err_param = [err_param; [i,nanstd(all_param(idx))/sqrt(numel(idx))]];
    end
end

function plot_med(med_param,err_param,colors,sm)
    idx1 = ~isnan(med_param(:,2));
    if sm
        med_paramy =smooth(med_param(idx1,2) );
    else
        med_paramy =med_param(idx1,2);
    end
    
    xlen = med_param(idx1,1);
    yupperbound = med_paramy+(err_param(idx1,2)/2);
    ylowerbound = med_paramy-(err_param(idx1,2)/2);
    c = colors + 0.3;
    c(c > 1) = 1;
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],c,'FaceAlpha',0.2,'EdgeColor','none');
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    plot(med_param(idx1,1),med_paramy,'Color',colors,'LineWidth',2);
end

function plot_med2(med_param1,err_param1,med_param2,err_param2,colors,sm)
    idx1 = ~isnan(med_param1(:,2)) & ~isnan(med_param2(:,2)) & ~isnan(err_param1(:,2)) &~isnan(err_param2(:,2));
    idx2 = idx1;
    
    if sm
        med_paramy =smooth(med_param1(idx1,2) );
        med_paramx = smooth(med_param2(idx2,2) );
    else
        med_paramy =med_param1(idx1,2);
        med_paramx =med_param2(idx2,2);
    end
    
    yupperbound = med_paramy+(err_param1(idx1,2)/2);
    ylowerbound = med_paramy-(err_param1(idx1,2)/2);
    xupperbound = med_paramx+(err_param2(idx2,2)/2);
    xlowerbound = med_paramx-(err_param2(idx2,2)/2);
    c = colors + 0.3;
    c(c > 1) = 1;
    p = patch([xlowerbound; flip(xupperbound)],[ylowerbound;flip(yupperbound)],c,'FaceAlpha',0.2,'EdgeColor','none');
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    plot(med_paramx,med_paramy,'Color',colors,'LineWidth',2);
end

function [all_length,all_time,all_width,all_lambda,all_avg_lambda,all_lamtime,all_lambda_fit,all_dt,all_finalt,all_startt,all_deltal,all_fluor,all_area,all_fluor_lambda] = collect_data(cs,fluor_on,tshift)
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
    all_area = [];
    all_fluor_lambda = [];
    for i = 1:numel(cs)
        if fluor_on
            all_fluor = [all_fluor cs{i}.tot_fluor];
%               all_fluor = [all_fluor cs{i}.norm_avg_fluor];
        end
        all_area = [all_area cs{i}.area];
        all_length = [all_length cs{i}.length];
        all_time = [all_time cs{i}.time+tshift];
        all_width = [all_width cs{i}.width];
        all_lambda = [all_lambda cs{i}.instant_lambda_V];
        try
            all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)];
        catch
            all_lambda_fit = [all_lambda_fit NaN];
        end
        all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda_length)];
        
        all_lamtime = [all_lamtime cs{i}.time(1:end-1)+tshift];
        
        all_dt = [all_dt cs{i}.divtime];
        
        all_finalt = [all_finalt cs{i}.finalt+tshift];
        all_startt = [all_startt cs{i}.startt+tshift];
        
        all_deltal = [all_deltal cs{i}.deltalength];
        
        all_fluor_lambda = [all_fluor_lambda cs{i}.instant_lambda_fluor];
    end
end