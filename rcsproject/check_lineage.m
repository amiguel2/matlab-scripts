function lineage = check_lineage(f,c,varargin)
% checks if cell has a mother and daughter cell that point to eachother for lineage tracking
% purposes. Checks if cell_length look appropriate.


if numel(varargin)>0
    fr = varargin{1};
    cid = varargin{2};
end

if ~isstruct(f)
    f = load(f);
end

if ~isfield(f,'cell')
    f.cell = f.cells;
end

lineage=0;

try
    fra = f.cell(c).frames;
catch
    fra = f.cell(c).frame;
end

if fra(end) ~= numel(f.frame)
    mothercell = find_mothercell(f,c);
    if ~isempty(mothercell) % does mother cell exist?
        daughtercell = find_daughtercell(f,c); %f.cell(c).daughter_cells;%
        if ~isempty(daughtercell) && numel(daughtercell) == 2% does daughter cell exist and does daughter cell match mother cell?
            lineage = 1;
        end
    end
end

end
