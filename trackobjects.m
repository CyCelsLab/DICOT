%% Modified ARC 20/03/2020
% Tracks objects whose coordinates are saved in 'segmented.txt'.
% Dependency: sorterMod.m
% Input: matrix of segmented.txt
% Output: trajectories.txt
function [ALLtracks,objno,outmat,un,o]= trackobjects(outfolder, savestats, micron_search_radius, scal_fact, interval, timeUnit,perstim)
pixel_search_radius=micron_search_radius/scal_fact;


x = savestats(:,2)';
y = savestats(:,3)';
frame = savestats(:,1)';

beadlabel=zeros(size(x)); % vector of bead labels.
i=min(frame); spanA=find(frame==i); % initialize
beadlabel(1:length(spanA))=1:length(spanA); % refers to absolute indexing of x,y,frame,etc.
lastlabel=length(spanA); % start off with unique bead labels for all the beads in the first frame

w =waitbar(0,'Tracking objects..',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

setappdata(w,'canceling',0);
p=0;
fidx= min(frame):max(frame)-1;
o=1;
for i= fidx % loop over all frame(i),frame(i+1) pairs.
    p=p+1;
    waitbar(p/numel(fidx));
    % Check for clicked Cancel button
if getappdata(w,'canceling')
    o=0;
    objno=0;
    ALLtracks=[];
    outmat=[];
    un=0;
    delete(w);
    return
end
    spanA= find(frame==i); % ARC 'find'-here, gives positions
    spanB= find(frame==i+1);
    %if isempty(spanA)==0 & isempty(spanB)==0
    dx = ones(length(spanA),1)*x(spanB) - x(spanA)'*ones(1,length(spanB));
    dy = ones(length(spanA),1)*y(spanB) - y(spanA)'*ones(1,length(spanB));
    
    dr2 = sqrt(dx.^2 + dy.^2); % dr2(m,n) = distance^2 between r_A(m) (in frame i) and r_B(n) (in frame i+1)
    %     % RELATIVE  indices of connected and unconnected beads
    [from, to, orphan] = sorterMod(dr2, pixel_search_radius);
    
    %%%%%%%
    from=spanA(from);
    to=spanB(to);
    orphan=spanB(orphan); % translate to ABSOLUTE indices
    beadlabel(to)= beadlabel(from); % propagate labels of connected beads
    % modified ARC 28/5/2016
    if ~isempty(orphan) % there is at least one new (or ambiguous) bead
        beadlabel(orphan)=lastlabel+(1:length(orphan)); % assign new labels for new beads.
        lastlabel=lastlabel+length(orphan); % keep track of running total number of beads
    end
end


% Initialize for purposes of speed and memory management.
ALLtracks=cell(lastlabel,1); % modified ARC 28/5/2016
re=0;

for i=1:lastlabel
    
    beadi=find(beadlabel==i);
    if  numel(x(beadi))>=floor((perstim+interval)/interval) % ARC minimum no. of data points in a trajectory
        re=re+1;%ARC renumbering
        tracks(re).x=x(beadi);
        tracks(re).y=y(beadi);
        tracks(re).frame=frame(beadi);
        % modified ARC 28/5/2016
        ALLtracks{re}= [(re*ones(size(tracks(re).x)))',(tracks(re).frame)', (tracks(re).x)', (tracks(re).y)', ((tracks(re).frame)')*interval];
        ALLtracks{re}(:,5)=ALLtracks{re}(:,5)-ALLtracks{re}(1,5);
        % object number, frame number, centroid(x,y), time
    else
        continue
    end
end
%ARC 25/2/2018:
outmat=cat(1,ALLtracks{:});
un=unique(outmat(:,1));
objno=numel(un);
if exist(outfolder, 'dir')==0
    mkdir(outfolder)
end

if exist([outfolder, '/trajectories.txt'], 'file')
    delete([outfolder,'/trajectories.txt']);
end

fid =fopen([outfolder,'/trajectories.txt'], 'w');
fprintf(fid, ['ObjID	Frame	X	Y	Time (', timeUnit, ')\r\n']);
dlmwrite([outfolder, '/trajectories.txt'], outmat,'-append',...
    'delimiter', '\t','newline', 'pc', 'precision', '%.2f');
fclose(fid);

delete(w);
