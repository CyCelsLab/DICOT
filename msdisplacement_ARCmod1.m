% Anushree 24/2/2018
% Neha Khetan 2015
function [dt,rr]=msdisplacement_ARCmod1( t , xx , yy)

u=1:1:round(3*length(t)/4); %ARC
sqD1=cell(1,numel(u)); %ARC preallocating
msqD1= sqD1; %ARC preallocating
for dT = round(u)
    
    sqD1{dT}=zeros(numel(1:1:length(t)-dT),1); %ARC altered
    for n=1:1:length(t)-dT
        sqD1{dT}(n,:)=((xx(n)-xx(n+dT)).^2)+((yy(n)-yy(n+dT)).^2); %ARC  altered
    end
    
    % For a given dT, from multiple sqD1 values, finding the mean of it
    if size(t,1)>dT % condition added 29/6/2018 ARC
        msqD1{dT} = [ t(dT+1), mean( sqD1{dT}(:) ) ];
    else
        continue
    end
end

catmsqD1=cat(1,msqD1{:}); %ARC
% For each dt, return the rr
dt    = [0;catmsqD1(:,1)]; %ARC
rr    = [0;catmsqD1(:,2)]; %ARC


end
