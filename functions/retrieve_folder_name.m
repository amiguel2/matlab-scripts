function [folder,file] = retrieve_folder_name(full_filename,dirpath)
   s = strsplit(full_filename,[dirpath '/']);
   s = s{2};
   s1 = strsplit(s,'/');
   folder = s1{1};
   file = s1{2};

end