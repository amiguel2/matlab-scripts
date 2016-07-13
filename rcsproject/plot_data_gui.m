function checked = plot_data_gui

checked = [];

% Create figure
h.f = figure('units','pixels','position',[200,200,190,150],...
             'toolbar','none','menu','none');

 % create panels
uipanel('Title','Plots','Position',[.025 .5 .9 .45]);        
uipanel('Title','Options','Position',[.025 .2 .9 .25]);        
          
         
% Create lineage/save checkboxes
h.c(1) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.05,0.25,0.5,0.1],'string','Lineage?');
h.c(2) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.5,0.25,0.4,0.1],'string','Save Plot?'); 

% create plot boxes
h.c(3) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.05,0.75,0.3,0.1],'string','Length');
h.c(4) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.55,0.75,0.35,0.1],'string','Width'); 
h.c(5) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.05,0.65,0.4,0.1],'string','Growthrate');
h.c(6) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.55,0.65,0.35,0.1],'string','Div Time');
h.c(7) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.05,0.55,0.5,0.1],'string','Delta Length');
h.c(8) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.55,0.55,0.35,0.1],'string','Hist GrR');   
            
% Create OK pushbutton   
h.p = uicontrol('style','pushbutton','units','pixels',...
                'position',[50,5,70,20],'string','OK',...
                'callback',@p_call);
end
            % Pushbutton callback
    function checked = p_call(varargin)
        vals = get(h.c,'Value');
        checked = find([vals{:}]);
        if isempty(checked)
            checked = 'none';
        end
        disp(checked)
        close;
    end