function [length,width]=extractlw_cells(f)
length = [];
width = [];
for i = 1:numel(f.frame)
    for j = 1:numel(f.frame(i))
        if f.frame(i).num_objs > 0
            length = [length extractfield(f.frame(i).object,'cell_length')];
            width = [width extractfield(f.frame(i).object,'cell_width')];
        end
    end
end

end