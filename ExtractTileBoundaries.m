clear all

% dirname = "E:\CellCoverageMapper\Lidar_2019\IN\DSM\QL2_3DEP_LiDAR_IN_2017_2019_l2\"; % Lidar File Directory
% dirname = "./Data/DHM/"; % Lidar File Directory
dirname = "./Data/DSM/"; % Lidar File Directory
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

    listing(n).LatLim = [min(LidarTiles.lidarLats),max(LidarTiles.lidarLats)];
    listing(n).LongLim = [min(LidarTiles.lidarLons),max(LidarTiles.lidarLons)];

end


listing(1:2) = [];
clearvars -except listing
save('./Data/TileAddressBook_DSM.mat')

