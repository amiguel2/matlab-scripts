function f = test_lineage(f)
    fprintf('Total cells: %d\n',numel(f.cell))
    for i = 1:numel(f.cell)
        fprintf('cell: %d\n',i)
        fr = f.cell(i).frames;
        cid = f.cell(i).bw_label;
%         f.cell(i).mother_cell = find_mothercell(f,i);
%         f.cell(i).daughter_cells = find_daughtercell(f,i);
        result = check_lineage(f,i);
        f.cell(i).lineage = result;
    end
end