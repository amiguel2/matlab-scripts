condition = cond{2};
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
            plot(condition.time{i},condition.lengths{i},'b')
            hold on;
            scatter(condition.time{i},condition.lengths{i},5,'b')
            Xlim = get(gca,'Xlim');
            plot(condition.time{i}(loc1):round(Xlim(2)),condition.lengths{i}(loc1)*ones(round(Xlim(2))-condition.time{i}(loc1)+1,1),'r')
            plot(round(Xlim(1)):round(Xlim(2)),condition.lengths{i}(end)*ones(round(Xlim(2))-round(Xlim(1))+1,1),'r')
            fprintf('1 Dist = %f - %f = %f\n',condition.lengths{i}(end),condition.lengths{i}(loc1),condition.lengths{i}(end)-condition.lengths{i}(loc1))
        else
            plot(condition.time{i},condition.lengths{i},'r')
            hold on;
            scatter(condition.time{i},condition.lengths{i},5,'r')
            fprintf('Skip cell %d ... trajectory not smooth\n',i)
        end
    
    % if there are no peaks or troughs
    elseif isempty(pks)
        if diff(condition.lengths{i}(1:end)) < length_limit
            % interval is 1:end
            plot(condition.time{i},condition.lengths{i},'b')
            hold on;
            scatter(condition.time{i},condition.lengths{i},5,'b')
            Xlim = get(gca,'Xlim');
            plot(round(Xlim(1)):round(Xlim(2)),condition.lengths{i}(1)*ones(round(Xlim(2))-round(Xlim(1))+1,1),'r')
            plot(round(Xlim(1)):round(Xlim(2)),condition.lengths{i}(end)*ones(round(Xlim(2))-round(Xlim(1))+1,1),'r')
            fprintf('Dist = %f - %f = %f\n',condition.lengths{i}(end),condition.lengths{i}(1),condition.lengths{i}(end)-condition.lengths{i}(1))
        else
            plot(condition.time{i},condition.lengths{i},'r')
            hold on;
            scatter(condition.time{i},condition.lengths{i},5,'r')
            fprintf('Skip cell %d ... trajectory not smooth\n',i)
        end
    % if there are multiple peaks    
    elseif numel(pks) > 1
        plot(condition.time{i},condition.lengths{i},'r')
        hold on;
        scatter(condition.time{i},condition.lengths{i},5,'r')
        fprintf('Skip cell %d ... too noisy\n',i)
    % if pks == 1
    else
        idx = find(min(condition.lengths{i}) == condition.lengths{i});
        if idx == loc1
            if diff(condition.lengths{i}(loc1:end)) < length_limit
                % interval is loc1:end
                plot(condition.time{i},condition.lengths{i},'b')
                hold on;
                scatter(condition.time{i},condition.lengths{i},5,'b')
                Xlim = get(gca,'Xlim');
                plot(condition.time{i}(loc1):round(Xlim(2)),condition.lengths{i}(loc1)*ones(round(Xlim(2))-condition.time{i}(loc1)+1,1),'r')
                plot(round(Xlim(1)):round(Xlim(2)),condition.lengths{i}(end)*ones(round(Xlim(2))-round(Xlim(1))+1,1),'r')
                fprintf('3 Dist = %f - %f = %f\n',condition.lengths{i}(end),condition.lengths{i}(1),condition.lengths{i}(end)-condition.lengths{i}(1))
            else
                plot(condition.time{i},condition.lengths{i},'r')
                hold on;
                scatter(condition.time{i},condition.lengths{i},5,'r')
                fprintf('Skip cell %d ... trajectory not smooth\n',i)
            end
        else
            if diff(condition.lengths{i}(1:loc)) < length_limit
                % interval is 1:loc
                plot(condition.time{i},condition.lengths{i},'b')
                hold on;
                scatter(condition.time{i},condition.lengths{i},5,'b')
                Xlim = get(gca,'Xlim');
                plot(round(Xlim(1)):condition.time{i}(loc),condition.lengths{i}(1)*ones(condition.time{i}(loc)-round(Xlim(1))+1,1),'r')
                plot(round(Xlim(1)):condition.time{i}(loc),condition.lengths{i}(loc)*ones(condition.time{i}(loc)-round(Xlim(1))+1,1),'r')
                fprintf('4 Dist = %f - %f = %f\n',condition.lengths{i}(loc),condition.lengths{i}(1),condition.lengths{i}(loc)-condition.lengths{i}(1));
            else
                plot(condition.time{i},condition.lengths{i},'r')
                hold on;
                scatter(condition.time{i},condition.lengths{i},5,'r')
                fprintf('Skip cell %d ... trajectory not smooth\n',i)
            end
        end
    end
    pause
    hold off
end

