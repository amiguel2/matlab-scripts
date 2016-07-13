function idx = find_smooth_traj(data,varargin)
        if numel(varargin) == 1
            thresh = varargin{1};
        else
            thresh = 0;
        end
        idx = find(diff(data) < thresh,2);
        if isempty(idx)
            idx = 1:numel(data);
        elseif idx(1) == 1 & numel(idx) == 1
            idx = 2:numel(data);
        elseif idx(1) == 1 & numel(idx) > 1
            idx = 2:idx(2);
        else
            idx = 1:idx(1);
        end
end