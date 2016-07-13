function []=plot_width_time(data,timeshift) 
%% make plots of width as a function of time
    figure(1);
    hold on;
    
    c0 = data.params.color0;
    c1 = data.params.color1;
    fi = data.fi;
    betas = data.betas_exp;
    time_curves = data.time_curves;
    width_curves = data.width_curves;
    
    for j=1:numel(fi)
        c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
        plot(time_curves{fi(j)}+timeshift,smooth(width_curves{fi(j)},5),'Color',c);
    end
    hold off;
    xlabel('Time (frames)');
    ylabel('Width (um)');
    hold off
    
    
    %% 
%     figure(2);
%     hold on;
%     
%     for j=1:numel(fi)
%         c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
%         plot(time_curves{fi(j)},smooth(width_curves{fi(j)},5)/width_curves{fi(j)}(1),'Color',c);
%     end 
%     
%     hold off;
%     xlabel('Time (frames)');
%     ylabel('Normalized width (um)');
    
end