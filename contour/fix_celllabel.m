function f = fix_celllabel(f,varargin)
% fixes when daughter cells are labelled as mother cells by checking
% for length jumps

if numel(varargin) == 1
    tframe = varargin{1};
else
tframe = 2;
end
jumpdetectthreshold = 0.05 * tframe;

% load either structure or string name
if ~isstruct(f)
    contour = load(f);
else
    contour = f;
end

% check if f.cells exists
if ~isfield(f,'cells')
    if isfield(f,'cell')
        f.cells = f.cell;
    else
        f = make_celltable(f);
    end
end

% go through each cell
N = numel(f.cells);
for i = 1:numel(f.cells)
    frames = f.cells(i).frame;
    objs = f.cells(i).object;
    
    % get length
    length = zeros(1,numel(frames));
    for j = 1:numel(frames)
        fr = frames(j);
        ob = objs(j);
        length(j) = f.frame(fr).object(ob).cell_length;
    end
    
    if numel(length) > 3
        % calc jump
        dl = diff(length);
        locs = find(abs(dl) > jumpdetectthreshold*length(1:end-1));
        pks = length(locs);
        
        
        if isempty(pks) % if there are no peaks or troughs on the length
            continue
        else
            % get peak start and ends
            count = 0;
            %         plot(length); hold on; scatter(locs,pks); hold off; pause;
            tstart = zeros(1,numel(pks)+1);
            tend = zeros(1,numel(pks)+1);
            pk_count = 1;
            tstart(pk_count) = frames(1);
            % in between peaks
            for j = 1:numel(pks)
                tend(pk_count) = frames(locs(j));
                pk_count = pk_count + 1;
                tstart(pk_count) = frames(locs(j)+1);
            end
            tend(end) = frames(end);
            
            % reassign original cells
            
            newframes=frames(f.cells(i).frame <= tend(1));
            newobjs = objs(f.cells(i).frame <= tend(1));
            
            f.cells(i).frame = newframes;
            f.cells(i).object = newobjs;
            
            % keep track of cell ids
            cellids = zeros(1,numel(tstart));
            cellids(1) = i;
            % assign new cells
            for j = 2:numel(tstart)
                N = N + 1;
                cellids(j) = N;
                % fix cell struct
                newframes= frames(frames >= tstart(j) & frames <= tend(j));
                newobjs = objs(frames >= tstart(j) & frames <= tend(j));
                
                % fix frame struct
                f.cells(N).frame = newframes;
                f.cells(N).object = newobjs;
                
                for k = 1:numel(newframes)
                    f.frame(newframes(k)).object(newobjs(k)).cellID = N;
                end
                
                % add mother/daughter label
                f.cells(cellids(j-1)).daughter = [ f.cells(cellids(j-1)).daughter cellids(j)];
                f.cells(cellids(j)).mother = cellids(j-1);
            end
            
            
        end
    end
    
end

% % save structure
% if isstruct(f)
%     if isfield(contour,'outname')
%         name = strsplit(contour.outname,'/');
%         save(name{end},'-struct','contour');
%     end
%
% else
%     save(f,'-struct','contour');
% end
end


