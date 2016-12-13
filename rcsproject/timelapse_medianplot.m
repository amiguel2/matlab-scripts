function timelapse_medianplot(exp,varargin)
% Use: timelapse_medianplot({data1,data2,...},[optional] plotsave,leg,lineage_on,fluor_on,tS,tF)
% This function takes data structure from get_data and plots the median
% values of multiple datasets on the same plot. similar to
% timelapse_singleplot except overlaps the medians
% Created: 2016-12-13 by Amanda Miguel
% Modified: -

close all

%%%%%%%%%%%%%%%%%%% default variables %%%%%%%%%%%%%%%%%%%
oldmax = -Inf;
for i = 1:numel(exp)
    tmp = cellfun(@(x) x.time,exp{i},'UniformOutput',false);
    tF = max(oldmax,max([tmp{:}]));
    oldmax = max([tmp{:}]);
end
tS = 0;
lineage_on = 1;
fluor_on = 0;
plotsave = 'experiment';
defaultplots = {'length','width','inst gr','avg gr','fit gr','dt','deltal','area','surfacearea','volume','fluor'};
numplots = [1:11];
plots = defaultplots;
save_plot = 1;

leg = {};
for i = 1:numel(exp)
    leg = [leg sprintf('St%d',i)];
end

%%%%%%%%%%%% input variables %%%%%%%%%%%%%%%%%%%
if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: timelapse_medianplot({data1,data2,...},[optional] plotsave,leg,lineage_on,fluor_on,tS,tF)\n')
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
    numplots = [1:10];
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

delete([plotsave '-median.pdf'])

%%%%%%%%%%%%%%%%%%% Main Code start %%%%%%%%%%%%%%%%%%%
% making figures
figure('Position',[0 500 300 250]) % length 1
figure('Position',[300 500 300 250]) % width 2
figure('Position',[600 500 300 250]) % instant. gr 3
figure('Position',[900 500 300 250]) % mean instant. gr 4
figure('Position',[0 250 300 250]) % fit gr 5
figure('Position',[300 250 300 250]) % div time 6
figure('Position',[600 250 300 250]) % delta L 7
figure('Position',[900 250 300 250]) % area 8
figure('Position',[0 0 300 250]) % surface area 9
figure('Position',[300 0 300 250]) % volume 10

if fluor_on
    figure('Position',[600 0 300 250]) % fluor 11
end

