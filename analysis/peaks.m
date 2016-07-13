% find peaks in FtsZ data
nq = 0;
for q=0:1:7
    nq = nq+1;
    if q<10
        c = '0';
    else 
        c = '';
    end
    
    contfile = ['Pos',c,int2str(q),'_CONTOURS.mat'];
    sc = 0.064;
    load(contfile);
    n = 0;
    plot_peaks = 0;
    for i=1:numel(frame)
        for j=1:numel(frame(i).object)
            data = frame(i).object(j);
            if isfield(data,'area') & numel(data.area)>0 & numel(data.MT_length>0) & isfield(data,'fluor_profile')
                % find peaks, and normalize to lengths
                fpsm = smooth(data.fluor_profile,20);
                fpsm2 = smooth(data.fluor_profile,20);
                if plot_peaks
                    plot(data.fluor_profile);
                    hold on; 
                    plot(fpsm2,'r','LineWidth',2);
                    hold off;
                end
                fprintf('Frame %d, Cell %d: length %g\n',i,j,data.MT_length*sc);
                % print out the first peaks
                [pks,locs] = findpeaks(fpsm2);
                [sp,isp] = sort(pks);
                avefl = mean(data.fluor_profile);
                stdfl = std(data.fluor_profile);
                if plot_peaks
                    fprintf('Sorted peaks/positions: (mean=%g +- %g)\n',avefl,stdfl);
                end
                num_peaks = numel(sp>avefl+stdfl*0.5);
                z = 1;
                while z<numel(isp) & (sp(end-z+1)>avefl+stdfl*0.5)
                    if plot_peaks
                        fprintf('%g\t%g\n',sp(end-z+1),locs(isp(end-z+1)));
                    end
                    z = z+1;
                    % record data about peak
                    n = n+1; % number of peak
                    peak(n).pos = locs(isp(end-z+1));
                    
                    % shift position
                    peak(n).norm_pos = locs(isp(end-z+1))/numel(data.fluor_profile);
                    peak(n).cell_length = data.MT_length*sc;
                    peak(n).maxval = max(data.fluor_profile);
                    peak(n).minval = min(data.fluor_profile);
                    dn = 20;
                    n0 = max(1,peak(n).pos-dn);
                    n1 = min(numel(data.fluor_profile),peak(n).pos+dn);
                    m0 = max(1,peak(n).pos-dn/2);
                    m1 = min(numel(data.fluor_profile),peak(n).pos+dn/2);
                    
                    % find peak in actual data
                    [pks2,locs2] = findpeaks(data.fluor_profile(m0:m1));
                    [sp2,isp2] = sort(pks2);
                    if numel(isp2)>0
                        peak(n).sh_pos = locs2(isp2(end))-1+m0;
                        peak(n).sh_norm_pos = (locs2(isp2(end))-1+m0)/numel(data.fluor_profile);
                    else
                        peak(n).sh_pos = peak(n).pos;
                        peak(n).sh_norm_pos = peak(n).norm_pos;
                    end
                    p0 = max(1,peak(n).sh_pos-dn);
                    p1 = min(numel(data.fluor_profile),peak(n).sh_pos+dn);
                    peak(n).profile = data.fluor_profile(n0:n1);
                    peak(n).sh_profile = data.fluor_profile(p0:p1);
                    peak(n).norm_profile = (peak(n).profile-peak(n).minval)/(peak(n).maxval-peak(n).minval);
                    peak(n).sh_norm_profile = (peak(n).sh_profile-peak(n).minval)/(peak(n).maxval-peak(n).minval);
                    peak(n).profile01 = (peak(n).profile-min(peak(n).profile))/(max(peak(n).profile)-min(peak(n).profile));
                    peak(n).sh_profile01 = (peak(n).sh_profile-min(peak(n).sh_profile))/(max(peak(n).sh_profile)-min(peak(n).sh_profile));
                    peak(n).num_peaks = num_peaks;
                end
                if plot_peaks
                    pause
                end
            end
        end
    end

    % plot all peaks
    c0 = [1 0 0];
    c1 = [0 1 1];
    figure; hold on;
    allnorm = [];
    sh_allnorm = [];
    for k=1:numel(peak)
        c = c0+(c1-c0)*(k-1)/(numel(peak)-1);
        if peak(k).maxval>1.5*peak(k).minval
            plot(peak(k).sh_norm_profile,'Color',c);
        end
        allnorm(k,1:numel(peak(k).norm_profile)) = peak(k).norm_profile;
        sh_allnorm(k,1:numel(peak(k).sh_norm_profile)) = peak(k).sh_norm_profile;    
    end
    
    % plot average
    allnorm(allnorm==0) = NaN;
    sh_allnorm(sh_allnorm==0) = NaN;   
    allnorm_mean = nanmean(allnorm);
    sh_allnorm_mean = nanmean(sh_allnorm);    
    plot(sh_allnorm_mean,'Color',[0 0 0],'LineWidth',2);
    hold off;
    print('-dpdf',['peaks',c,int2str(q),'.pdf']);

    position(nq).allnorm_mean = allnorm_mean;
    position(nq).sh_allnorm_mean = sh_allnorm_mean;    
    
    % plot normalized peaks
    figure; hold on;
    allnorm = [];
    sh_allnorm = [];    
    for k=1:numel(peak)
        c = c0+(c1-c0)*(k-1)/(numel(peak)-1);
        if peak(k).maxval>1.5*peak(k).minval
            plot(peak(k).sh_profile01,'Color',c);
        end
        allnorm(k,1:numel(peak(k).profile01)) = peak(k).profile01;
        sh_allnorm(k,1:numel(peak(k).sh_profile01)) = peak(k).sh_profile01;        
    end
    
    % plot average
    allnorm(allnorm==0) = NaN;
    sh_allnorm(sh_allnorm==0) = NaN;    
    allnorm_mean = nanmean(allnorm);
    sh_allnorm_mean = nanmean(sh_allnorm);
    plot(sh_allnorm_mean,'Color',[0 0 0],'LineWidth',2);
    hold off;
    print('-dpdf',['peaks',c,int2str(q),'.pdf']);

    position(nq).allnorm_mean01 = allnorm_mean;
    position(nq).sh_allnorm_mean01 = sh_allnorm_mean;    
    
    %pause;

    % save all info about these peaks
    position(nq).peaks = peak;
