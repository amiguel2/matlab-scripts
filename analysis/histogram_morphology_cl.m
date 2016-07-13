function data = histogram_morphology(filelist,group,params)

% colors
if isfield(params,'color0')
    c0 = params.color0; %[1 0 0];
else
    c0 = [1 0 0];
end
if isfield(params,'color1')
    c1 = params.color1; %[0 1 1];
else
    c1 = [1 1 1]-c0;
end

% pixel size 
if isfield(params,'pxl_size')
    sc = params.pxl_size; %0.064;
else
    sc = 0.064;
end

if isfield(params,'nbins') & params.nbins>0
    nb = params.nbins;
else
    nb = 200;
end

if ~isfield(params,'roc_filter') 
    params.roc_filter = 0;
end

maxlen = 0;
maxwid = 0;
minarea = 250;

for q=1:numel(filelist)
    load(filelist(q).name);
    fprintf('Processing %d...\n',q);

    % process frames
    len{q} = [];
    width{q} = [];
    temp = [];
    tempw = [];

    if isfield(params,'maxframe') & params.maxframe>0
        nfr = params.maxframe;
    else
        nfr = numel(frame);
    end
    
    if isfield(params,'minframe') & params.minframe>0
        minfr = params.minframe;
    else
        minfr = 1;
    end    
    
    for j=1:nfr
        for k=1:numel(frame(j).object)
            ob = frame(j).object(k);
            
            test1 = ob.on_edge;
            if params.roc_filter==1
                test2 = test_roc(ob);
            else
                test2 = 1;
            end

            if test1==0 & test2==1 & numel(ob.cell_length)>0 & ob.area>minarea ...
                          & ~isnan(ob.cell_length)
                temp = [temp ob.cell_length];
            end
            if test1==0 & test2==1 & numel(ob.cell_width)>0 & ob.area>minarea ...
                          & ~isnan(ob.cell_width)
                tempw = [tempw ob.cell_width];
            end            
            if ob.on_edge==0
                if numel(ob.cell_width)==0 & ...
                        numel(ob.cell_length)>0
                    fprintf('Warning: W/L %d %d %d\n',q,j,k);
                end
                if isnan(ob.cell_width)==1
                    fprintf('Nan: %d %d %d\n',q,j,k);
                end
            end
        end
        len{q} = [len{q} temp];
        width{q} = [width{q} tempw];
    end
    
    maxlen = max(maxlen,max(len{q}));
    maxwid = max(maxwid,max(width{q}));    
end

for q=1:numel(filelist)
    [ht,nt] = hist(len{q},0:maxlen/nb:maxlen);
    [wt,pt] = hist(width{q},0:maxwid/nb:maxwid);    
    
    h{q} = ht;
    w{q} = wt;    
    n{q} = nt;
    p{q} = pt;
    sumhist{q} = sum(h{q});
    sumhistw{q} = sum(w{q});
    h{q} = h{q}/sumhist{q};
    w{q} = w{q}/sumhistw{q};    
    aveL(q) = nanmean(len{q});
    medL(q) = median(len{q});
    aveW(q) = nanmean(width{q});
    medW(q) = median(width{q});   
end

data.hist_length = h;
data.hist_length_values = n;
data.hist_width = w;
data.hist_width_values = p;

data.average_length = aveL;
data.average_width = aveW;
data.median_length = medL;
data.median_width = medW;

