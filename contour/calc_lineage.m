function f = calc_lineage(f)
if ~isfield(f,'cells')
    f = make_celltable(f);
end

% populate mother and daughter guesses
percentcompleted = 0.1;
if ~isfield(f,'cells')
    f.cells = f.cell;
end

f.cells = rmfield(f.cells,'mother');
f.cells = rmfield(f.cells,'daughter');
f.cells(1).mother = [];
f.cells(1).daughter = [];

cells = find(cellfun(@numel,{f.cells.frame}) > 3);
count = 0;
for i = cells
    count = count + 1;
     if isempty(f.cells(i).mother)
        
        [mothercell] = find_mothercell(f,i);
        
        %assign
        if ~isnan(mothercell)
            f.cells(i).mother = mothercell;
            f.cells(mothercell).daughter = [f.cells(mothercell).daughter i];
        end
        
     end
    
%     if numel(f.cells(i).daughter) < 2
%         
%         daughter_cells = get_daughter(f,i);
%         
%         %assign
%         f.cells(i).daughter = daughter_cells;
%         for j = daughter_cells
%             f.cells(j).mother = i;
%         end
%     end
    
    
    if (count/numel(cells) > percentcompleted)
        percentcompleted = percentcompleted + 0.1;
        fprintf(' . ')
    end
end
fprintf('Done!\n');
% save file
%     savecontour(f)

end

function savecontour(f)
% saving contour file with mother/daughter info
name = strsplit(f.outname,'/');
% dealing with cell vs string
try
    save(name(end),'-struct','f');
catch
    save(name{end},'-struct','f');
end

end

function [mothercell] = find_mothercell(f,c)
% finds daughter cells of a specified cellid in contour file using overlap
% method and checking if area of daughter/mother looks correct. Ignores overlap less
% than 10%

mothercell = NaN;

fr = f.cells(c).frame;
cid = f.cells(c).object;
[fr,cid] = remove_nocells(f,fr,cid);

if isempty(fr)
    return
end

startframe = fr(1);
startid = cid(1);

% if starting frame
if fr(1) == 1
    return
end

xstart = f.frame(startframe).object(startid).Xcont; %get segmented image for target cell
ystart = f.frame(startframe).object(startid).Ycont;
p_overlap_formother = 0;

%% get potential mothers
if f.frame(startframe-1).num_objs == 0
    return
end
potential_mothers = extractfield(f.frame(startframe-1).object,'cellID');
try
    potential_mothers = [ potential_mothers extractfield(f.frame(startframe-2).object,'cellID')];
catch
end
potential_mothers = unique(potential_mothers);

%% go through potential mothers
for a = potential_mothers
    
    if f.cells(a).frame(end) < fr(1) && sum(f.cells(a).frame == fr(1)-1) == 1 %some cells have bad labelling. Using this to skip them
        % if cell frames match and cell isn't assigned twice to the
        % same frame (some cells have bad labelling Using this to skip them)
        frnew_mother = f.cells(a).frame(end);
        cidnew_mother = f.cells(a).object(end);
        if ~isempty(f.frame(frnew_mother).object(cidnew_mother).area)
            
            %get segmented image for target cell
            xmothercell = f.frame(frnew_mother).object(cidnew_mother).Xcont;
            ymothercell = f.frame(frnew_mother).object(cidnew_mother).Ycont;
            
            percent_overlap_formother = get_overlap(xstart,ystart,xmothercell,ymothercell);
            
            if percent_overlap_formother > p_overlap_formother && percent_overlap_formother > 0.1 && f.frame(frnew_mother).object(cidnew_mother).area > f.frame(fr(1)).object(cid(1)).area % at least overlap greater than 10%
                mothercell = a; %record that cell
                p_overlap_formother = percent_overlap_formother;
            end
        end
    end
end



end

function percent = get_overlap(x1,y1,x2,y2)
[x1,y1] = poly2cw(x1,y1);
[x2,y2] = poly2cw(x2,y2);
[intsX,intsY] = polybool('intersection',x1,y1,x2,y2);
[unionX,unionY] = polybool('union',x1,y1,x2,y2);
percent = polyarea(intsX,intsY)/polyarea(unionX,unionY);
end


function [newfr,newcid] = remove_nocells(f,fr,cid)
newfr = [];
newcid = [];
for i = 1:numel(fr)
    if ~isempty(f.frame(fr(i)).object(cid(i)).area)
        newfr = [newfr fr(i)];
        newcid = [newcid cid(i)];
    end
end
end

function daughter_cells = get_daughter(f,c)


daughter_cells = [];
daughter_cells = [daughter_cells f.cells(c).daughter];
if numel(daughter_cells) == 2
    return
end

fr = f.cells(c).frame;
cid = f.cells(c).object;
[fr,cid] = remove_nocells(f,fr,cid);

if isempty(fr)
    return
end

% if last frame
if fr(end) == numel(f.frame)
    return
end

% daughtercell
startframe = fr(1);
startid = cid(1);
endframe = fr(end);
endid = cid(end);
xend = f.frame(endframe).object(endid).Xcont;
yend = f.frame(endframe).object(endid).Ycont;



%% get potential daughters
potential_mothers = [];
try
potential_mothers = extractfield(f.frame(startframe-1).object,'cellID');
potential_mothers = unique(potential_mothers);
catch
end

if f.frame(endframe+1).num_objs ==0
    return
end
potential_daughters = extractfield(f.frame(endframe+1).object,'cellID');
try
    potential_daughters = [ potential_daughters extractfield(f.frame(endframe+1).object,'cellID')];
catch
end
potential_daughters = unique(potential_daughters);
potential_daughters = setdiff(potential_daughters,potential_mothers); % remove potential mothers
potential_daughters = setdiff(potential_daughters,daughter_cells); % remove any already confirmed daughters


daughtercell = [];
p_overlap_fordaughter = [];
for a = potential_daughters
    % daughter
    if f.cells(a).frame(1) > endframe
        % if cell frames match and cell isn't assigned twice to the
        % same frame (some cells have bad labelling Using this to skip them)
        if (f.cells(a).frame(1) == fr(end)+1) && (numel(f.cells(a).frame == fr(end)+1) == 1)
            %get mask of new cell
            frnew_daughter = f.cells(a).frame(1);
            cidnew_daughter = f.cells(a).object(1);
            if ~isempty(f.frame(frnew_daughter).object(cidnew_daughter).area)
                
                %get segmented image for target cell
                xdaughtercell = f.frame(frnew_daughter).object(cidnew_daughter).Xcont;
                ydaughtercell = f.frame(frnew_daughter).object(cidnew_daughter).Ycont;

                
                percent_overlap_fordaughter = get_overlap(xend,yend,xdaughtercell,ydaughtercell);
                % record cell if percent overlap is creater than 10%
                % and area of daughter is less than mother
                if percent_overlap_fordaughter > 0.1 && f.frame(frnew_daughter).object(cidnew_daughter).area < f.frame(fr(end)).object(cid(end)).area
                    daughtercell = [daughtercell a];
                    p_overlap_fordaughter = [p_overlap_fordaughter percent_overlap_fordaughter];
                end
            end
        end
    end
end

while numel(daughter_cells) < 2 && ~isempty(daughtercell)
    idx = find(max(p_overlap_fordaughter));
    daughter_cells = [daughter_cells daughtercell(idx)];
    p_overlap_fordaughter(idx) = [];
    daughtercell(idx) = [];
end
    
end