function saveStackMovies()
folder = [pwd '/'];
dirprefix = '*-Pos';
d = dir([folder dirprefix '*']);
for j=1:numel(d)
    if d(j).isdir
        if exist([d(j).name '-jpg.avi'],'file') ~= 2
            fprintf('%s\n',d(j).name)
            files = dir([d(j).name '/*.tif']);
            N = imfinfo([d(j).name '/' files(1).name]);
            F = zeros(N.Height,N.Width,1,numel(files));
            for i = 1:numel(files)%Number of steps
                % step to make your fig
                %              F(:,:,1,i) = uint8(255*double(imread([d(j).name '/' files(i).name]))/3000);
                F(:,:,1,i) = mat2gray(imread([d(j).name '/' files(i).name]));
                %                 F(:,:,i) = imread([d(j).name '/' files(i).name]);
            end
            v = VideoWriter([d(j).name '-jpg.avi']);
            %         v.Colormap = colormap(gray(255));
            open(v)
            writeVideo(v,F)
            close(v)
        end
    end
end
end