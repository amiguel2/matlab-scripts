function print_uplc_names(files,dir)
for i = 1:numel(files)
    fprintf('var%d = load(''%s%s'')\n',i,dir,files(i).name);
end