for j = 1:numel(exp)
    cs = exp{j};
    
    % only want passing lineage, no options to plot non-lineage if this is
    % on. 
    if lineage_on
        idx = cell2mat(cellfun(@(X) X.lineage == 1,cs,'UniformOutput',false));
        cs = {cs{idx}};
    end
    
    %empty variables
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
    
    %populate variables
    for i = 1:numel(cs)
        if fluor_on
            all_fluor = [all_fluor cs{i}.avg_fluor];
        end
        all_length = [all_length cs{i}.length];
        all_time = [all_time cs{i}.time];
        all_width = [all_width cs{i}.width];
        all_lambda = [all_lambda cs{i}.instant_lambda];
        try
            all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)];
        catch
            all_lambda_fit = [all_lambda_fit NaN];
        end
        all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda)];
        all_lamtime = [all_lamtime cs{i}.time(1:end-1)];
        all_dt = [all_dt cs{i}.divtime];
        all_finalt = [all_finalt cs{i}.finalt];
        all_startt = [all_startt cs{i}.startt];
        all_deltal = [all_deltal cs{i}.deltalength];
        all_a = [all_a cs{i}.area];
        all_sa = [all_sa cs{i}.surfacearea];
        all_v = [all_v cs{i}.volume];
    end
    colors = cs{1}.color;
    
    
    % length
    if sum(1 == plotidx)
        figure(1)
        if j == 1
            h1 = plotmedfirst(all_length,all_time,j,colors);
        else
            h1 = plotmed(all_length,all_time,h1,j,colors);
        end
    end
    
    %width
    if sum(2 == plotidx)
        figure(2)
        if j == 1
            h2 = plotmedfirst(all_width,all_time,j,colors);
        else
            h2 = plotmed(all_width,all_time,h2,j,colors);
        end
    end
    
    %inst gr
    if sum(3 == plotidx)
        figure(3)
        if j == 1
            h3 = plotmedfirst(all_lambda,all_lamtime,j,colors);
        else
            h3 = plotmed(all_lambda,all_lamtime,h3,j,colors);
        end
    end
    
    % avg growthrate
    if sum(4 == plotidx)
        figure(4)
        if j == 1
            h4 = plotmedfirst(all_avg_lambda,all_startt,j,colors);
        else
            h4 = plotmed(all_avg_lambda,all_startt,h4,j,colors);
        end
    end
    
    % fit growthrate
    if sum(5 == plotidx)
        figure(5)
        if j == 1
            h5 = plotmedfirst(all_lambda_fit,all_startt,j,colors);
        else
            h5 = plotmed(all_lambda_fit,all_startt,h5,j,colors);
        end
    end
    
    % division time
    if sum(6 == plotidx)
        figure(6)
        if j == 1
            h6 = plotmedfirst(all_dt,all_startt,j,colors);
        else
            h6 = plotmed(all_dt,all_startt,h6,j,colors);
        end
    end
    
    % deltaL
    if sum(7 == plotidx)
        figure(7)
        if j == 1
            h7 = plotmedfirst(all_deltal,all_startt,j,colors);
        else
            h7 = plotmed(all_deltal,all_startt,h7,j,colors);
        end
    end
    
    % area
    if sum(8 == plotidx)
        figure(8)
        if j == 1
            h8 = plotmedfirst(all_a,all_time,j,colors);
        else
            h8 = plotmed(all_a,all_time,h8,j,colors);
        end
    end
    
    % surface area
    if sum(9 == plotidx)
        figure(9)
        if j == 1
            h9 = plotmedfirst(all_sa,all_time,j,colors);
        else
            h9 = plotmed(all_sa,all_time,h9,j,colors);
        end
    end
    
    % volume
    if sum(10 == plotidx)
        figure(10)
        if j == 1
            h10 = plotmedfirst(all_v,all_time,j,colors);
        else
            h10 = plotmed(all_v,all_time,h10,j,colors);
        end
    end
    
    %fluor
    if fluor_on
        if sum(11 == plotidx)
            figure(11)
            %subplot(2,2,4)
            if j == 1
                h11 = plotmedfirst(all_fluor,all_time,j,colors);
            else
                h11 = plotmed(all_fluor,all_time,h11,j,colors);
            end
        end
    end
    
end

%%%%%%%%%%% plot formatting %%%%%%%%%%%%%%%%%

