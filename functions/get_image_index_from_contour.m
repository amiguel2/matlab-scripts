% Given a contour file, finds the matching .tif stack with a similar
% prefix. Profide the suffix of the contour and tif stack that don't
% overlap

function idx = get_image_index_from_contour(contour_name,image_list,contour_suffix,image_suffix)
    n = strsplit(contour_name,contour_suffix);
    n = n(1);
    for i = 1:length(image_list)
        tmp = strsplit(image_list(i).name,image_suffix);
        tmp = tmp(1);
        result = strcmp(n,tmp);
        if result == 1
            idx = i;
            break
        else
            idx = NaN;
        end
    end
end