function cells = get_cell(f)
    maxcell = max(extractfield(f.frame(end).object,'cellID'));
    frame_list = cell(1,maxcell);
    cell_id = cell(1,maxcell);
    cells = struct;
    for i = 1:maxcell
        f_l = [];
        for j = 1:numel(f.frame)
            if find(extractfield(f.frame(j).object,'cellID') == i)
                f_l = [f_l j];
            end
        end
        cell_id{1,int8(i)} = i;
        frame_list{1,int8(i)} = f_l;

    end
    
    cells.cellid = cell_id;
    cells.frame = frame_list;

end