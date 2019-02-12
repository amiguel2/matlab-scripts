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