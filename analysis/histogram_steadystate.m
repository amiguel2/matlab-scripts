function [ lm, mm ] = histogram_steadystate(filelist,group,params,hist_save)

% if filelist is a filename, then make filelist
if ischar(filelist)
    filelist = dir(filelist);
end

% make all plots start when the cell appears
if isfield(params,'shifttime')
    shifttime = params.shifttime;
else
    shifttime = 1;
end

% colors
c0 = params.color0; %[1 0 0];
c1 = params.color1; %[0 1 1];

% pixel size
sc = params.pxl_size;

% minarea
minarea = 500;

fprintf('\n');
% loop over all files

count = 1;
for q=1:numel(filelist)
    %fprintf('Analyzing file %s...\n',filelist(q).name);
    s = load(filelist(q).name);
    
    for i = 1:numel(s.frame.object)
        ob = s.frame.object(i);
        if ob.on_edge == 0
            l(count) = ob.cell_length*params.pxl_size;
            w(count) = ob.cell_width*params.pxl_size;
            %av_f(count) = ob.ave_fluor*params.pxl_size;
            count = count + 1;
        end
    end
end
    lm = nanmean(l);
    mm = nanmean(w);
    c1 = round(sqrt(length(l)));
    c2 = round(sqrt(length(w)));
    
    f1 = figure;
    hold on;
    hist(l(~isnan(l)),c1)
    xlabel('Length (µm)')
    ylabel('Frequency')
    yL = get(gca,'YLim');
    line([lm lm],yL,'Color','r','LineStyle','--');
    
    DataX = interp1( [0 1], xlim(), 0.7 );
    DataY = interp1( [0 1], ylim(), 0.75 );
    text(DataX, DataY, ['Mean: ', num2str(lm)],'Color','r')
    
    
    hold off;
    print(f1,'-dpdf',[hist_save,'_hist_length.pdf']);
    f2 = figure;
    hist(w(~isnan(w)),c2)
    hold on;
    xlabel('Width (µm)')
    ylabel('Frequency')
    yL = get(gca,'YLim');
    line([mm mm],yL,'Color','r','LineStyle','--');

    DataX = interp1( [0 1], xlim(), 0.7 );
    DataY = interp1( [0 1], ylim(), 0.75 );
    text(DataX, DataY, ['Mean: ',num2str(mm)],'Color','r')
    
    print(f2,'-dpdf',[hist_save,'_hist_width.pdf']); 
    %figure;
    %hist(av_f,100)
    
    histdata.length = l;
    histdata.width = w;
    %histdata.ave_fluor = av_f;
    save([hist_save,'_hist_data.mat'],'histdata');
    
end