function [fdist,ftime_interval] = length_diff(condition,length_limit,exclude_t)

fdist = [];
ftime_interval = [];
for i = 1:numel(condition.lengths)
    
    if condition.time{i}(1) > exclude_t %&& condition.time{i}(end) ~= max([condition.time{:}])
        
        if exist('f','var')
            tmp = strsplit(f.outname,'/');
            if ~strcmp(tmp(end),condition.cfile{i})
                f = load(condition.cfile{i});
                fprintf('%s\n',condition.cfile{i})
            end
        else
        f = load(condition.cfile{i});
        fprintf('%s\n',condition.cfile{i})
        end
        
        [d,t] = get_len(condition,f,i,length_limit);
        fdist = [fdist d];
        ftime_interval = [ftime_interval t];
    end
end
end

function [dist,time_interval] = get_len(condition,f,i,length_limit)
dist = [];
time_interval = [];
[pks, loc] = findpeaks(condition.lengths{i});

% find trough
[pks1, loc1] = findpeaks(condition.lengths{i}*-1 );

%if there is a single trough
if isempty(pks) && ~isempty(pks1)
    if diff(condition.lengths{i}(loc1:end)) < length_limit
        % interval is loc1:end
        fr = round(condition.time{i}/2);
        cid = condition.cid{i};
        c = f.frame(fr(1)).object(cid(1)).cellID;
        
        daughtercell = find_daughtercell(f,c);
        if get_startlen(f,daughtercell) < f.frame(fr(end)).object(cid(end)).cell_length
            dist = condition.lengths{i}(end)-condition.lengths{i}(loc1);
            time_interval =  condition.time{i}(end)-condition.time{i}(loc1);
        end
    end
    
    % if there are no peaks or troughs
elseif isempty(pks)
    if diff(condition.lengths{i}(1:end)) < length_limit
        % interval is 1:end
        fr = round(condition.time{i}/2);
        cid = condition.cid{i};
        c = f.frame(fr(1)).object(cid(1)).cellID;
        if check_lineage(f,c,fr,cid)
            dist =  condition.lengths{i}(end)-condition.lengths{i}(1);
            time_interval = condition.time{i}(end)-condition.time{i}(1);
        end
    end
    % if there are multiple peaks
elseif numel(pks) == 1
    idx = find(min(condition.lengths{i}) == condition.lengths{i});
    if idx == loc1
        if diff(condition.lengths{i}(loc1:end)) < length_limit
            % interval is loc1:end
        fr = round(condition.time{i}/2);
        cid = condition.cid{i};
        c = f.frame(fr(1)).object(cid(1)).cellID;
            daughtercell = find_daughtercell(f,c);
            if get_startlen(f,daughtercell) < f.frame(fr(end)).object(cid(end)).cell_length
                dist = condition.lengths{i}(end)-condition.lengths{i}(loc1);
                time_interval = condition.time{i}(end)-condition.time{i}(loc1);
            end
        end
    else
        if diff(condition.lengths{i}(1:loc)) < length_limit
            % interval is 1:loc
        fr = round(condition.time{i}/2);
        cid = condition.cid{i};
        c = f.frame(fr(1)).object(cid(1)).cellID;
            mothercell = find_mothercell(f,c);
            if get_endlen(f,mothercell) > get_startlen(f,c)
                dist = condition.lengths{i}(loc)-condition.lengths{i}(1);
                time_interval = condition.time{i}(loc)-condition.time{i}(1);
            end
        end
    end
end
end



