condition = cond{1};
length_limit = 1.5
for i = 1:numel(condition.lengths)
    
    % find peak
    [pks, loc] = findpeaks( condition.lengths{i});
    
    % find trough
    [pks1, loc1] = findpeaks(condition.lengths{i}*-1 );
    
    %if there is a single trough
    if isempty(pks) && ~isempty(pks1)
        if diff(condition.lengths{i}(loc1:end)) < length_limit
            % interval is loc1:end
        end
    
    % if there are no peaks or troughs
    elseif isempty(pks)
        if diff(condition.lengths{i}(1:end)) < length_limit
            % interval is 1:end
        end
    % if there are multiple peaks    
    elseif numel(pks) == 1
        idx = find(min(condition.lengths{i}) == condition.lengths{i});
        if idx == loc1
            if diff(condition.lengths{i}(loc1:end)) < length_limit
                % interval is loc1:end
            end
        else
            if diff(condition.lengths{i}(1:loc)) < length_limit
                % interval is 1:loc
            end
        end
    end
    pause
    hold off
end

