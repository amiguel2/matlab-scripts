function [] = plot_growth_curves(data)
%plot growth curves    
    figure;
    fi = data.fi;
    betas = data.betas_exp;
    time_curves = data.time_curves;
    c0 = data.params.color0;
    c1 = data.params.color1;
        
    area_curves = data.area_curves;
    
    hold on;
    for j=1:numel(fi)
        c = c0+(c1-c0)*(j-1)/(numel(fi));
        plot(time_curves{fi(j)},area_curves{fi(j)}/area_curves{fi(j)}(1),'Color',c,'LineWidth',0.5);
    end
    % overlay average

    average_area = expfit([1 mean(betas(fi,2))],0:30);
    plot(0:30,average_area,'Color',[0 0 0],'LineWidth',2);

    hold off;
    xlabel('Time (min)');
    ylabel('Fractional growth');
    title(['Growth curves']);
    xlim([0 30])
    ylim([0.8 2.5]);


end