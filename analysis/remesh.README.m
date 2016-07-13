%% variables
a_fileprefix = 'Pos';
a_filelist = dir([a_fileprefix,'*.mat']);
a_filelist2 = dir([a_fileprefix,'*_GFP.tif']);

a_params.pxl_size = 0.064; % pixel scaling
a_params.color0 = [1 0 0]; % colors for plotting lines
a_params.color1 = [0 1 1];
a_params.roc_filter = 1;

%% step 2 mesh cells
a_fn = numel(a_filelist)
for a_j=1:a_fn
    fprintf('Meshing %s...',a_filelist(a_j).name)
    MT_mesh_CT('.',a_filelist(a_j).name);
    if size(a_filelist2,1) ~= 0
        fprintf('Calculating fluorescence profiles for %s...',a_filelist(a_j).name)
        calculate_fluor_profiles(a_filelist(a_j).name,a_filelist2(a_j).name,'',[]);
    end
end










% do not redo fluor_profil
try
    exist(s.frame(1).object(1).fluor_profile
    disp('Already calculated fluorescence profile')
    return
catch err
    disp('Not yet calculated fluorescence profile: commencing calculation')
end


%% do not remesh

try
    exist(frame(1).object(1).MT_width);
    %isempty(frame(1).object(1).MT_width)
    disp('Already Meshed')
    return
catch err
    fprintf('Not yet Meshed: commencing meshing')
end

%% prompt remesh


try
    exist(frame(1).object(1).MT_width);
    %isempty(frame(1).object(1).MT_width)
    prompt = 'Already Meshed...remesh? (Y/N)[N]: ';
    str = input(prompt,'s');
    if isempty(str)
        str = 'N';
    end
    if str == 'N'
        disp('Not remeshing...\n')
        return
    else
        fprintf('Commencing remeshing...\n')
    
catch err
    fprintf('Not yet Meshed: commencing meshing?\n')
end