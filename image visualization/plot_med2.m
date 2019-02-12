function plot_med2(med_param1,err_param1,med_param2,err_param2,colors,sm)
    idx1 = ~isnan(med_param1(:,2)) & ~isnan(med_param2(:,2)) & ~isnan(err_param1(:,2)) &~isnan(err_param2(:,2));
    idx2 = idx1;
    
    if sm
        med_paramy =smooth(med_param1(idx1,2) );
        med_paramx = smooth(med_param2(idx2,2) );
    else
        med_paramy =med_param1(idx1,2);
        med_paramx =med_param2(idx2,2);
    end
    
    yupperbound = med_paramy+(err_param1(idx1,2)/2);
    ylowerbound = med_paramy-(err_param1(idx1,2)/2);
    xupperbound = med_paramx+(err_param2(idx2,2)/2);
    xlowerbound = med_paramx-(err_param2(idx2,2)/2);
    c = colors + 0.3;
    c(c > 1) = 1;
    p = patch([xlowerbound; flip(xupperbound)],[ylowerbound;flip(yupperbound)],c,'FaceAlpha',0.2,'EdgeColor','none');
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    plot(med_paramx,med_paramy,'Color',colors,'LineWidth',2);
end