function [GFS_coords, subsGFS, AM3_coords, subsAM3] = ...
    discretizeToModelGrids(lats, lons)

% fill in GFS and AM3 if necessary:
latEdgesAM3 = -90:2.5:90;
lonEdgesAM3 = 0:2.5:360;

latEdgesGFS = [latEdgesAM3 - 1.25, 91.25];
lonEdgesGFS = [lonEdgesAM3 - 1.25, 361.25];

doWrapLons = true;
[latCentersGFS, lonCentersGFS, ilatGFS, ilonGFS] = coarsenGrid(lats, ...
    lons, latEdgesGFS, lonEdgesGFS, doWrapLons);

doWrapLons = false;
[latCentersAM3, lonCentersAM3, ilatAM3, ilonAM3] = coarsenGrid(lats, ...
    lons, latEdgesAM3, lonEdgesAM3, doWrapLons);

subsGFS = [ilonGFS, ilatGFS];
subsAM3 = [ilonAM3, ilatAM3];

GFS_coords = struct('lat',latCentersGFS,'lon',lonCentersGFS);
AM3_coords = struct('lat',latCentersAM3,'lon',lonCentersAM3);

end


function [latCenters, lonCenters, ilat, ilon, varargout] = coarsenGrid(lats, lons, ...
    coarseLatEdges, coarseLonEdges, doWrapLons, varargin)
% regrid from fine grid to coarser grid, using nanmean to accumulate values

if ~isvector(lats)
    lats = lats(:);
end

if ~isvector(lons)
    lons = lons(:);
end

latCenters = 0.5*(coarseLatEdges(1:end-1) + coarseLatEdges(2:end));

if ~exist('doWrapLons','var')
    doWrapLons = false;
end

if doWrapLons
    wrapLons = [1:(length(coarseLonEdges)-2), 1];
    lonCenters = 0.5*(coarseLonEdges(1:end-2) + coarseLonEdges(2:end-1));
else
    lonCenters = 0.5*(coarseLonEdges(1:end-1) + coarseLonEdges(2:end));
    wrapLons = 1:length(lonCenters);
end

ilat = discretize(lats, coarseLatEdges);
ilon = discretize(lons, coarseLonEdges, wrapLons);

nv = numel(varargin);
sizeOut = [length(lonCenters), length(latCenters)]; 

for ivar = nv:-1:1
    dat = varargin{ivar};
    if ~isvector(dat) && ismatrix(dat)
        dat = dat(:);
    end
    varargout{ivar} = accumarray([ilon, ilat], dat, ...
        sizeOut, @nanmean);
end

end