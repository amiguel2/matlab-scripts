function plot_logod_96well(logod,time,varargin)
figure('Color',[1 1 1])
if numel(varargin) == 1
    blanks = varargin{1};
else
    blanks = [];
end
for i = 1:96
        h = subplot(16,12,i,'ButtonDownFcn',@copy2NewFigure);
        if find(i == blanks)
        h.Color = [0.5 0.5 0.5];
        else
        plot(time/60,logod(:,i))
          ylim([-7 0]);
        end
end

subplot(2,1,2,'ButtonDownFcn',@clearFig);
hold on;

end


function copy2NewFigure(src,~)
      hAx = subplot(2,1,2); %subplot(2,1,2); %new figure
      copyobj(get(src,'children'),hAx); %copy the children of the clicked axes to the new one    
end

function clearFig(src,~)
cla
end