function Fluo_internal_generate(contfile,fname1)
tic
% function Fluo_internal_generate(image_directory, contour_directory)
%This function opens the image and its corresponding contour file that has
%been analyzed by Morphometrics, then takes each cell and make a new field
% fluor_internal_profile associated with each cell. Also calculates local
% background

    changes = 0;
    s = load(contfile);

    % loop over all frames
    for i=1:length(s.frame)
        im = imread(fname1, i);
        fprintf(' %d',i);
        for j=1:numel(s.frame(i).object)
            data = s.frame(i).object(j);
            
              % skip if variable AND value are present
              try
                  if ~isempty(data.fluor_internal_profile)
                      continue
                  end
              catch
                  if isfield(data, 'fluor_internal_profile')
                      continue
                  end
              end
%             
                if numel(data.area)>0 && ~isempty(data.Xcont) %&& ~isfield(data, 'fluor_internal_profile')
                    if changes == 0
                        changes = 1;
                    end
                    xs = data.Xcont;
                    ys = data.Ycont;
                    
                    [fl, bkg] = Internal_fluor(xs,ys,im);
                    
                    s.frame(i).object(j).fluor_internal_profile = fl;
                    s.frame(i).object(j).bkg = bkg;
                else
                    s.frame(i).object(j).fluor_internal_profile = NaN;
                    s.frame(i).object(j).bkg = NaN;
                end
            %end
        end
    end
    if changes  % save only if changes were made
        save(contfile,'-struct','s');
    end
    fprintf('...Done!\n')
    toc
end