end

% plot all the normalized positions
figure; hold on;
c0 = [0 1 0];
c1 = [0 0 1];
for i=1:numel(position)
    c = c0+(c1-c0)*(i-1)/(numel(position)-1);
    
    plot(position(i).sh_allnorm_mean01,'Color',c);
end
hold off;

% plot normalized positions relative to length
figure; hold on;
for i=1:numel(position)
    c = c0+(c1-c0)*(i-1)/(numel(position)-1);
    if i<=6
        sz = 25;
    else
        sz = 10;
    end
    if i>6
        c(1) = 1;
    end
    scatter([position(i).peaks(:).sh_norm_pos],[position(i).peaks(: ...
                                                      ).cell_length],sz,c,'filled');
end
ylim([10 50]);

% determine if there is a difference in levels
nq = 0;
for q=0:1:7
    nq = nq+1;
    if q<10
        c = '0';
    else 
        c = '';
    end

    nc = 0; % cell counter
    
    contfile = ['Pos',c,int2str(q),'_CONTOURS.mat'];
    sc = 0.064;
    load(contfile);

    sum_fluor = [];
    fl_length = [];
    for i=1:numel(frame)
        for j=1:numel(frame(i).object)
            data = frame(i).object(j);
            if isfield(data,'area') & numel(data.area)>0 & numel(data.MT_length>0) & isfield(data,'fluor_profile')
                nc = nc+1;
                % figure out sum of fluorescence
                sum_fluor(nc) = sum(data.fluor_profile);
                fl_length(nc) = data.MT_length*sc;
            end
        end
    end
    
    sums(nq).sum_fluor = sum_fluor;
    sums(nq).fl_length = fl_length;
end

figure; hold on;
for i=1:numel(sums)
    c = c0+(c1-c0)*(i-1)/(numel(sums)-1);
    if i<=10
        sz = 25;
    else
        sz = 20;
    end
    if i>6
        c(1) = 1;
    end
    scatter(sums(i).fl_length,sums(i).sum_fluor,sz,c,'filled');
    
    % calculate mean
    mean_fl(i) = mean(sums(i).sum_fluor./sums(i).fl_length);
end
xl = xlim;
for i=1:numel(sums)
    c = c0+(c1-c0)*(i-1)/(numel(sums)-1);
    if i>10
        c(1) = 1;
    end
    plot(xl,xl*mean_fl(i),'Color',c,'LineWidth',1);
end
hold off;

% group together all the values
for q=1:3
    fl_length_tot{q} = [];
    sum_fluor_tot{q} = [];
end
for i=1:3
    fl_length_tot{1} = [fl_length_tot{1} sums(i).fl_length];
    sum_fluor_tot{1} = [sum_fluor_tot{1} sums(i).sum_fluor];
end
for i=4:6
    fl_length_tot{2} = [fl_length_tot{2} sums(i).fl_length];
    sum_fluor_tot{2} = [sum_fluor_tot{2} sums(i).sum_fluor];
end
for i=7:8
    fl_length_tot{3} = [fl_length_tot{3} sums(i).fl_length];
    sum_fluor_tot{3} = [sum_fluor_tot{3} sums(i).sum_fluor];
end

% plot the ratio
[h1,n1] = hist(sum_fluor_tot{1}./fl_length_tot{1},1e5:5e3:3e5);
[h2,n2] = hist(sum_fluor_tot{2}./fl_length_tot{2},1e5:5e3:3e5);
[h3,n3] = hist(sum_fluor_tot{3}./fl_length_tot{3},1e5:5e3:3e5);

figure; hold on;
stairs(n1,h1/sum(h1),'r');
stairs(n2,h2/sum(h2),'g');
stairs(n3,h3/sum(h3),'b');
hold off;

