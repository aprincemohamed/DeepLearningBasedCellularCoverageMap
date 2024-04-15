%%%%% This code generates bounding boxes for each tile %%%%%

clear all

dirname = "./Data/DHM/"; % Lidar File Directory
% dirname = "./Data/DSM/"; % Lidar File Directory
dir
dir dirname
listing = dir(dirname);

mPerFoot = unitsratio("meter","feet");

for n = 3:length(listing)

    filename = listing(n).name;
    filename = strcat(dirname,filename);

    maxAllowedAbsLidarZ = 10^38;
    flagGenFigsQuietly = true;
   
    % Load the repaired tile.
    [lidarDataImg, spatialRef] ...
        = readgeoraster(filename);
    lidarDataImg(abs( ...
        lidarDataImg(:))>maxAllowedAbsLidarZ) = nan;

    % Essentailly meshgrid matrices.
    [lidarRasterXs, lidarRasterYs] = worldGrid(spatialRef);

    % Column vectors.
    [LidarTiles.lidarLats, LidarTiles.lidarLons] = projinv( ...
        spatialRef.ProjectedCRS, ...
        lidarRasterXs(:), lidarRasterYs(:));

    % min and max lat values
    listing(n).LatLim = [min(LidarTiles.lidarLats),max(LidarTiles.lidarLats)];
    % min and max long values
    listing(n).LongLim = [min(LidarTiles.lidarLons),max(LidarTiles.lidarLons)];

end


listing(1:2) = [];
clearvars -except listing


% The following contains the bounding box of DHM files in ./Data/DHM
save('./Data/TileAddressBook_DHM.mat')

% The following contains the bounding box of DHM files in ./Data/DSM
% save('./Data/TileAddressBook_DSM.mat')



