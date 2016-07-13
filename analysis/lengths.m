filelist = dir('Pos0_30_CONTOURS.mat');
nf = size(filelist);
nf = nf(1);
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
    for j=1:numel(frame)
        for k=1:numel(frame(j).object)
            ob = frame(j).object(k);
            if ob.on_edge==0 & numel(ob.MT_length)>0 & ob.area>minarea ...
                          & ~isnan(ob.MT_length)
                temp = [temp ob.MT_length];
            end
            if ob.on_edge==0 & numel(ob.MT_width)>0 & ob.area>minarea ...
                          & ~isnan(ob.MT_width)
                tempw = [tempw ob.MT_width];
            end            
            if ob.on_edge==0
                if numel(ob.MT_width)==0 & ...
                        numel(ob.MT_length)>0
                    fprintf('Warning: W/L %d %d %d\n',q,j,k);
                end
                if isnan(ob.MT_width)==1
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
    [ht,nt] = hist(len{q},0:maxlen/200:maxlen);
    [wt,pt] = hist(width{q},0:maxwid/200:maxwid);    
    h{q} = ht;
    w{q} = wt;    
    n{q} = nt;
    p{q} = pt;
    sumhist{q} = sum(h{q});
    sumhistw{q} = sum(w{q});
    h{q} = h{q}/sumhist{q};
    w{q} = w{q}/sumhistw{q};    
end

figure;
sc = 0.064;


stairs(sc*n{1},[h{1};h{2};h{3};h{4};h{5};h{6}]');
legend('empty','empty','wt','wt','peri','peri');
xlabel('Cell length (um)');
ylabel('Frequency');
title('Cell length distributions for 6 experiments (empty)');

figure;
stairs(sc*p{1},[w{1};w{2};w{3};w{4};w{5};w{6}]');
legend('empty','empty','wt','wt','peri','peri');    
xlabel('Cell width (um)');
ylabel('Frequency');
title('Cell width distributions for 6 experiments (empty)');

% make new histograms that remove set 2 and average the rest
Nlen{1} = len{1};
Nwidth{1} = width{1};
Nlen{2} = [len{3} len{4}];
Nwidth{2} = [width{3} width{4}];
Nlen{3} = [len{5} len{6}];
Nwidth{3} = [width{5} width{6}];

for q=1:size(Nlen,2)
    [ht,nt] = hist(Nlen{q},0:maxlen/200:maxlen);
    [wt,pt] = hist(Nwidth{q},0:maxwid/200:maxwid);    
    Nh{q} = ht;
    Nw{q} = wt;    
    Nn{q} = nt;
    Np{q} = pt;
    Nsumhist{q} = sum(Nh{q});
    Nsumhistw{q} = sum(Nw{q});
    Nh{q} = Nh{q}/Nsumhist{q};
    Nw{q} = Nw{q}/Nsumhistw{q};    
    NaveL(q) = mean(Nlen{q});
    NmedL(q) = median(Nlen{q});
    NaveW(q) = mean(Nwidth{q});
    NmedW(q) = median(Nwidth{q});    
end

figure;
stairs(sc*Nn{1},[Nh{1};Nh{2};Nh{3}]');
legend('empty','wt','mut');
xlabel('Cell length (um)');
ylabel('Frequency');
title('Cell length distributions for experiments combined into groups');

% add averages
for q=1:size(Nlen,2)
    [ht,nt] = hist(Nlen{q},0:maxlen/200:maxlen);
    [wt,pt] = hist(Nwidth{q},0:maxwid/200:maxwid);    
    Nh{q} = ht;
    Nw{q} = wt;    
    Nn{q} = nt;
    Np{q} = pt;
    Nsumhist{q} = sum(Nh{q});
    Nsumhistw{q} = sum(Nw{q});
    Nh{q} = Nh{q}/Nsumhist{q};
    Nw{q} = Nw{q}/Nsumhistw{q};    
    NaveL(q) = mean(Nlen{q});
    NmedL(q) = median(Nlen{q});
    NaveW(q) = nanmean(Nwidth{q});
    NmedW(q) = median(Nwidth{q});    
end
colors(1,:) = [0 0 1];
colors(2,:) = [0 1 0];
colors(3,:) = [1 0 0];

figure;
stairs(sc*Nn{1},[Nh{1};Nh{2};Nh{3}]');
legend('empty','wt','mut');
% add averages
hold on;
for j=1:3
    plot(sc*NaveL(j)*ones(1,2),[0 0.05],'Color',colors(j,:),'LineWidth',2);
    plot(sc*NmedL(j)*ones(1,2),[0 0.05],'LineStyle',':','Color',colors(j,:),'LineWidth',1.5);
end
hold off;
for j=1:3
    fprintf('%d: mean=%g, median=%g\n',j,sc*NaveL(j),sc*NmedL(j));
end
axis([0 10 0 0.1]);
xlabel('Cell length (um)');
ylabel('Frequency');
title('Cell length distributions overlaid with mean (-) and median(:)');

%% plot shifted length distributions
figure;
hold on;
% find peak in each length distribution
for j=1:3
    [mv,imv] = max(smooth(Nh{j},10));
    % shift the center
    %plot(Nn{j}/Nn{j}(imv(end)),Nh{j}/mv(end),'Color',colors(j,:));
    plot(Nn{j}/mean(Nlen{j}),Nh{j}/mv(end),'Color',colors(j,:));    
    %    plot(Nn{j}/Nn{j}(imv(end)),smooth(Nh{j}/mv(end),10),'Color',colors(j,:),'LineWidth',2);
    plot(Nn{j}/mean(Nlen{j}),smooth(Nh{j}/mv(end),10),'Color',colors(j,:),'LineWidth',2);
end
axis([0.5 2 0 1]);
xlabel('Normalized cell length (a.u.)');
ylabel('Frequency (normalized to 1)');
title('Cell length distributions normalized to mean value');

figure;
stairs(sc*Np{1},[Nw{1};Nw{2};Nw{3}]');
legend('empty','wt','mut');
% add averages
hold on;
maxy = 0.2;
for j=1:3
    plot(sc*NaveW(j)*ones(1,2),[0 maxy],'Color',colors(j,:),'LineWidth',2);
    plot(sc*NmedW(j)*ones(1,2),[0 maxy],'LineStyle',':','Color',colors(j,:),'LineWidth',1.5);
end
hold off;
for j=1:3
    fprintf('%d: mean=%g, median=%g\n',j,sc*NaveW(j),sc*NmedW(j));
end
axis([0.7 1.5 0 0.14]);
xlabel('Cell width (um)');
ylabel('Frequency');
title('Cell width distributions overlaid with mean (-) and median (:)');