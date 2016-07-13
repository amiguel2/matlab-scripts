function f= hist_transparent(data,varargin)
if numel(varargin) == 3
    bin = varargin{1};
    colors = varargin{2};
    face = varargin{3};
elseif numel(varargin) == 2
    bin = varargin{1};
    colors = varargin{2};
    face = 1;
elseif numel(varargin) == 1
    bin = varargin{1};
    colors = [1 0 0];
    face = 1;
elseif numel(varargin) == 0
    bin = 50;
    colors = [1 0 0];
    face = 1;
end

[counts,centers] = hist(data,bin);
if size(centers,1) ~= 1
    centers = centers';
end
if face
f = fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors,'FaceAlpha',0.1,'EdgeColor',colors);
else
    f = fill([centers(1) centers centers(end)],[0 counts/sum(counts) 0],colors,'FaceAlpha',0,'EdgeColor',colors);
end
end