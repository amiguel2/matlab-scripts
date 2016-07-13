function pa_plot_all(pa_data,standard)
    for i=2:size(pa_data,1)
        date = pa_data(i,1);
        index = find(strcmp(r(1,:),date));
        protein_conc = standard(2:6,1);
        absorb = standard(2:6,index);
        lr = polyfit([absorb{:}],[protein_conc{:}],2);
        calc_pc = @(ab) lr(1)*ab^2 + lr(2)*ab + lr(3);
        value = calc_pc(pa_data(i,4);
        scatter(pa_data(i,4),value)
        hold on;
    end

end