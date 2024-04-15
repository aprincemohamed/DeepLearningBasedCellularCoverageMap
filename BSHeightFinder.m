dirname_DSM = "./Data/DSM/";
dirname_DHM = "./Data/DHM/";

load("./Data/TileAddressBook_DSM.mat");
% load("./Data/TileAddressBook_DSM_ALL.mat");

CellLocTable = [
    [40.4439,-86.9966,139.8] % 1735, North 500 West, Tippecanoe County, 47906 AT&T
    [40.4754, -87.0004, 199.1 ] % ACRE LTE Tmobile
    [40.4684,-87.046,254.9] % Montmorenci AT&T
    [40.4754, -87.0004, 199.1 ] % ACRE 5G Tmobile GoogleFi
    [40.4754, -87.0004, 199.1 ] % ACRE 5G Tmobile GoogleFi
    [40.4754, -87.0004, 199.1 ] % ACRE 5G Tmobile GoogleFi
    [40.4754, -87.0004, 199.1 ] % ACRE LTE Tmobile Lyca GoogleFi
    [40.4754, -87.0004, 199.1 ] % ACRE LTE Tmobile Lyca GoogleFi
    [40.4546, -86.966, 192.9] % Lindberg Village LTE Tmobile Lyca
    [40.429,-86.8754,188] % Happy Hollows 1 AT&T
    [40.429,-86.8754,188] % Happy Hollows 1 AT&T
    [40.4452,-86.8635,178.1] % Happy Hollows 2 AT&T
    [40.4546, -86.966, 192.9]]; % Lindberg Village AT&T


    x =  [500288.334959053
        499966.094080045
        496100.414237690
        499966.094080045
        499966.094080045
        499966.094080045
        499966.094080045
        499966.094080045
        502882.892368975
        510568.962354829
        510568.962354829
        511575.579309773
        502882.892368975];

    y = [ 
        4477027.66331517
        4480524.12826538
        4479748.14909486
        4480524.12826538
        4480524.12826538
        4480524.12826538
        4480524.12826538
        4480524.12826538
        4478215.90057877
        4475381.23108036
        4475381.23108036
        4477180.90117615
        4478215.90057877];
    CellLocTable = [CellLocTable,x,y];
    CellLocTable(:,3) = 0.3048*CellLocTable(:,3);

LatLim = [min(CellLocTable(:,1)),max(CellLocTable(:,1))];
LongLim = [min(CellLocTable(:,2)),max(CellLocTable(:,2))];


LatLimMat = zeros(length(listing),2);
LongLimMat = zeros(length(listing),2);
for n = 1:length(listing)
    LatLimMat(n,:) = listing(n).LatLim;
    LongLimMat(n,:) = listing(n).LongLim;
end

index1 = LatLimMat(:,1) <= LatLim(2) & LatLimMat(:,1) >= LatLim(1);
index2 = (LatLimMat(:,2) <= LatLim(2) & LatLimMat(:,2) >= LatLim(1));
index3 = (LongLimMat(:,1) <= LongLim(2) & LongLimMat(:,1) >= LongLim(1));
index4 = (LongLimMat(:,2) <= LongLim(2) & LongLimMat(:,2) >= LongLim(1));

TileIndex = (index1 | index2) & (index3 | index4);
% TileList = listing(TileIndex).name;

DSMAddressBook = listing(TileIndex);



% Search for DHM Tiles

load("./Data/TileAddressBook_DHM.mat");


LatLimMat = zeros(length(listing),2);
LongLimMat = zeros(length(listing),2);
for n = 1:length(listing)
    LatLimMat(n,:) = listing(n).LatLim;
    LongLimMat(n,:) = listing(n).LongLim;
end


index1 = LatLimMat(:,1) <= LatLim(2) & LatLimMat(:,1) >= LatLim(1);
index2 = (LatLimMat(:,2) <= LatLim(2) & LatLimMat(:,2) >= LatLim(1));
index3 = (LongLimMat(:,1) <= LongLim(2) & LongLimMat(:,1) >= LongLim(1));
index4 = (LongLimMat(:,2) <= LongLim(2) & LongLimMat(:,2) >= LongLim(1));

TileIndex = (index1 | index2) & (index3 | index4);
% TileList = listing(TileIndex).name;

DHMAddressBook = listing(TileIndex);


    
    




for n = 1:length(CellLocTable(:,1))

    RxPoint_Lat = CellLocTable(n,1);
    RxPoint_Lon = CellLocTable(n,2);

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
    RepMatXY = repmat([CellLocTable(n,4),CellLocTable(n,5)],length(AoIMatrix(:,1)),1);
    DistVec = sqrt(mean((AoIMatrix - RepMatXY).^2,2));
    [~,NearestPointInd] = min(DistVec);

    
    disp(strcat("Dist: ",num2str(min(DistVec)),"Object Height",num2str(DHMMatPerRxPoint.lidarZs(NearestPointInd(1)))));

    BSHeights(n) = DSMMatPerRxPoint.lidarZs(NearestPointInd(1)) - DHMMatPerRxPoint.lidarZs(NearestPointInd(1)) + CellLocTable(n,3);
    % BSLocations(n,3) = DSMMatPerRxPoint.lidarZs(NearestPointInd(1)) - DHMMatPerRxPoint.lidarZs(NearestPointInd(1)) + BSLocations(n,3);
    
end