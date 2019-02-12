function handles = set_handles(preffile)
    load(preffile,'f_*','v_*')
    handles.edit_cannylow=num2str(f_canny_th1);
    handles.edit_cannyhigh=num2str(f_canny_th2);
    handles.edit_cannysigma=num2str(f_canny_sig);
    handles.checkbox_help = 0;
    handles.edit_resize=num2str(f_resize);
    handles.edit_back=num2str(f_back);
    handles.edit_histlim=num2str(f_histlim);
    handles.edit_min_area=num2str(f_areamin);
    handles.edit_max_area=num2str(f_areamax);
    handles.edit_primary=num2str(f_hmin);
    handles.edit_secondary=num2str(f_hmin_split);
    handles.edit_smooth=num2str(f_gstd);
    handles.edit_force_smooth=num2str(f_r_int);
    handles.edit_overlap=num2str(f_pert_same);
    handles.edit_frame=num2str(f_frame_diff);
    
    
    switch v_imtype
        case 1
            handles.checkbox_phase = 1;
            handles.checkbox_fluor_int=0;
            handles.checkbox_fluor_periphery=0;
        case 2
            handles.checkbox_phase=0;
            handles.checkbox_fluor_int=1;
            handles.checkbox_fluor_periphery=0;
        case 3
            handles.checkbox_phase=0;
            handles.checkbox_fluor_int=0;
            handles.checkbox_fluor_periphery=1;
    end
    
    handles.checkbox_indpt=v_indpt;
    handles.checkbox_prox=v_prox;
    handles.checkbox_save=v_save;
    handles.checkbox_falsepos=v_falsepos;
    handles.checkbox_advanced=v_advanced;
    handles.checkbox_seed=v_seed;
    handles.checkbox_manualtrack=v_manualtrack;
    handles.checkbox_mip_persist=v_persist;
    handles.checkbox_colorcode=v_colorcode;
    
    handles.checkbox_keeptemp=0;
    handles.checkbox_savetest=0;
    
    handles.checkbox_meshmotif=v_meshmotif;
    handles.checkbox_mm_mesh=v_mm_mesh;
    handles.checkbox_mt_mesh=v_mt_mesh;
    
   
end