%% length figure
figure;
hold on;
for j=1:numel(filelist)
    if numel(filelist)>1
        c = c0+(c1-c0)*(j-1)/(numel(filelist)-1);
    else 
        c = 0.5*(c1+c0);
    end
    
    stairs(sc*n{1},h{j}','Color',c);
end
yl = ylim;

%legend('empty','empty','wt','wt','mut','mut');

% add averages
for j=1:numel(filelist)
    if numel(filelist)>1
        c = c0+(c1-c0)*(j-1)/(numel(filelist)-1);
    else 
        c = 0.5*(c1+c0);
    end

    plot(sc*aveL(j)*ones(1,2),yl,'Color',c,'LineWidth',2);
    plot(sc*medL(j)*ones(1,2),yl,'LineStyle',':','Color',c,'LineWidth',1.5);
end
hold off;
for j=1:numel(filelist)
    fprintf('%d: mean=%g, median=%g\n',j,sc*aveL(j),sc*medL(j));
end

xlabel('Cell length (um)');
ylabel('Frequency');
title('Cell length distributions overlaid with mean (-) and median(:)');

%% width figure
figure;
hold on;
for j=1:numel(filelist)
    if numel(filelist)>1
        c = c0+(c1-c0)*(j-1)/(numel(filelist)-1);
    else 
        c = 0.5*(c1+c0);
    end

    stairs(sc*p{1},w{j}','Color',c);
end
yl = ylim;
%legend('empty','empty','wt','wt','mut','mut'); 

% add averages
for j=1:numel(filelist)
    if numel(filelist)>1
        c = c0+(c1-c0)*(j-1)/(numel(filelist)-1);
    else 
        c = 0.5*(c1+c0);
    end

    plot(sc*aveW(j)*ones(1,2),yl,'Color',c,'LineWidth',2);
    plot(sc*medW(j)*ones(1,2),yl,'LineStyle',':','Color',c,'LineWidth',1.5);
end
hold off;
for j=1:numel(filelist)
    fprintf('%d: mean=%g, median=%g\n',j,sc*aveW(j),sc*medW(j));
end

xlabel('Cell width (um)');
ylabel('Frequency');
title('Cell width distributions');

%% now group the histograms
% will only do this if numel(group)>0
for q=1:numel(group)
    gq = group{q};
    % make new histograms that remove set 2 and average the rest
    Nlen{q} = [];
    Nwidth{q} = [];    
    for v=1:numel(gq)
        Nlen{q} = [Nlen{q} len{gq(v)}];
        Nwidth{q} = [Nwidth{q} width{gq(v)}];
    end
end

for q=1:numel(group)
    [ht,nt] = hist(Nlen{q},0:maxlen/nb:maxlen);
    [wt,pt] = hist(Nwidth{q},0:maxwid/nb:maxwid);    
    Nh{q} = ht;
    Nw{q} = wt;    
    Nn{q} = nt;
    Np{q} = pt;
    Nsumhist{q} = sum(Nh{q});
    Nsumhistw{q} = sum(Nw{q});
    Nh{q} = Nh{q}/Nsumhist{q};
    Nw{q} = Nw{q}/Nsumhistw{q};    
    NaveL(q) = nanmean(Nlen{q});
    NmedL(q) = median(Nlen{q});
    NaveW(q) = nanmean(Nwidth{q});
    NmedW(q) = median(Nwidth{q});    
end

data.group_hist_length = Nh;
data.group_hist_length_values = Nn;
data.group_hist_width = Nw;
data.group_hist_width_values = Np;

data.group_average_length = NaveL;
data.group_average_width = NaveW;
data.group_median_length = NmedL;
data.group_median_width = NmedW;

if numel(group)>0
    %% length figure
    figure;
    hold on;
    for j=1:numel(group)
        if numel(group)>1
            c = c0+(c1-c0)*(j-1)/(numel(group)-1);
        else 
            c = 0.5*(c1+c0);
        end
        
        stairs(sc*Nn{1},Nh{j}','Color',c);
    end
    yl = ylim;

    % add averages
    for j=1:numel(group)
        if numel(group)>1
            c = c0+(c1-c0)*(j-1)/(numel(group)-1);
        else 
            c = 0.5*(c1+c0);
        end
        
        plot(sc*NaveL(j)*ones(1,2),yl,'Color',c,'LineWidth',2);
        plot(sc*NmedL(j)*ones(1,2),yl,'LineStyle',':','Color',c,'LineWidth',1.5);
    end
    hold off;
    for j=1:numel(group)
        fprintf('%d: mean=%g, median=%g\n',j,sc*NaveL(j),sc*NmedL(j));
    end
    
    xlabel('Cell length (um)');
    ylabel('Frequency');
    title('Grouped cell length distributions overlaid with mean (-) and median(:)');

    %% width figure
    figure;
    hold on;
    for j=1:numel(group)
        if numel(group)>1
            c = c0+(c1-c0)*(j-1)/(numel(group)-1);
        else 
            c = 0.5*(c1+c0);
        end
        
        stairs(sc*Np{1},Nw{j}','Color',c);
    end
    yl = ylim;

    % add averages
    for j=1:numel(group)
        if numel(group)>1
            c = c0+(c1-c0)*(j-1)/(numel(group)-1);
        else 
            c = 0.5*(c1+c0);
        end
        
        plot(sc*NaveW(j)*ones(1,2),yl,'Color',c,'LineWidth',2);
        plot(sc*NmedW(j)*ones(1,2),yl,'LineStyle',':','Color',c,'LineWidth',1.5);
    end
    hold off;
    for j=1:numel(group)
        fprintf('%d: mean=%g, median=%g\n',j,sc*NaveW(j),sc*NmedW(j));
    end
    
    xlabel('Cell width (um)');
    ylabel('Frequency');
    title('Grouped cell width distributions overlaid with mean (-) and median(:)');

    %% plot shifted length distributions
    figure;
    hold on;
    % find peak in each length distribution
    for j=1:numel(group)
        if numel(group)>1
            c = c0+(c1-c0)*(j-1)/(numel(group)-1);
        else 
            c = 0.5*(c1+c0);
        end
        
        [mv,imv] = max(smooth(Nh{j},10));
        % shift the center
        plot(Nn{j}/mean(Nlen{j}),Nh{j}/mv(end),'Color',c);    
        plot(Nn{j}/mean(Nlen{j}),smooth(Nh{j}/mv(end),10),'Color',c,'LineWidth',2);
    end
    %axis([0.5 2 0 1]);
    xlabel('Normalized cell length (a.u.)');
    ylabel('Frequency (normalized to 1)');
    title('Cell length distributions normalized to mean value');
end
