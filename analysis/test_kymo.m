pnum = '06';
load(['Pos',pnum,'_CONTOURS']);


%% loop over all cells
for i=1:numel(cell)
    disp(i);
    clear fl num;
    count = 0;
    for j=1:numel(cell(i).frames)
        f = cell(i).frames(j);
        c = cell(i).bw_label(j);

        data = frame(f).object(c);
        if isfield(data,'fluor_profile') & numel(data.fluor_profile)>0
            count = count+1;
            fl{count} = data.fluor_profile;
            num(count) = j;
        else
            %fl{j} = [];
        end
    end
    
    %% assemble the kymograph
    if count>5
        maxn = 0;
        for j=1:count
            if numel(fl{j})>maxn
                maxn = numel(fl{j});
            end
        end
        
        clear FL; 
        FL = zeros(count,maxn);
        minfl = 1000000;
        maxfl = 0;
        
        for j=1:count
            nf = numel(fl{j});
            n0 = max(round((maxn-nf)/2),1);
            
            minfl = min(minfl,min(fl{j}));
            maxfl = max(maxfl,max(fl{j}));
            FL(j,n0:n0+nf-1) = fl{j};
        end
        
        imagesc(FL,[minfl maxfl]);
        colormap(hot);
        print('-dpdf',['Pos',pnum,'_cell',int2str(i),'.pdf']);
        pause;
    end
end