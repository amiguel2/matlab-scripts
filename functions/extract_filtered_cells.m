
function [frame,cellid] = extract_filtered_cells(contour_file,curv_thresh)

    f = load(contour_file);
    total = 0;
    
    cellid = [];
    frame = [];
    
    for i = 1:length(f.frame)
        for j = 1:length(f.frame(i).object)
            if isfield(f.frame(i).object(j),'MT_mesh') && length(f.frame(i).object(j).MT_mesh) > 0
                if f.frame(i).object(j).kappa_smooth > curv_thresh
                    cellid = [cellid f.frame(i).object(j).cellID];
                    frame = [frame i];
                    %fprintf('Frame: %d, Cell ID: %d\n',i,f.frame(i).object(j).cellID)
                    total = total + 1;
                end
            elseif isfield(f.frame(i).object(j),'mesh') && length(f.frame(i).object(j).mesh) > 0
                if f.frame(i).object(j).kappa_smooth > curv_thresh
                    cellid = [cellid f.frame(i).object(j).cellID];
                    frame = [frame i];
                    %fprintf('Frame: %d, Cell ID: %d\n',i,f.frame(i).object(j).cellID)
                    total = total + 1;
                end
            
            end
            
        end
    end

%fprintf('Total: %d\n',total)
end
