function shadederrorplot(x,y,color)
    meanvalues = mean(y');
    stdvalues = std(y');
    topy = meanvalues + stdvalues;
    bottomy = meanvalues - stdvalues;
    h = patch([x' fliplr(x')],[topy fliplr(bottomy)],color);hold on;
    h.EdgeAlpha = 0;
    h.FaceAlpha = 0.2;
    plot(x,mean(y,2),'Color',color); 
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
end