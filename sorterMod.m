%%-------------------------------------------------------------------------
function [from,to, orphan]= sorterMod(connections, pixel_search_radius)
% find indices of minimum value in each row
% Get all hits within the search radius

[i,j]  = min(connections,[],2); % j is the row index
orphan=find(i > pixel_search_radius);
ColArray = 1:size(connections,1);
ColArray(orphan) = [];
j(orphan) = [];
from = ColArray';
to = j;
orphan=setdiff(1:size(connections,2),to);