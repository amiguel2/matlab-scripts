function timelapse_singleplot(cs,varargin)
% Use: timelapse_singleplot(data,[optional] plotsave,fluor_on,lineage_on,tS,tF,save_plotplot_lineagefail)
% This function takes data structure from get_data and plots many parameters. Similar to
% timelapse_median except only looks at one data set.
% Default is to make all plots. Modify this string (remove, don't add) to change output. 
% plots = {'length','width','inst gr','avg gr','fit gr','dt','deltal','fluor','area','surfacearea','volume'};
% Created: 2016-12-12 by Amanda Miguel
% Modified: 2016-12-13
% Log:
% 2016-12-13 - added description, improved save pdf function so you can now
% specify what plots you want saved. 

close all

%%%%%%%%%%%%%%%%%%% default variables %%%%%%%%%%%%%%%%%%%
tmp = cellfun(@(x) x.time,cs,'UniformOutput',false);
tF = max([tmp{:}]);
tS = 0;
lineage_on = 1;
plot_lineagefail = 0;
save_plot = 1;
fluor_on = 0;
plotsave = 'strain';
defaultplots = {'length','width','inst gr','avg gr','fit gr','cmp-gr','dt','deltal','area','surfacearea','volume','fluor'};
numplots = [1:12];
plots = defaultplots;

%%%%%%%%%%%% input variables %%%%%%%%%%%%%%%%%%%
if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: timelapse_singleplot(data,[optional] plotsave,fluor_on,lineage_on,tS,tF,save_plotplot_lineagefail)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

%%%%%%%%%%%%%%%%%%% plot formatting %%%%%%%%%%%%%%%%%%%

% remove fluorescence if no fluor, from both default and actual plots
if ~fluor_on
    fidx = find(strcmp('fluor',defaultplots));
    defaultplots{fidx} = [];
    defaultplots = defaultplots(~cellfun('isempty', defaultplots));
    numplots = [1:11];
end

if ~fluor_on && sum(strcmp('fluor',plots))
    fidx = find(strcmp('fluor',plots));
    plots{fidx} = [];
    plots = plots(~cellfun('isempty', plots));
end

% compares plots to default plots if changed and will plot only the ones
% listed
noplotidx = [];
noplot = setdiff(defaultplots,plots);
for i = 1:numel(noplot)
    noplotidx = [noplotidx find(strcmp(noplot{i},defaultplots))];
end
plotidx = setdiff(numplots,noplotidx);

%%%%%%%%%%%%%%%%%%% Remove old pdfs %%%%%%%%%%%%%%%%%%%

if save_plot
    delete([plotsave 'results.pdf'])
end

%%%%%%%%%%%%%%%%%%% Main Code start %%%%%%%%%%%%%%%%%%%
close all;
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
all_a = [];
all_sa = [];
all_v = [];

% making figures
figure('Position',[0 500 300 250]) % length 1
figure('Position',[300 500 300 250]) % width 2
figure('Position',[600 500 300 250]) % instant. gr 3
figure('Position',[900 500 300 250]) % mean instant. gr 4
figure('Position',[0 250 300 250]) % fit gr 5
figure('Position',[300 250 300 250]) % fit gr vs mean gr. 6
figure('Position',[600 250 300 250]) % div time 7
figure('Position',[900 250 300 250]) % delta L 8
figure('Position',[0 0 300 250]) % area 9
figure('Position',[300 0 300 250]) % surface area 10
figure('Position',[600 0 300 250]) % volume 11

if fluor_on
    figure('Position',[900 0 300 250]) % fluor 12
end


for i = 1:numel(cs)
    % if lineage on, only lineage cells go in median. else, everything
    if lineage_on
        if cs{i}.lineage == 1
            all_length = [all_length cs{i}.length];
            all_time = [all_time cs{i}.time];
            all_width = [all_width cs{i}.width];
            all_lambda = [all_lambda cs{i}.instant_lambda];
            all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda)]; % average of instantaneous gr
            all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
            all_dt = [all_dt cs{i}.divtime];
            all_finalt = [all_finalt cs{i}.finalt];
            all_startt = [all_startt cs{i}.startt];
            all_deltal = [all_deltal cs{i}.deltalength];
            all_a = [all_a cs{i}.area];
            all_sa = [all_sa cs{i}.surfacearea];
            all_v = [all_v cs{i}.volume];
        end
    else
        all_length = [all_length cs{i}.length];
        all_time = [all_time cs{i}.time];
        all_width = [all_width cs{i}.width];
        all_lambda = [all_lambda cs{i}.instant_lambda];
        all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda)]; % average of instantaneous gr
        all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
        all_dt = [all_dt cs{i}.divtime];
        all_finalt = [all_finalt cs{i}.finalt];
        all_startt = [all_startt cs{i}.startt];
        all_deltal = [all_deltal cs{i}.deltalength];
        all_a = [all_a cs{i}.area];
        all_sa = [all_sa cs{i}.surfacearea];
        all_v = [all_v cs{i}.volume];
    end
    
    if fluor_on
        all_fluor = [all_fluor cs{i}.avg_fluor];
    end
    try
        all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)]; % fitted gr
    catch
        all_lambda_fit = [all_lambda_fit NaN];
    end

    %%% line plots %%%
    % length
    if sum(1 == plotidx)
        figure(1)
        if cs{i}.lineage == 1 || ~lineage_on
            plot(cs{i}.time,cs{i}.length,'Color',cs{i}.color,'UserData',i)
        else % if lineage_on but cs{1}.lineage == 0
            if plot_lineagefail
                plot(cs{i}.time,cs{i}.length,'Color',[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    end
    % width
    if sum(2 == plotidx)
        figure(2)
        if cs{i}.lineage == 1 || ~lineage_on
            plot(cs{i}.time,cs{i}.width,'Color',cs{i}.color,'UserData',i)
        else % if lineage_on but cs{1}.lineage == 0
            if plot_lineagefail
                plot(cs{i}.time,cs{i}.width,'Color',[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    end
    % instant gr. 
    if sum(3 == plotidx)
        figure(3)
        if cs{i}.lineage == 1 || ~lineage_on
            plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',cs{i}.color,'UserData',i)
        else % if lineage_on but cs{1}.lineage == 0
            if plot_lineagefail
                plot(cs{i}.time(1:end-1),cs{i}.instant_lambda,'Color',[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    end
    % area
    if sum(9 == plotidx)
        figure(9)
        if cs{i}.lineage == 1 || ~lineage_on
            plot(cs{i}.time,cs{i}.area,'Color',cs{i}.color,'UserData',i)
        else % if lineage_on but cs{1}.lineage == 0
            if plot_lineagefail
                plot(cs{i}.time,cs{i}.area,'Color',[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    end
    % surface area
    if sum(10 == plotidx)
        figure(10)
        if cs{i}.lineage == 1 || ~lineage_on
            plot(cs{i}.time,cs{i}.surfacearea,'Color',cs{i}.color,'UserData',i)
        else % if lineage_on but cs{1}.lineage == 0
            if plot_lineagefail
                plot(cs{i}.time,cs{i}.surfacearea,'Color',[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    end
    
    % volume
    if sum(11 == plotidx)
        figure(11)
        if cs{i}.lineage == 1 || ~lineage_on
            plot(cs{i}.time,cs{i}.volume,'Color',cs{i}.color,'UserData',i)
        else % if lineage_on but cs{1}.lineage == 0
            if plot_lineagefail
                plot(cs{i}.time,cs{i}.volume,'Color',[0.5 0.5 0.5],'UserData',i)
            end
        end
        hold on;
    end
    
    if fluor_on
        % fluor
        if sum(12 == plotidx)
            figure(12)
            if cs{i}.lineage == 1 || ~lineage_on
                plot(cs{i}.time,cs{i}.avg_fluor,'Color',cs{i}.color,'UserData',i)
            else % if lineage_on but cs{1}.lineage == 0
                if plot_lineagefail
                    plot(cs{i}.time,cs{i}.avg_fluor,'Color',[0.5 0.5 0.5],'UserData',i)
                end
            end
            hold on;
        end
    end
    
    %%% scatter plots %%%
    
    % avg inst. growthrate
    if sum(4 == plotidx)
        figure(4)
        if ~isnan(cs{i}.lambda.beta)
            if cs{i}.lineage == 1 || ~lineage_on
                scatter(cs{i}.time(1),nanmean(cs{i}.instant_lambda),50,cs{i}.color,'UserData',i)
            else
                if plot_lineagefail
                    scatter(cs{i}.time(1),nanmean(cs{i}.instant_lambda),50,[0.5 0.5 0.5],'UserData',i);
                end
            end
        end
        hold on;
    end
    
    % fitted growthrate
    if sum(5 == plotidx)
        figure(5)
        if ~isnan(cs{i}.lambda.beta)
            if cs{i}.lineage == 1 || ~lineage_on
                scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,cs{i}.color,'UserData',i)
            else
                if plot_lineagefail
                    scatter(cs{i}.time(1),cs{i}.lambda.beta(2),50,[0.5 0.5 0.5],'UserData',i);
                end
            end
        end
        hold on;
    end
    
    % fitted growthrate
    if sum(6 == plotidx)
        figure(6)
        if ~isnan(cs{i}.lambda.beta)
            if cs{i}.lineage == 1 || ~lineage_on
                scatter(nanmean(cs{i}.instant_lambda),cs{i}.lambda.beta(2),50,cs{i}.color,'UserData',i)
            else
                if plot_lineagefail
                    scatter(nanmean(cs{i}.instant_lambda),cs{i}.lambda.beta(2),50,[0.5 0.5 0.5],'UserData',i);
                end
            end
        end
        hold on;
    end
    
    % div time
    if sum(7 == plotidx)
        figure(7)
        if ~isnan(cs{i}.lambda.beta)
            if cs{i}.lineage == 1 || ~lineage_on
                scatter(cs{i}.time(1),nanmean(cs{i}.divtime),50,cs{i}.color,'UserData',i)
            else
                if plot_lineagefail
                    scatter(cs{i}.time(1),nanmean(cs{i}.divtime),50,[0.5 0.5 0.5],'UserData',i);
                end
            end
        end
        hold on;
    end

        % div time
        if sum(8 == plotidx)
            figure(8)
            if ~isnan(cs{i}.lambda.beta)
                if cs{i}.lineage == 1 || ~lineage_on
                    scatter(cs{i}.time(1),nanmean(cs{i}.deltalength),50,cs{i}.color,'UserData',i)
                else
                    if plot_lineagefail
                        scatter(cs{i}.time(1),nanmean(cs{i}.deltalength),50,[0.5 0.5 0.5],'UserData',i);
                    end
                end
            end
            hold on;
        end


end

figure(1)
if sum(1 == plotidx)
    plotmed(all_length,all_time)
    ylabel('Length (µm)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    ylim([1 9])
    xlim([tS tF])
    if save_plot
        export_fig('fig1.pdf')
        savefig([plotsave 'length.fig'])
    end
else
    close
end

figure(2)
if sum(2 == plotidx)
    plotmed(all_width,all_time)
    ylabel('Width (µm)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([0.5 2])
    xlim([tS tF])
    if save_plot
        export_fig('fig2.pdf')
        savefig([plotsave 'width.fig'])
    end
else
    close
end

figure(3)
if sum(3 == plotidx)
    plotmed(all_lambda,all_lamtime)
    ylabel('Inst. Growthrate','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([0.01 0.04])
    xlim([tS tF])
    if save_plot
        export_fig('fig3.pdf')
        savefig([plotsave 'inst-gr.fig'])
    end
else
    close
end

figure(4)
if sum(4 == plotidx)
    scattermed(all_avg_lambda,all_startt)
    ylabel('Mean Inst. Growthrate','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([0.01 0.04])
    xlim([tS tF])
    if save_plot
        export_fig('fig4.pdf')
        savefig([plotsave 'avginst-gr.fig'])
    end
else
    close
end

figure(5)
if sum(5 == plotidx)
    scattermed(all_lambda_fit,all_startt)
    ylabel('Fitted Growthrate','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([0.01 0.04])
    xlim([tS tF])
    if save_plot
        export_fig('fig5.pdf')
        savefig([plotsave 'fit-gr.fig'])
    end
else
    close
end

figure(6)
if sum(6 == plotidx)
    plot([0 1],[0 1],'black','LineWidth',2)
    ylabel('Fitted Growthrate','FontSize',20)
    xlabel('Mean Inst. Growthrate','FontSize',20)
    set(gcf,'color','white')
    ylim([0.01 0.04])
    xlim([0.01 0.04])
    if save_plot
        export_fig('fig6.pdf')
        savefig([plotsave 'cmp-gr.fig'])
    end
else
    close
end

figure(7)
if sum(7 == plotidx)
    scattermed(all_dt,all_startt)
    ylabel('Division Time','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([tS 40])
    xlim([tS tF])
    if save_plot
        export_fig('fig7.pdf')
        savefig([plotsave 'deltal.fig'])
    end
else
    close
end

figure(8)
if sum(8 == plotidx)
    scattermed(all_deltal,all_startt)
    ylabel('Delta Length','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([0 9])
    xlim([tS tF])
    if save_plot
        export_fig('fig8.pdf')
        savefig([plotsave 'dt.fig'])
    end
else
    close
end

figure(9)
if sum(9 == plotidx)
    scattermed(all_a,all_time)
    ylabel('Area (µm^2)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([1 11])
    xlim([tS tF])
    if save_plot
        export_fig('fig9.pdf')
        savefig([plotsave 'area.fig'])
    end
else
    close
end

figure(10)
if sum(10 == plotidx)
    scattermed(all_sa,all_time)
    ylabel('Surface Area (µm^2)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([5 30])
    xlim([tS tF])
    if save_plot
        export_fig('fig10.pdf')
        savefig([plotsave 'surfacearea.fig'])
    end
else
    close
end

figure(11)
if sum(11 == plotidx)
    scattermed(all_v,all_time)
    ylabel('Volume (µm^3)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    ylim([1 11])
    xlim([tS tF])
    if save_plot
        export_fig('fig11.pdf')
        savefig([plotsave 'volume.fig'])
    end
else
    close
end

if fluor_on
    figure(12)
    if sum(12 == plotidx)
        plotmed(all_fluor,all_time)
        ylabel('Fluorescence','FontSize',20)
        xlabel('Time (min)','FontSize',20)
        %ylim([300 350])
        xlim([tS tF])
        if save_plot
            export_fig('fig12.pdf')
            savefig([plotsave 'fluor.fig'])
        end
    else
        close
    end
end

if save_plot
    str1 = 'append_pdfs([plotsave ''results.pdf''],';
    str2 = 'delete(';
    for i = plotidx
        if i == plotidx(end)
            str1 = [str1 sprintf('''fig%d.pdf'')',i)];
            str2 = [str2 sprintf('''fig%d.pdf'')',i)];
        else
            str1 = [str1 sprintf('''fig%d.pdf'',',i)];
            str2 = [str2 sprintf('''fig%d.pdf'',',i)];
        end
    end
    
    eval(str1)
    eval(str2)

%     if fluor_on
%         append_pdfs([plotsave 'results.pdf'],'fig1.pdf','fig2.pdf','fig3.pdf','fig4.pdf','fig5.pdf','fig6.pdf','fig7.pdf','fig8.pdf','fig9.pdf','fig10.pdf','fig11.pdf','fig12.pdf')
%         delete('fig1.pdf','fig2.pdf','fig3.pdf','fig4.pdf','fig5.pdf','fig6.pdf','fig7.pdf','fig8.pdf','fig9.pdf','fig10.pdf','fig11.pdf','fig12.pdf')
%     else
%         append_pdfs([plotsave 'results.pdf'],'fig1.pdf','fig2.pdf','fig3.pdf','fig4.pdf','fig5.pdf','fig6.pdf','fig7.pdf','fig8.pdf','fig9.pdf','fig10.pdf','fig11.pdf')
%         delete('fig1.pdf','fig2.pdf','fig3.pdf','fig4.pdf','fig5.pdf','fig6.pdf','fig7.pdf','fig8.pdf','fig9.pdf','fig10.pdf','fig11.pdf')
%     end
end

end

function plotmed(param,time)
med_param = [];
for i = 1:max(time)
    idx = find(i == time);
    med_param = [med_param;[i,nanmedian(param(idx))]];
    hold on;
end
idx1 = ~isnan(med_param(:,2));
plot(med_param(idx1,1),med_param(idx1,2),'black','LineWidth',2,'LineStyle','--')

set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
set(gcf,'color','white')
end

function scattermed(param,time)
med_param = [];
for i = 1:max(time)
    idx = find(i == time);
    med_param = [med_param;[i,nanmedian(param(idx))]];
    scatter(i,nanmedian(param(idx)),10,'black','filled');
    hold on;
end
idx1 = ~isnan(med_param(:,2));
plot(med_param(idx1,1),med_param(idx1,2),'black','LineWidth',2,'LineStyle','--')
set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
set(gcf,'color','white')
end