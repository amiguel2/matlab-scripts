function []=plot_fluor_width(data) 
%% make plots of width as a function of time
    hold on;
    
    c0 = data.params.color0;
    c1 = data.params.color1;
    fi = data.fi;
    betas = data.betas_exp;
    fluor_time = data.fluor_time;
    fluor_curves = data.fluor_curves;
    time_curves = data.time_curves;
    width_curves = data.width_curves;
    prox_curves = data.prox_curves;
    
%     for j=1:numel(fi)
%         if (numel(fi)>0)
%             maxdifff(j) = max(abs(diff(fluor_curves{fi(j)}/fluor_curves{fi(j)}(1))));
%         else
%             maxdifff(j) = 1000000;
%         end
%     end
%     
%     fi = find(maxdifff'<0.1);
%     
% make plots of fluor and width as a function of time
    figure(1);
    hold on;
    
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
        
    for j=1:numel(fi)
        c = c0+(c1-c0)*(j-1)/(numel(fi)-1);
        fi2 = find(~isnan(width_curves{fi(j)}));
        maxf = max(fluor_curves{fi(j)});
        minf = min(fluor_curves{fi(j)});
        %        if numel(width_curves{fi(j)})==numel(fluor_curves{fi(j)}) & ...
        %        numel(fi2)>12 & maxf>2*minf & prox_curves{fi(j)}(1)>=0
        if numel(width_curves{fi(j)})==numel(fluor_curves{fi(j)}) & ...
                numel(fi2)>6 & maxf>1*minf & prox_curves{fi(j)}(1)==0
            maxw = max(smooth(width_curves{fi(j)},5));
            minw = min(smooth(width_curves{fi(j)},5));
            smooth_width = smooth(width_curves{fi(j)},5);
            %plot(smooth(width_curves{fi(j)},5),(fluor_curves{fi(j)}-minf)/(maxf-minf),'Color',c,'LineWidth',0.5);
            colors{fi(j)} = rand(1,3);
            lw{fi(j)} = 0.5+5*(smooth_width(1)-1)^2;
            %plot(smooth(width_curves{fi(j)},5),(fluor_curves{fi(j)}/fluor_curves{fi(j)}(1)),'Color',colors{fi(j)},'LineWidth',lw{fi(j)});
            %plot(smooth_width-smooth_width(1),(fluor_curves{fi(j)}-fluor_curves{fi(j)}(1)),'Color',colors{fi(j)},'LineWidth',lw{fi(j)});
            %plot(smooth(width_curves{fi(j)},5),fluor_curves{fi(j)},'Color',c,'LineWidth',0.5);
            
            
            try
                %plot(smooth(width_curves{fi(j)},5),(smooth(fluor_rate{fi(j)},5)),'Color',c,'LineWidth',0.5);
                %plot(smooth(width_change{fi(j)},5),(smooth(fluor_rate{fi(j)},5)),'Color',c,'LineWidth',0.5);
                %plot(smooth(width_change{fi(j)},5),smooth(fluor_rate{fi(j)},5),'Color',c,'LineWidth',0.5);
            catch err
            end
                
            plot(smooth(width_curves{fi(j)},5),(fluor_curves{fi(j)}),'Color',c,'LineWidth',0.5);
            %plot(width_curves{fi(j)}/width_curves{fi(j)}(1),(fluor_curves{fi(j)}/fluor_curves{fi(j)}(1)),'Color',c,'LineWidth',0.5);
            %plot((smooth(width_curves{fi(j)},5)-minw)/(maxw-minw),(fluor_curves{fi(j)}-minf)/(maxf-minf),'Color',c,'LineWidth',0.5);        
        end
    end
    
    hold off;
    xlabel('Width (um)');
    %ylabel('Normalized Fluorescence');
    ylabel('Fluorescence');
end
