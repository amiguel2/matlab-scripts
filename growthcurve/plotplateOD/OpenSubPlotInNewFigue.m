function OpenSubPlotInNewFigue
      for ii = 1:96
          %Create foru subplots with a button down function pointed at
          %copy2Figure with random data.
          subplot(16,12,ii,'ButtonDownFcn',@copy2NewFigure); 
          hold on
          plot(rand(1,10));
      end
      subplot(2,1,2,'ButtonDownFcn',@clearFig); 
      hold on;
  end
function copy2NewFigure(src,~)
      hAx = subplot(2,1,2); %subplot(2,1,2); %new figure
      copyobj(get(src,'children'),hAx); %copy the children of the clicked axes to the new one    
end
function clearFig(src,~)
fprintf('Clear!\n')
cla
end