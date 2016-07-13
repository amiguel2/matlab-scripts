function ring_dist = calc_ring_distance(f,id,varargin)
% calc_ring_distance(f,id,[plot_cells],[minpeakdistance],[minpeakprominence])
% calculates FtsZ ring data
% Options: 'plot_cells','minpeakdistance','minpeakprominence'
% Defaults: 0, 0, 200
% Example:
% calc_ring_distance(f,id,'plot_cells',1)
% calc_ring_distance(f,id,'plot_cells',1,'minpeakdistance',50,'minpeakprominence',500)


if nargin == 0
    fprintf('Usage: calc_ring_distance(f,id,[plot_cells],[optional]...)\n')
    fprintf('Options: ''plot_cells'',''minpeakdistance'',''minpeakprominence''\n')
    fprintf('Example: calc_ring_distance(f,id,''plot_cells'',1,''minpeakdistance'',50)\n')
    return
end

% suppress warnings
w ='MATLAB:colon:nonIntegerIndex';
warning('off',w)

% default parameters
plot_cells = 0;
minpeakdistance = 0;
minpeakprominence = 200;


if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end



% main code
ring_dist = [];
if isfield(f,'cells')
    
    if isfield(f.frame(1).object(1),'fluor_profile')
        
        % individual cell frames and cell ids
        frames = f.cells(id).frame;
        objects = f.cells(id).object;
        
        % start and end frame
        n = frames(end);
        start = frames(1);
        
        for i = start:n
            idx = find(frames == i);
            if numel(idx) == 1 && objects(idx)
                ob = f.frame(frames(idx)).object(objects(idx));
                
                % calc ring distance
                beg = floor(0.05*numel(ob.fluor_profile));
                en = numel(ob.fluor_profile) - beg;
                fluor_prof = ob.fluor_profile(beg:end/2);
                fluor_prof2 = ob.fluor_profile(end/2+1:en);
                Xcont1 = ob.Xcont(beg:end/2);
                Ycont1 = ob.Ycont(beg:end/2);
                Xcont2 = ob.Xcont(end/2+1:en);
                Ycont2 = ob.Ycont(end/2+1:en);
                [pks1,loc1]=findpeaks(fluor_prof,'MinPeakDistance',minpeakdistance,'MinPeakProminence',minpeakprominence);
                [pks2,loc2]=findpeaks(fluor_prof2,'MinPeakDistance',minpeakdistance,'MinPeakProminence',minpeakprominence);
                if numel(pks1) > 1 && numel(pks2) > 1 && numel(pks1) == numel(pks2)
                     N = max(numel(loc1));
                    if N == 1
                        d1 = sum(sqrt(sum(diff([mean(Xcont1(1:loc1(1),:),2),mean(Ycont1(1:loc1(1),:),2)]).^2,2)));
                        d2 = sum(sqrt(sum(diff([mean(Xcont2(1:loc2(1),:),2),mean(Ycont2(1:loc2(1),:),2)]).^2,2)));
                        if plot_cells
                            plot_dist(f,id,i,ob,Xcont1,Ycont1,Xcont2,Ycont2,1,loc1(1),1,loc2(1),d1,d2);
                        end
                        
                        if ~isempty(d1) && ~isempty(d2)
                            ring_dist = [ring_dist mean([d1,d2])];
                        elseif isempty(d1)
                            ring_dist = [ring_dist d2];
                        elseif isempty(d2)
                            ring_dist = [ring_dist d1];
                        end
                        
                    else
                        for k = 1:N-1
                            d1 = sum(sqrt(sum(diff([mean(Xcont1(loc1(k):loc1(k+1),:),2),mean(Ycont1(loc1(k):loc1(k+1),:),2)]).^2,2)));
                            d2 = sum(sqrt(sum(diff([mean(Xcont2(loc2(k):loc2(k+1),:),2),mean(Ycont2(loc2(k):loc2(k+1),:),2)]).^2,2)));
                            % plot the distance
                            if plot_cells
                                figure(2)
                                subplot(2,2,1)
                                findpeaks(fluor_prof,'MinPeakDistance',minpeakdistance,'MinPeakProminence',minpeakprominence);
                                title('Red')
                                h = get(gca,'children');
                                h(1).Color = [1 0 0];
                                h(2).Color = [1 0 0];
                                subplot(2,2,2)
                                findpeaks(fluor_prof2,'MinPeakDistance',minpeakdistance,'MinPeakProminence',minpeakprominence);
                                title('Blue')
                                plot_dist(f,id,i,ob,Xcont1,Ycont1,Xcont2,Ycont2,loc1(k),loc1(k+1),loc2(k),loc2(k+1),d1,d2);
                            end
                            if ~isempty(d1) && ~isempty(d2)
                                ring_dist = [ring_dist mean([d1,d2])];
                            elseif isempty(d1)
                                ring_dist = [ring_dist d2];
                            elseif isempty(d2)
                                ring_dist = [ring_dist d1];
                            end
                            close;
                        end
                        
                    end
                end
                
                
            end
        end
        
    else
        fprintf('No fluor_profile. Run fluor_contours on contour files')
        ring_dist = [];
    end
else
    fprintf('No cells structure. Run make_celltable on contour first\n')
    ring_dist = [];
end
end

function plot_dist(f,id,i,ob,Xcont1,Ycont1,Xcont2,Ycont2,LOC1,LOC2,LOC3,LOC4,d1,d2)
c0 = [0 0 1]; % color of fluorescence signal
c1 = [0 1 0];


subplot(2,2,3)
name = strsplit(f.outname,'/');
name = name(end);
name1 = strsplit(name{:},'_');
idx1 = find(strcmp(name1,'Phase'));
name1 = name1(1:idx1-1);
plotSingleCell_image_frame([strjoin(name1,'_') '_Phase.tif'],f,id,i)
title('Phase')
hold on;
a = log10(ob.fluor_profile - min(ob.fluor_profile))/log10(min(ob.fluor_profile));
c = repmat(c0,[numel(a),1]) + (repmat(c1,[numel(a),1]) - repmat(c0,[numel(a),1])).*repmat(a,[1,3]);
NN = max(size(ob.mesh,2),size(c,1));
scatter(ob.Xcont(1:NN,:),ob.Ycont(1:NN,:),5,c(1:NN,:));
plot(Xcont1(LOC1:LOC2,:),Ycont1(LOC1:LOC2,:),'Color','r')
plot(Xcont2(LOC3:LOC4,:),Ycont2(LOC3:LOC4,:),'Color','b')
%plot(Xcont1(loc1(k):loc1(k+1),:),Ycont1(loc1(k):loc1(k+1),:),'Color','r')
%plot(Xcont2(loc2(k):loc2(k+1),:),Ycont2(loc2(k):loc2(k+1),:),'Color','b')
fprintf('Cell Length: %1.2f pxl \tPeak Distance1: %1.2f pxl \tPeak Distance2: %1.2f pxl\n\n',ob.cell_length,d1,d2)
hold off;
subplot(2,2,4)
plotSingleCell_image_frame([strjoin(name1,'_') '_GFP.tif'],f,id,i)
title('GFP')
hold on;
scatter(ob.Xcont(1:NN,:),ob.Ycont(1:NN,:),5,c(1:NN,:));
plot(Xcont1(LOC1:LOC2,:),Ycont1(LOC1:LOC2,:),'Color','r')
plot(Xcont2(LOC3:LOC4,:),Ycont2(LOC3:LOC4,:),'Color','b')
hold off;
pause
end

