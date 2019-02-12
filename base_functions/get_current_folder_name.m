function f = get_current_folder_name()
f = strsplit(pwd,'/');
f = f{end};
end