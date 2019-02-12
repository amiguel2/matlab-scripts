function plotpositions(searchstr,c)

%% Plots the positions of the frames using the metadata files (and flips x/y axis so it looks the way it was spotted on the agarose pad (not the orientation of reverse objective)
%for seperate image files
% files = rdir('*5-Pos*/metadata.txt');
% for ome stacks
%files = rdir('*5-Pos*metadata.txt');

% Defaults
if ~exist('c','var')
    c = [1 0 0];
end
if ~exist('searchstr','var')
    searchstr = '*metadata.txt';
end


files = rdir(searchstr);
fprintf('Plotting %d files\n',numel(files))
for i = 1:numel(files)
   tmp = strsplit(files(i).name,'/');
   pos = tmp{1};
   ftext =  fileread(files(i).name);
   if contains(files(i).name,'MMStack_')
      temp1 = strsplit(files(i).name,'MMStack_');
      temp2 = strsplit(temp1{end},'_metadata');
      expr1 = '"XYStage": [\n.+?"GridRowIndex"';
      Xmatches = regexp(ftext,expr1,'match');
      if isempty(Xmatches)
          continue
      else
      idx = find(contains(Xmatches,temp2{1}));
      strstart = strfind(Xmatches{idx},'[');
      strend = strfind(Xmatches{idx},']},');
      coord = cellfun(@str2double,strsplit(Xmatches{idx}(strstart+1:strend-1),','));
      X = coord(1)*-1;
      Y = coord(2)*-1;
      end
   else
   expr1 = '[^\n]*XPosition[^\n]*';
   expr2 = '[^\n]*YPosition[^\n]*';
   Xmatches = regexp(ftext,expr1,'match');
   Ymatches = regexp(ftext,expr2,'match');
   tmp1 = strsplit(Xmatches{1},'"XPositionUm":');
   X = str2num(tmp1{2}(1:end-1));
   tmp2 = strsplit(Ymatches{1},'"YPositionUm":');
   Y = str2num(tmp2{2}(1:end-1));
   
   end
   if i == 1
   scatter(X,-1*Y, 50, c); hold on;
   else
       h = scatter(X,-1*Y, 50, c);
       set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
   end
%    text(X,Y,pos)
end
end