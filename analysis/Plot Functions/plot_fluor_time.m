function []=plot_fluor_time(data,timeshift) 
%% make plots of width as a function of time
    figure(1);
    hold on;
    c0 = data.params.color0;
    c1 = data.params.color1;
    fi = data.fi;
    betas = data.betas_exp;
    fluor_time = data.fluor_time;
    fluor_curves = data.fluor_curves;
    width_curves = data.width_curves;
    
    
    for j=1:numel(fi)
        c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
        if numel(fluor_time{fi(j)})>0
            plot(fluor_time{fi(j)}+timeshift,fluor_curves{fi(j)},'Color',c);
        end
    end
    
    %ylim([0.5 1]);
    xlabel('Time (frames)');
    ylabel('Fluoresence');
    
    
    
    hold off; 
    
%    %% 
%     figure(2)
%     hold on;
%     for j=1:numel(fluor_curves)
%         c = c0+(c1-c0)*(j-1)/(numel(width_curves)-1);
%         if numel(fluor_time{j})>0
%             plot(fluor_time{j},fluor_curves{j},'Color',c);            
%         end
%     end
% 
%     %ylim([0.5 1]);
%     xlabel('Time (frames)');
%     ylabel('Fluoresence');
%     title('Non-filtered')
end