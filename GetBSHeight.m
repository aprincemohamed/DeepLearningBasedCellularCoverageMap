
RxPoint_Lat = BSLocation_LatLon(1);
RxPoint_Lon = BSLocation_LatLon(2);

load("./Data/TileAddressBook_DHM.mat");

DHMAddressBook = listing;


LatLimMat = zeros(length(DHMAddressBook),2);
LongLimMat = zeros(length(DHMAddressBook),2);

for l = 1:length(DHMAddressBook)
    LatLimMat(l,:) = DHMAddressBook(l).LatLim;
    LongLimMat(l,:) = DHMAddressBook(l).LongLim;
end    

index1 = LatLimMat(:,1) <= RxPoint_Lat & LatLimMat(:,2) >= RxPoint_Lat;
index2 = LongLimMat(:,1) <= RxPoint_Lon & LongLimMat(:,2) >= RxPoint_Lon;

TileIndex = index1 & index2;
if sum(TileIndex) == 0
    "Error: there is no tile for this point"
end

TileList_DHM = DHMAddressBook(TileIndex);
NumTiles_DHM = sum(TileIndex);

% DHMMatPerRxPoint = zeros(NumTiles_DHM,3);

for k = 1:NumTiles_DHM

    filename = strcat(dirname_DHM,TileList_DHM(k).name);

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
    [DHMMatPerRxPoint.lidarLats, DHMMatPerRxPoint.lidarLons] = projinv( ...
        spatialRef.ProjectedCRS, ...
        lidarRasterXs(:), lidarRasterYs(:));

    % Convert survery feet to meter.
    LidarZs_Tmp = double(squeeze(distdim(lidarDataImg(:), 'ft', 'm')));
    DHMMatPerRxPoint.lidarZs = LidarZs_Tmp;

    % Convert LatLong to UTM
    [x_tmp,y_tmp,DHMMatPerRxPoint.UtmZone] = deg2utm(DHMMatPerRxPoint.lidarLats,DHMMatPerRxPoint.lidarLons);
    DHMMatPerRxPoint.x = x_tmp;
    DHMMatPerRxPoint.y = y_tmp;

    % DHMMatPerRxPoint.LidarZs = [DHMMatPerRxPoint.LidarZs,double(LidarZs_Tmp)];
    % DHMMatPerRxPoint.x = [DHMMatPerRxPoint.x,x_tmp];
    % DHMMatPerRxPoint.y = [DHMMatPerRxPoint.y,y_tmp];

end
% end

% Import DSM Tiles

% Search for DSM Tiles
    
load("./Data/TileAddressBook_DSM.mat");

DSMAddressBook = listing;

% TileIndex = index1 & index2;
TileList_DSM = DSMAddressBook(TileIndex);
NumTiles_DSM = sum(TileIndex);

% DSMMatPerRxPoint = zeros(NumTiles_DSM,3);

for k = 1:NumTiles_DSM

    filename = strcat(dirname_DSM,TileList_DSM(k).name);

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
    [DSMMatPerRxPoint.lidarLats, DSMMatPerRxPoint.lidarLons] = projinv( ...
        spatialRef.ProjectedCRS, ...
        lidarRasterXs(:), lidarRasterYs(:));

    % Convert survery feet to meter.
    LidarZs_Tmp = double(squeeze(distdim(lidarDataImg(:), 'ft', 'm')));
    LidarZs_Tmp(LidarZs_Tmp==0) = min(LidarZs_Tmp(LidarZs_Tmp>0)); % Filter out zeros
    DSMMatPerRxPoint.lidarZs = LidarZs_Tmp;

    % % Convert LatLong to UTM
    [x_tmp,y_tmp,DSMMatPerRxPoint.UtmZone] = deg2utm(DSMMatPerRxPoint.lidarLats,DSMMatPerRxPoint.lidarLons);   
    DSMMatPerRxPoint.x = x_tmp;
    DSMMatPerRxPoint.y = y_tmp;

end

% Get BS Height
AoIMatrix = [DSMMatPerRxPoint.x,DSMMatPerRxPoint.y]; 
RepMatXY = repmat([BSLocation(1),BSLocation(2)],length(AoIMatrix(:,1)),1);
DistVec = sqrt(mean((AoIMatrix - RepMatXY).^2,2));
[~,NearestPointInd] = min(DistVec);


disp(strcat("Dist: ",num2str(min(DistVec))," Object Height:",num2str(DHMMatPerRxPoint.lidarZs(NearestPointInd(1)))));

% BSHeights(n) = DSMMatPerRxPoint.lidarZs(NearestPointInd(1)) - DHMMatPerRxPoint.lidarZs(NearestPointInd(1)) + CellLocTable(n,3);
BSLocation(3) = DSMMatPerRxPoint.lidarZs(NearestPointInd(1)) - DHMMatPerRxPoint.lidarZs(NearestPointInd(1)) + BSLocation(3);
    