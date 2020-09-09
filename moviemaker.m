% Anushree, 2019
% Makes a tracking movie and saves it as a .tif file in the DICOT folder
% Input: outmat:  obj no, frame, x, y, length, time
% Output: trackingmovie.tif
function oo=moviemaker(folder,outmat,framestart,frameend,objno,img)

outfile1=[folder, '/trackingmovie.tif'];

if exist(outfile1, 'file')
    delete(outfile1);
end

%%
objwise=cell(1,objno);
frmwise=cell(1,(frameend-framestart+1));
p=0;
w =waitbar(0,'Saving movie..',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

setappdata(w,'canceling',0);
oo=1;

for j=framestart:frameend
    p=p+1;
    waitbar(p/(frameend-framestart+1));
    % Check for clicked Cancel button
    if getappdata(w,'canceling')
        delete(w);
        oo=0;
        
        return
    end
    frmwise{p}=outmat((outmat(:,2)==j),1:4); %obj no, frame, x, y
    fj= figure(j);
    set(fj,'visible', 'off'), imshow(imadjust(img{j}), 'Border', 'tight')%, 'InitialMagnification', 'fit')
    
    for i=1:objno
        objwise{i}=[objwise{i}; frmwise{p}(frmwise{p}(:,1)==i,3:4)];% x,y
        switch j
            case frmwise{p}(frmwise{p}(:,1)==i,2)
                set(gca, 'visible', 'off')
                hold on,plot(objwise{i}(1:end,1),objwise{i}(1:end,2),...
                    '-r', 'Linewidth', 0.5)
                hold on, plot(objwise{i}(end,1),objwise{i}(end,2),'.b','MarkerSize', 4)
                hold on, text(objwise{i}(end,1),objwise{i}(end,2),sprintf('%i', i),...
                    'Color', 'y','FontSize', 6)
            otherwise
                continue
        end
    end
    f=getframe(fj);
    imwrite(f.cdata, outfile1, 'tif', 'Compression', 'none', 'WriteMode', 'append');
    delete(fj);
end
delete(w)

end

