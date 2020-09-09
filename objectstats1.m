% 6/3/2013 anushree, iiser pune
% To find velocity(dx/dy), displacement(dx) and
% tortuosity(displacement/distance)
% from particle trajectories generated
% by DICOT
% Input: matrix of trajectories.txt
% Output: StatsPerTrack.txt; InstStats.txt

function [allpertrack,allinst]=objectstats1(outfolder, objnum,scal_fact, distUnit, timeUnit,outmatt,unn)
%% reading in coords of centroids of tracked objects
% outmatt= list of tracks
% (1: obj no, 2:frame, 3:x, 4:y, 5:Time)
if isempty(outmatt)
    errordlg('No tracks detected!', 'Error')
end

%% Number of tracks
pertrack=cell(1, objnum);
instant = pertrack;
arr=pertrack;
%% arranging all objects in separate cells
for i=1:objnum % each object
    arr{i}= outmatt((outmatt(:,1)== unn(i)),2:5);
    % frame number, x coord, y coord, time
    dist=euclDist([arr{i}(1,2:3);arr{i}(end,2:3)])*scal_fact;% start to end
    waqt=arr{i}(end,4)-arr{i}(1,4); % start to end
    netvel=dist/waqt;
    sarr=size(arr{i},1)-1;
    disp=zeros(sarr, 2);
    for j=1:sarr
        disp(j,:)=[i, scal_fact*euclDist([arr{i}(j,2:3);arr{i}(j+1,2:3)])];
    end
    pathlength=sum(disp(:,2));
    timestep=arr{i}(2:end, 4)-arr{i}(1:end-1, 4);
    speed=pathlength/waqt;
    invel=disp(:,2)./timestep;
    tortu= dist/pathlength; % start-to-end/pathlength
    switch pathlength
        case 0
            tortu=0;
    end
    
    
    pertrack{i}=[i, waqt,pathlength,dist, speed,netvel, tortu];
    % obj no., total time, pathlength,start-to-end dist, speed,net-vel, tortuosity
    instant{i}=[disp(:,1),timestep,disp(:,2),invel];
    % obj no., time, displacement, velocity
    
end
allpertrack=cat(1, pertrack{:});
allinst=cat(1, instant{:});
fid =fopen([outfolder, '/StatsPerTrack.txt'], 'w');
fprintf(fid, ['ObjectID    Time (', timeUnit, ')    Pathlength    NetDist    Speed    NetVel    Tortuosity   \r\n']);
fclose(fid);
dlmwrite([outfolder, '/StatsPerTrack.txt'],...
    allpertrack,'-append',...
    'delimiter', '\t','newline', 'pc',...
    'precision', '%.3f');


fid =fopen([outfolder, '/InstStats.txt'], 'w');
fprintf(fid, ['ObjectID    Time (', timeUnit, ')    Displacement (',distUnit,')    Velocity\r\n']);
fclose(fid);
dlmwrite([outfolder, '/InstStats.txt'], allinst,...
    '-append', 'delimiter', '\t','newline', 'pc',...
    'precision', '%.3f');