% length
figure(1)
if sum(1 == plotidx)
    setlabels(h1,leg)
    ylabel('Length (µm)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylim([1 9])
    xlim([tS tF])
    if save_plot
        export_fig('fig1.pdf')
        savefig([plotsave 'length.fig'])
    end
else
    close
end

% width
figure(2)
if sum(2 == plotidx)
    setlabels(h2,leg)
    ylabel('Width (µm)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
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
    ylabel('Inst. Growthrate','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h3,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
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
    ylabel('Mean Inst. Growthrate','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h4,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
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
    ylabel('Fitted Growthrate','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h5,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
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
    ylabel('Division Time','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h6,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylim([tS 40])
    xlim([tS tF])
    if save_plot
        export_fig('fig6.pdf')
        savefig([plotsave 'dt.fig'])
    end
else
    close
end

figure(7)
if sum(7 == plotidx)
    ylabel('Delta Length','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h7,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylim([0 9])
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
    ylabel('Area (µm^2)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h8,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylim([1 11])
    xlim([tS tF])
    if save_plot
        export_fig('fig8.pdf')
        savefig([plotsave 'area.fig'])
    end
else
    close
end

figure(9)
if sum(9 == plotidx)
    ylabel('Surface Area (µm^2)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h9,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylim([5 30])
    xlim([tS tF])
    if save_plot
        export_fig('fig9.pdf')
        savefig([plotsave 'surfacearea.fig'])
    end
else
    close
end

figure(10)
if sum(10 == plotidx)
    ylabel('Volume (µm^3)','FontSize',20)
    xlabel('Time (min)','FontSize',20)
    set(gcf,'color','white')
    setlabels(h10,leg)
    set(gca,'FontSize',15)
    set(gca,'FontName','Myriad Pro')
    ylim([1 11])
    xlim([tS tF])
    if save_plot
        export_fig('fig10.pdf')
        savefig([plotsave 'volume.fig'])
    end
else
    close
end

if fluor_on
    figure(11)
    if sum(11 == plotidx)
        ylabel('Fluorescence','FontSize',20)
        xlabel('Time (min)','FontSize',20)
        set(gcf,'color','white')
        setlabels(11,leg)
        set(gca,'FontSize',15)
        set(gca,'FontName','Myriad Pro')
        %ylim([300 350])
        xlim([tS tF])
        if save_plot
            export_fig('fig11.pdf')
            savefig([plotsave 'fluor.fig'])
        end
    else
        close
    end
end

if save_plot
    str1 = 'append_pdfs([plotsave ''medians.pdf''],';
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

% if fluor_on
%     append_pdfs([plotsave '-medians.pdf'],'fig1.pdf','fig2.pdf','fig3.pdf','fig4.pdf')
%     delete('fig1.pdf','fig2.pdf','fig3.pdf','fig4.pdf')
% else
%     append_pdfs([plotsave '-medians.pdf'],'fig1.pdf','fig2.pdf','fig3.pdf')
%     delete('fig1.pdf','fig2.pdf','fig3.pdf')
% end

end
end

function h = plotmed(param,time,h,j,colors)
    med_param = [];
    err_param = [];
    for i = 1:max(time)
        idx = find(i == time);
        med_param = [med_param;[i,nanmedian(param(idx))]];
        err_param = [err_param; [i,nanstd(param(idx))]];
        hold on;
    end
    idx1 = ~isnan(med_param(:,2));
    
    xlen = med_param(idx1,1);
    yupperbound = med_param(idx1,2)+(err_param(idx1,2)/2);
    ylowerbound = med_param(idx1,2)-(err_param(idx1,2)/2);
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],colors,'FaceAlpha',0.2,'EdgeColor','none');
    h(j) = plot(med_param(idx1,1),med_param(idx1,2),'Color',colors,'LineWidth',2);
end

function h = plotmedfirst(param,time,j,colors)
    med_param = [];
    err_param = [];
    for i = 1:max(time)
        idx = find(i == time);
        med_param = [med_param;[i,nanmedian(param(idx))]];
        err_param = [err_param; [i,nanstd(param(idx))]];
        hold on;
    end
    idx1 = ~isnan(med_param(:,2));
    
    xlen = med_param(idx1,1);
    yupperbound = med_param(idx1,2)+(err_param(idx1,2)/2);
    ylowerbound = med_param(idx1,2)-(err_param(idx1,2)/2);
    p = patch([xlen; flip(xlen)],[ylowerbound;flip(yupperbound)],colors,'FaceAlpha',0.2,'EdgeColor','none');
    h(j) = plot(med_param(idx1,1),med_param(idx1,2),'Color',colors,'LineWidth',2);
end

function setlabels(h,leg)
str1 = 'h(1),';
N = numel(h);
for i = 2:N
    if i == numel(h)
        str1 = [str1 sprintf(' h(%d)',i)];
    else
        str1 = [str1 sprintf(' h(%d),',i)];
    end
end

eval(['legend([' str1 '],leg,''Location'',''North'',''Orientation'',''horizontal'')'])
end