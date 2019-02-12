function convert_ome_to_stack_modified(varargin)
% converts a multichannel .ome. stack and if split into multiple tiffs,
% concats stacks with the same position name

% Example
% convert_ome_to_stack('prefix','*_4-Pos_','make_one_stack',1,'phasestackname','4-Pos_Phase.tif',
... 'gfpstackname','4-Pos_ETGFP.tif','o_folder',o_folder)


folder = [ pwd '/'];
% o_folder = folder;
o_folder = '/Volumes/home/Image_archive/AM_IM200_2018-06-06 A22quant/analysis/';
make_one_stack = 1;
prefix = '*_4-Pos';
phasestackname = 'phase.tif';
gfpstackname = 'gfp.tif';

if ~isempty(varargin)
    % print default variable information
    if strcmp(varargin{1},'-h')
        fprintf('To change variables, use: %s(''variablename'',variablevalue,...)\n',mfilename)
        fprintf('Default variables for %s:\n',mfilename)
        myvals = who;
        for n = 1:length(myvals)
            if ~strcmp(myvals{n},'varargin')
                if isstring(eval(myvals{n})) || ischar(eval(myvals{n}))
                    fprintf('%s = ''%s''\n',myvals{n},eval(myvals{n}))
                elseif isinteger(eval(myvals{n})) || isfloat(eval(myvals{n}))
                    fprintf('%s = %s\n',myvals{n},num2str(eval(myvals{n})))
                else
                    fprintf('%s = ''''\n',myvals{n})
                end
            end
        end
       return
    end
    
    % check if even numbered variables
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Improper arguments. Use ''-h'' flag to see options')
        return
    end
    
    % change variables
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

if ~strcmp(o_folder(end),'/')
    o_folder = [o_folder '/'];
end

if make_one_stack == 1
    split_tiffstack('folder',folder,'prefix',prefix,'p_out',[o_folder strrep(strrep(prefix,'_',''),'*','') '_' phasestackname],'g_out',[o_folder strrep(strrep(prefix,'_',''),'*','') '_' gfpstackname],'make_one_stack',make_one_stack)
else
    split_tiffstack('folder',folder,'prefix',prefix)
end
% filelist1 = dir([folder,prefix,'*phase.tif']);
% filelist2 = dir([folder,prefix,'*GFP.tif']);
% 
% pos = cellfun(@(x) x{end},cellfun(@(x) strsplit(x,'MMStack_'),{filelist1.name},'UniformOutput',false),'UniformOutput',false);
% unipos = unique(pos);
% for i = 1:numel(unipos)
%     rf = repeatfiles(filelist1,unipos{i});
%     if (sum(rf) > 1)
%         concat_tiffs(filelist1(rf),unipos{i})
%     end
% end
% 
% pos = cellfun(@(x) x{end},cellfun(@(x) strsplit(x,'MMStack_'),{filelist2.name},'UniformOutput',false),'UniformOutput',false);
% unipos = unique(pos);
% for i = 1:numel(unipos)
%     rf = repeatfiles(filelist2,unipos{i});
%     if (sum(rf) > 1)
%         concat_tiffs(filelist2(rf),unipos{i})
%     end
% end
% 
% if make_one_stack == 1
%     fprintf('Concating into one phase.tif and gfp.tif\n')
%     concat_tiffs(filelist1,[o_folder phasestackname])
%     concat_tiffs(filelist2,[o_folder gfpstackname])
% end

end

function repeats = repeatfiles(filelist,split)
repeats = cellfun(@(x) findstr(split,x),{filelist.name},'UniformOutput',false);
repeats = ~cellfun(@isempty,repeats);
end

function b = check_repeats(filelist)
b = false;
for j = 1:numel(filelist)
    repeats = repeatfiles(filelist(j).name,filelist);
    if numel([repeats{:}]) > 1
        b = true;
        return;
    end
end
end

function split_tiffstack(varargin)
prefix = '';
folder = '';
o_folder = folder;
rewrite = 0;
make_one_stack = 0;
if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: split_tiffstack(''prefix'',prefixvar,''folder'',foldervar) [all inputs optional]\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end
% load each of the files starting with prefix
filelist = dir([folder,prefix,'*.ome.tif']);
filelist = filelist(~cellfun(@(x) strcmp(x(1),'.'),{filelist.name})); % remove hidden files
fprintf('Processing %d files with motif *%s*.ome.tif...\n',numel(filelist),prefix);
for j=1:numel(filelist)
    % read in image
    fname = filelist(j).name;
    n = imfinfo(fname);
    out = strsplit(fname,'.ome.tif');
    if ~make_one_stack
        p_out = [o_folder out{1},'_phase.tif'];
        g_out = [o_folder out{1},'_GFP.tif'];
    end
    
    for i = 1:2:numel(n)
        Phase = imread(fname, i);
        if ~exist(p_out,'file') || rewrite || make_one_stack
            imwrite(Phase,p_out,'WriteMode','append');
        else
            fprintf('Skipped %s\n',p_out)
        end
        try
            GFP = imread(fname,i+1);
            if  ~exist(g_out,'file') || rewrite || make_one_stack
                imwrite(GFP,g_out,'WriteMode','append');
            else
                fprintf('Skipped %s\n',g_out)
            end
        catch
        end
    end
    
end
end

function concat_tiffs(filelist,outputname)
fprintf('Processing %d files to %s...\n',numel(filelist),outputname);
for j=1:numel(filelist)
    fname = filelist(j).name;
    % read in image
    n = imfinfo(fname);
    for i = 1:numel(n)
        img = imread(fname, i);
        imwrite(img,outputname,'WriteMode','append');
    end
end
end

