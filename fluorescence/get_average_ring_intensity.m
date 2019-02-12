function [ringfluorconc,ringwidth,ringfluorint,totfluor,NumRings] = get_average_ring_intensity(ob,blank,pixel,varargin)
 
 debugmode = 0;
 totfluor = [];
 ringfluorconc = [];
 ringfluorint = [];
 ringfluor = [];
 Rwidth = [];
 ringwidth = []; 
 minpeakprom = 10000;
 NumRings = NaN;
% choose between fluor_interior or fluor_profile
 %cell_fluor = ob.fluor_interior;
 cell_fluor = convert_profile(ob,blank);
  if isempty(cell_fluor)
     return
 end
 
 % filter only cells with one ring
 if numel(varargin)>=1
     one_ring_only = varargin{1};
 else
     one_ring_only = 1;
 end
 
 if numel(varargin)>=2
     minpeakprom = varargin{2};
 end
 
 if numel(varargin)>=3
     debugmode = varargin{2};
 end
 
 fprintf('Using %d for minpeakprominence parameter in findpeaks...',minpeakprom)
 
 [peaksplitlocs,NumRings] = split_ringpeaks(cell_fluor,minpeakprom,debugmode);
  
 if NumRings == 0
     return
 end

 if one_ring_only
     if NumRings ~= 1
         fprintf('skip...\n')
         return
     end
 end
 
 fprintf('%d peaks...\n',NumRings)
 for i = 1:numel(peaksplitlocs)-1
    [rF,rW] = get_peak_intensity(cell_fluor(peaksplitlocs(i):peaksplitlocs(i+1)));
     ringfluor = [ringfluor rF];
     Rwidth = [Rwidth rW*pixel];
 end
    Rwidth = Rwidth(Rwidth~=0);
    ringfluor = ringfluor(Rwidth~=0);
    ringfluorint = sum(ringfluor./Rwidth); 
    ringfluorconc = sum(ringfluor./Rwidth)/sum(cell_fluor); % sum of ring fluorescence divided by the width dividend by total fluorescence
    ringwidth = mean(Rwidth);
    totfluor = sum(cell_fluor);
end

function [peaksplitlocs,numpks] = split_ringpeaks(fluorint,minpeakprom,debugmode)
    peaksplitlocs = [];
    if debugmode
        findpeaks(fluorint,'MinPeakProminence',minpeakprom);
        pause
    end
    [pks,locs] = findpeaks(fluorint,'MinPeakProminence',minpeakprom);
    numpks = numel(pks);
    if numel(pks) == 1
        peaksplitlocs = [1 locs numel(fluorint)];
    else
        for i = 1:numel(pks)-1
            peaksplitlocs = [ peaksplitlocs locs(i) + (locs(i+1) - locs(i))/2];
        end
        
        peaksplitlocs = [1 peaksplitlocs];
        peaksplitlocs = [peaksplitlocs numel(fluorint)];
    end
end

function int = convert_profile(ob,blank)
profile = ob.fluor_profile - double(blank);
% number of points along contour (fluorescence profile)
N = numel(profile);
% add the two halfs of the contours together 
if mod(N,2) == 1                            % Modified 2018-10-30 AVM adding handling of odd arrays
    N = N - 1;
    int = profile(1:N/2)+fliplr(profile(N/2+1:end-1)); % 
else                                         % 
int = profile(1:N/2)+fliplr(profile(N/2+1:end)); 
end
end

function [totfluor,ringwidth] = get_peak_intensity(int)
inthalf = (max(int)-min(int))/2;
idx1 = find(int > inthalf+min(int),1); %find the location on the left of the curve at the half point.
idx2 = find(int > inthalf+min(int),1,'last'); %find the location on the right of the curve at the half point.
totfluor = sum(int(idx1:idx2));
ringwidth = (idx2-idx1);
%ringfluorint = totfluor/ringwidth/sum(ob.fluor_internal_profile); % sum of fluorescence divided by the width (in microns)
end