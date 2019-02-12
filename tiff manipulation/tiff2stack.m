function tiff2stack(filenamepattern,filenameout,varargin)
%TIFF2STACK    generates a single multiframe tiff stack from a list of tiff
%              files matching 'filenamepattern'. The multiframe tiff is
%              written out to 'filenameout'.
%TIFF2STACK assumes that the tiff files are numerically and unambiguously
% sortable. Typical outputs from micromanager achieve this.
%TIFF2STACK(...,...,'nframe',N) will only combine the first N sorted images.

%default variable
nframe = Inf;
splitchannel = 0;
deepcellformat = 0;

%input variable handler

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. See instructions')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

filenames = dir(filenamepattern);

if length(filenames) > 1
    if ~splitchannel % if all images from the same channel
        if ~deepcellformat
        imwrite(uint16(imread(filenames(1).name,'tif')),filenameout); % First write out the file.
        for l = 2:min([length(filenames),nframe]);
            imwrite(uint16(imread(filenames(l).name)), filenameout,'writemode','append'); % then append to it:
        end
        else
        tmp1 = cellfun(@(x) x(17:end),{filenames.name},'UniformOutput',false);
        tmp2 = cellfun(@(x) strsplit(x,'.tif'),tmp1,'UniformOutput',false);
        tmp3 = cellfun(@(x) x{:},tmp2,'UniformOutput',false);
        tmp4 = cellfun(@str2num,tmp3,'UniformOutput',false);
        tmp5 = [tmp4{:}] + 1;
        for l = min(tmp5):max(tmp5)
            idx = find(l == tmp5);
            imwrite(uint16(imread(filenames(idx).name)), filenameout,'writemode','append');
        end
            
            
        end
    else % if multiple channels
        tmp = strsplit(filenameout,'.tif');
        fo1 = [tmp{1} '-1.tif'];
        fo2 = [tmp{1} '-2.tif'];
        for l = 1:min([length(filenames),nframe])
                imwrite(uint16(imread(filenames(l).name,1)), fo1,'writemode','append');
                imwrite(uint16(imread(filenames(l).name,2)), fo2,'writemode','append');
        end
    end    
else
    imwrite((imread(filenames(1).name)), filenameout,'writemode','append'); % write out the file.
end

end