 function make_kymograph(x,y,interval,Nx,Ny,abso,varargin)

if numel(varargin) == 1
    maxframe = varargin{1};
    maxvalue = max(y);
elseif numel(varargin) == 2
    maxframe = varargin{1};
    maxvalue = varargin{2};
else
    maxframe = max(x);
    maxvalue = max(y);
end

ybins = linspace(0,maxvalue,Ny);
xbins = linspace(0,maxframe,Nx);

kymo = zeros(Nx,Ny);
median_y = [];
count = 1;
for c = 1:numel(xbins)
    try
        idx = find(x < xbins(count+1) & x >= xbins(count));
    catch
        idx = find( x >= xbins(count));
    end
    [k_count,k_center] = hist(y(idx),ybins);
    if ~abso
        kymo(count,:)= k_count/sum(k_count);
    else
        kymo(count,:)= k_count;
    end
    %median_y = [median_y median(y(idx))];
    
    count = count + 1;
end

% remove empty elements
% kymo = kymo(find(sum(kymo,2)>0),:);

c = flipud(colormap('gray'));
figure(1);
im = imagesc(kymo');
colormap(c);
colorbar;
% figure(1);
% hold on;
% scatter(xbins,median_y,100,'red');

%title(title_str);
ylab = linspace(0,maxvalue,Nx);
set(gca,'Ydir','normal','Ytick',1:Ny,'YTickLabel',arrayfun(@(x) num2str(x,'%0.3f'), ybins(:), 'UniformOutput', false));
set(gca,'Xdir','normal','Xtick',1:Nx,'XTickLabel',arrayfun(@(x) num2str(x,'%0.2f'), xbins(:), 'UniformOutput', false));

end



