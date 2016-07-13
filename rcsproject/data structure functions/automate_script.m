% run this in the appropriate folder with the contour stacks


clear;
output='stack7-example.mat';
prefix = {'stack7*.mat'};
%prefix = {'stack1*CONTOURS.mat','stack2*CONTOURS.mat','stack3*CONTOURS.mat','stack5*CONTOURS.mat'};
%titstr={'DH300 pNG162-Empty','DH300 pNG162-WT','DH300 pNG162-Peri','DH300 pNG162-IM'};
titstr={'DH300 pNG162-Peri'}
tperframe = 2;
pxl =0.08;
fluor_present = 1;
roc_filter = 0;

%%

cond = cell(1,numel(prefix));
for idx = 1:numel(prefix)
    list = dir(prefix{idx});
    count = 0;
    cond_lengths = {};
    cond_time = {};
    cond_widths = {};
    growthrates = {};
    cond_newcell = {};
    cond_avg_fluor = {};
    cond_fluor_prof = {};
    cond_kappa = {};
    cond_area = {};
    cond_Xcont = {};
    cond_Ycont = {};
    cond_mesh = {};
    cond_cfile = {};
    cond_cid = {};
    
    for a = 1:numel(list)
        f = load(list(a).name);
        % mesh if haven't meshed
        if ~isfield(f.frame(1).object,'mesh')
            mesh_contours
            f = load(list(a).name);
        end
        % roc if haven't roc
        if ~isfield(f.frame(1).object,'roc')
            roc_contours
            f = load(list(a).name);
        end
        % fluor if haven't fluor
        if fluor_present == 1
            if ~isfield(f.frame(1).object,'ave_fluor')
                fluor_contours
                f = load(list(a).name);
            end
        end
        cfile = list(a).name;
        for i = 1:numel(f.cell) % loop through all individual cells
            frames = f.cell(i).frames; % grab frames it is present in
            label = f.cell(i).bw_label; % grab the label in that frame
            lengths = []; % make empty vectors for length and time
            t = [];
            widths = [];
            areas = [];
            Xcont = {};
            Ycont = {};
            mesh = {};
            kappa = {};
            cid = [];
            if fluor_present
                avf = [];
                fp = {};
            end
            for j = 1:numel(frames) % loop through the vector of frames
                ob = f.frame(frames(j)).object(label(j)); % grab the cell object using label
                if ob.on_edge == 0  % check if the cell was processed
                    if roc_filter == 1
                        if ob.roc == 1 % passed filter
                            Xcont = [Xcont {ob.Xcont}];
                            Ycont = [Ycont {ob.Ycont}];
                            mesh = [mesh {ob.mesh}];
                            areas = [areas ob.area*pxl^2];
                            lengths = [lengths ob.cell_length*pxl]; % add lengths and time
                            t = [t frames(j)*tperframe-(tperframe-1)];
                            cid = [cid label(j)];
                            widths = [widths ob.cell_width*pxl];
                            kappa = [kappa {ob.kappa_raw}];
                            if fluor_present
                                avf = [avf ob.ave_fluor/pxl];
                                fp = [fp {ob.fluor_profile}];
                            end
                        end
                    else
                        Xcont = [Xcont {ob.Xcont}];
                        Ycont = [Ycont {ob.Ycont}];
                        mesh = [mesh {ob.mesh}];
                        areas = [areas ob.area*pxl^2];
                        lengths = [lengths ob.cell_length*pxl]; % add lengths and time
                        t = [t frames(j)*tperframe-(tperframe-1)];
                        cid = [cid label(j)];
                        widths = [widths ob.cell_width*pxl];
                        kappa = [kappa {ob.kappa_raw}];
                        if fluor_present
                            avf = [avf ob.ave_fluor/pxl];
                            fp = [fp {ob.fluor_profile}];
                        end
                    end
                end
            end
            
            idx1 = find_smooth_traj(areas);
            if numel(idx1) > 3
                if ~isempty(t)
                    count = count + 1;
                end
                
                % take growthrate from smooth part of trajectory
                p = polyfit(t(idx1),log(areas(idx1)),1);
                
                growthrates = [growthrates p(1)];
                cond_lengths = [cond_lengths lengths];
                cond_time = [cond_time t];
                cond_widths = [cond_widths widths];
                cond_area = [cond_area areas];
                cond_kappa = [cond_kappa {kappa}];
                cond_Xcont = [cond_Xcont {Xcont}];
                cond_Ycont = [cond_Ycont {Ycont}];
                cond_mesh = [cond_mesh {mesh}];
                cond_cfile = [cond_cfile cfile];
                cond_cid = [cond_cid cid];
                if fluor_present
                    cond_avg_fluor = [cond_avg_fluor avf];
                    cond_fluor_prof = [cond_fluor_prof {fp}];
                end
                
            end
            
        end
    end
    cond{idx} = setfield(cond{idx},'title',titstr{idx});
    cond{idx} = setfield(cond{idx},'growthrate',growthrates);
    cond{idx} = setfield(cond{idx},'lengths',cond_lengths);
    cond{idx} = setfield(cond{idx},'time',cond_time);
    cond{idx} = setfield(cond{idx},'widths',cond_widths);
    cond{idx} = setfield(cond{idx},'areas',cond_area);
    cond{idx} = setfield(cond{idx},'kappa',cond_kappa);
    cond{idx} = setfield(cond{idx},'Xcont',cond_Xcont);
    cond{idx} = setfield(cond{idx},'Ycont',cond_Ycont);
    cond{idx} = setfield(cond{idx},'mesh',cond_mesh);
    cond{idx} = setfield(cond{idx},'pxl',pxl);
    cond{idx} = setfield(cond{idx},'tperframe',tperframe);
    cond{idx} = setfield(cond{idx},'cfile',cond_cfile);
    cond{idx} = setfield(cond{idx},'cid',cond_cid);
    if fluor_present
        cond{idx} = setfield(cond{idx},'ave_fluor',cond_avg_fluor);
        cond{idx} = setfield(cond{idx},'fluor_prof',cond_fluor_prof);
    end
end
save(output,'cond')



