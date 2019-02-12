function plot_od_96well(data,time,varargin)
figure('Position',[0 0 800 800])
for i = 1:numel(data)
    od = data{i};
    t = time{i};
    
    for ii = 1:96
        subplot(16,12,ii,'ButtonDownFcn',@copy2BigWindow,'xtick',[],'ytick',[]);
        hold on
        plot(t/60,od(:,ii)); hold on;
        ylim([ 0 1])
    end
end
cosmetics()
subplot(2,1,2,'ButtonDownFcn',@copy2NewFigure);
hold on;
ylim([0 1])

end

function copy2BigWindow(src,~)
hAx = subplot(2,1,2); %subplot(2,1,2); %new figure
copyobj(get(src,'children'),hAx); %copy the children of the clicked axes to the new one
end

function copy2NewFigure(src,~)
%subplot(2,1,2); %new figure
hFig = figure;
hAx1 = axes('Parent',hFig); %new axes
copyobj(get(src,'children'),hAx1); %copy the children of the clicked axes to the new one
end

function clearFig(src,~)
fprintf('Clear!\n')
subplot(2,1,2)
cla
end

function cosmetics()
figure1 = gcf;

ButtonH1=uicontrol('Parent',figure1,'Callback',@convert2log,'Style','pushbutton','String','Log-scale','Units','normalized','Position',[0.355,0.464488636363636,0.13625,0.044034090909091],'Visible','on');
ButtonH2=uicontrol('Parent',figure1,'Callback',@convert2linear,'Style','pushbutton','String','Linear-scale','Units','normalized','Position',[0.4925,0.4645,0.1362,0.044],'Visible','on');
ButtonH3=uicontrol('Parent',figure1,'Callback',@clearFig,'Style','pushbutton','String','Clear','Units','normalized','Position',[0.76625,0.03125,0.13625,0.044034090909091],'Visible','on');
ButtonH4=uicontrol('Parent',figure1,'Callback',@plotlinemeans,'Style','pushbutton','String','Plot Mean','Units','normalized','Position',[0.622500000000001,0.030738636363636,0.13625,0.044034090909091],'Visible','on');
ButtonH5=uicontrol('Parent',figure1,'Callback',@setlinecolors,'Style','pushbutton','String','Color Means','Units','normalized','Position',[0.48125,0.03075,0.1362,0.044],'Visible','on');


annotation(figure1,'textbox',...
    [0.155 0.934191702432046 0.04025 0.021459227467811],'String','1',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.22 0.934191702432046 0.04025 0.021459227467811],'String','2',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.285 0.934191702432046 0.04025 0.021459227467811],'String','3',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.35 0.934191702432046 0.04025 0.021459227467811],'String','4',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.415 0.934191702432046 0.04025 0.021459227467811],'String','5',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.48 0.934191702432046 0.04025 0.021459227467811],'String','6',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.545 0.934191702432046 0.04025 0.021459227467811],'String','7',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.61 0.934191702432046 0.04025 0.021459227467811],'String','8',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.675 0.934191702432046 0.04025 0.021459227467811],'String','9',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.74 0.934191702432046 0.04025 0.021459227467811],'String','10',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

annotation(figure1,'textbox',...
    [0.805 0.934191702432046 0.04025 0.021459227467811],'String','11',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.87 0.934191702432046 0.04025 0.021459227467811],'String','12',...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);

%
annotation(figure1,'textbox',...
    [0.0875 0.88 0.031875 0.0319602272727273],'String',{'A'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.83 0.031875 0.0319602272727273],'String',{'B'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.78 0.031875 0.0319602272727273],'String',{'C'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.73 0.031875 0.0319602272727273],'String',{'D'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.68 0.031875 0.0319602272727273],'String',{'E'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.63 0.031875 0.0319602272727273],'String',{'F'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.58 0.031875 0.0319602272727273],'String',{'G'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
annotation(figure1,'textbox',...
    [0.0875 0.53 0.031875 0.0319602272727273],'String',{'H'},...
    'EdgeColor',[0.9400 0.9400 0.9400],'FontSize',12);
end

function convert2log(src,~)
for ii = 1:96
    ax = subplot(16,12,ii);
    set(ax,'YScale', 'log'); %ylim([-8 -1.5])
end

ax = subplot(2,1,2);
set(ax,'YScale', 'log');%ylim([-8 -1.5])
end

function convert2linear(src,~)
for ii = 1:96
    ax = subplot(16,12,ii);
    set(ax,'YScale', 'linear'); %ylim([ 0 1])
end

ax = subplot(2,1,2);
set(ax,'YScale', 'linear');%ylim([ 0 1])
end

function setlinecolors(src,~)
h = findobj(gca,'UserData','mean');
c = cbrewer('qual','Set1',numel(h));
count = 1;
for i = fliplr(1:numel(h))
    h(i).Color = c(count,:);
    count = count + 1;
end
end

function plotlinemeans(src,~)
h = findobj(gca,'Type','line');
if numel(h) > 1
    N = numel(h);
    M = numel(h(1).YData);
    Ydata = nan(N,M);
    Xdata = h(1).XData;
    for i = 1:numel(h)
        if ~strcmp(h(i).UserData,'rep') & ~strcmp(h(i).UserData,'mean')
            Ydata(i,:) = h(i).YData;
            h(i).Color = [0.8 0.8 0.8];
            h(i).UserData = 'rep';
            set(get(get(h(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    end
    plot(Xdata,nanmean(Ydata),'LineWidth',2,'UserData','mean')
else
    h.LineWidth = 2;
    h.UserData = 'mean';
end
end