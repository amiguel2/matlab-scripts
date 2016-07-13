function pa_plot_all(pa_data,standard)
    
    days = unique(pa_data(2:size(pa_data,1),1));
    n = length(days);
    c = cbrewer('qual','Set1',n);
    for i=1:n
        pa_index = find(strcmp(pa_data,days(i)));
        stan_index = find(strcmp(standard(1,:),days(i)));
        protein_conc = standard(2:6,1);
        protein_conc = [protein_conc{:}];
        absorb = standard(2:6,stan_index);
        absorb = [absorb{:}];
        plot(absorb,protein_conc,':','Color',c(i,:));
        hold on;
    end
    legend(days,'location','NorthWest')
    for i=1:n
        pa_index = find(strcmp(pa_data,days(i)));
        stan_index = find(strcmp(standard(1,:),days(i)));
        protein_conc = standard(2:6,1);
        protein_conc = [protein_conc{:}];
        absorb = standard(2:6,stan_index);
        absorb = [absorb{:}];
        %plot(absorb,protein_conc,':','Color',c(i,:));
        for j=1:length(pa_index)
            [lr,S] = polyfit(absorb,protein_conc,3);
            value = polyval(lr,cell2mat(pa_data(pa_index(j),4)));
            hold on;
            scatter(cell2mat(pa_data(pa_index(j),4)),value,50,c(i,:),'MarkerFaceColor',c(i,:))
            name = pa_data(pa_index(j),3);
            name = [name{:}];
            
            fprintf('%s\t%.3d\t%.3d\n',name,cell2mat(pa_data(pa_index(j),4)),value)
        end
    end
    xlim([0.05,0.3])
    ylim([0.1,0.8])
end