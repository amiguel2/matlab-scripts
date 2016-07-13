function [fdist,ftime_interval] = length_diff_contourfile_mod(f,length_limit,exclude_t,roc_on)
% load contour file
if ~isstruct(f)
    f = load(f);
end

%the delta L and time interval metrics
fdist = [];
ftime_interval = [];

for i = 1:numel(f.cell)
    cellid = i;
    fr = f.cell(cellid).frames;
    cid = f.cell(cellid).bw_label;
    if fr(1) > exclude_t
        if check_lineage(f,i);
            % if starting frame greater than time cut off
            [d,t] = get_deltalen(f,i,fr,cid,length_limit,roc_on);
            fdist = [fdist d];
            ftime_interval = [ftime_interval t];
        end
    end
end
end

function [dist,time_interval] = get_deltalen(f,c,fr,cid,length_limit,roc_on)

dist = []; % distance between final and starting length
time_interval = []; % % time interval between final and starting length

% cell lengths and frames
[clengths,cframes] = get_length(f,fr,cid,roc_on);

% if cell length greater than 5
if numel(clengths) > 5
    % find peak
    [pks, loc] = findpeaks(clengths);
    % find trough
    [pks1, loc1] = findpeaks(clengths*-1 );
    
    %if there is a single trough
    if isempty(pks) && ~isempty(pks1)
        dist = clengths(end)-clengths(loc1);
        time_interval =  cframes(end)-cframes(loc1);
        %fprintf('Type 1 cell %d: %.2f\n',c,dist)
        
        % if there are no peaks or troughs
    elseif isempty(pks)
        if diff(clengths(1:end)) < length_limit
            
            dist =  clengths(end)-clengths(1);
            time_interval = cframes(end)-cframes(1);
            %fprintf('Type 2 cell %d: %.2f\n',c,dist)
            
        end
        % if there are multiple peaks
    elseif numel(pks) > 1
        idx = find(min(clengths) == clengths);
        if idx == loc1
            if diff(clengths(loc1:end)) < length_limit
                
                dist = clengths(end)-clengths(loc1);
                time_interval = cframes(end)-cframes(loc1);
                %fprintf('Type 3 cell %d: %.2f\n',c,dist)
            end
        else
            if diff(clengths(1:loc)) < length_limit
                if abs(diff(clengths(loc:loc+1))) > clengths(loc)*0.1
                    % interval is 1:loc
                    
                    dist = clengths(loc)-clengths(1);
                    time_interval = cframes(loc)-cframes(1);
                    %fprintf('Type 4 cell %d: %.2f\n',c,dist)
                end
            end
        end
    end
end
end

function [clengths cframes] = get_length(f,fr,cid,roc_on)
clengths = [];
cframes = [];

%% get lengths/frames using same automation parameters (except ob.roc if desired)
for j = 1:numel(fr)
    ob = f.frame(fr(j)).object(cid(j));
    if ob.on_edge == 0
        if roc_on
            if ob.roc == 1;
                clengths = [clengths ob.cell_length];
                cframes = [cframes fr(j)];
            end
        else
            clengths = [clengths ob.cell_length];
            cframes = [cframes fr(j)];
        end
    end
end
end





