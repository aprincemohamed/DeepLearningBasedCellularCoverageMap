% dataname = ["ACRE_S21","ACRE_Lyca","ACRE_GoogleFi"];
% filename = ["./Data/ACRE/S21.csv","./Data/ACRE/lyca.csv","./Data/ACRE/google_fi.csv"];

% dataname = ["Lindberg_S8","Lindberg_S20"];
% filename = ["./Data/Lindberg Village/lindberg_s8.csv","./Data/Lindberg Village/lindberg_s20.csv"];

% dataname = ["HappyHollows_S8","HappyHollows_S20","HappyHollows_S21"];
% filename = ["./Data/Happy Hollows/happy_hallow_s8.csv","./Data/Happy Hollows/happy_hallow_s20.csv","./Data/Happy Hollows/happy_hallow_s21.csv"];


for p = 1:length(dataname)

    dirname_DSM = "./Data/DSM/";
    dirname_DHM = "./Data/DHM/";

    % Import Measurement Data
    
    % DataPerOperator = readtable(filename(p));    
    DataPerOperator = readtable(strcat(RawDirname,dataname(p).name));
    DataPerOperator(DataPerOperator.cell_name == 0,:) = [];
    RxPoints = [DataPerOperator.latitude,DataPerOperator.longitude];
    [x_tmp,y_tmp,~] = deg2utm(RxPoints(:,1),RxPoints(:,2));
    RxPoints_XY = [x_tmp,y_tmp];

    NumRxPoints = length(RxPoints);
    BSLocations = CellLocFinder(DataPerOperator.cell_name);
    BSLocations_LatLon = BSLocations(:,1:2);
    BSLocations = BSLocations(:,3:5);

    % Save Lat/Long Values in the Measurement Datasets

    LatLim = [min(min(BSLocations_LatLon(:,1)),min(RxPoints(:,1))),max(max(BSLocations_LatLon(:,1)),max(RxPoints(:,1)))];
    LongLim = [min(min(BSLocations_LatLon(:,2)),min(RxPoints(:,2))),max(max(BSLocations_LatLon(:,2)),max(RxPoints(:,2)))];
    
    % Search for DSM Tiles that contains the Imported Measurement Points 
    % above in Lat/Long 
    
    load("./Data/TileAddressBook_DSM.mat");
    
    LatLimMat = zeros(length(listing),2);
    LongLimMat = zeros(length(listing),2);
    for n = 1:length(listing)
        LatLimMat(n,:) = listing(n).LatLim; % minimum/maximum lat of the nth tile
        LongLimMat(n,:) = listing(n).LongLim; % minimum/maximum long of the nth tile
    end

    
    index1 = LatLimMat(:,1) <= LatLim(2) & LatLimMat(:,1) >= LatLim(1);
    index2 = (LatLimMat(:,2) <= LatLim(2) & LatLimMat(:,2) >= LatLim(1));
    index3 = (LongLimMat(:,1) <= LongLim(2) & LongLimMat(:,1) >= LongLim(1));
    index4 = (LongLimMat(:,2) <= LongLim(2) & LongLimMat(:,2) >= LongLim(1));
    
    TileIndex = (index1 | index2) & (index3 | index4);
    % TileList = listing(TileIndex).name;
    
    DSMAddressBook = listing;    
    
    
    % Search for DHM Tiles that contains the Imported Measurement Points
    % above in Lat/Long
    
    load("./Data/TileAddressBook_DHM.mat");
    
    
    LatLimMat = zeros(length(listing),2);
    LongLimMat = zeros(length(listing),2);
    for n = 1:length(listing)
        LatLimMat(n,:) = listing(n).LatLim; % minimum/maximum lat of the nth tile
        LongLimMat(n,:) = listing(n).LongLim; % minimum/maximum long of the nth tile
    end
    
    
    index1 = LatLimMat(:,1) <= LatLim(2) & LatLimMat(:,1) >= LatLim(1);
    index2 = (LatLimMat(:,2) <= LatLim(2) & LatLimMat(:,2) >= LatLim(1));
    index3 = (LongLimMat(:,1) <= LongLim(2) & LongLimMat(:,1) >= LongLim(1));
    index4 = (LongLimMat(:,2) <= LongLim(2) & LongLimMat(:,2) >= LongLim(1));
    
    TileIndex = (index1 | index2) & (index3 | index4);
    % TileList = listing(TileIndex).name;
    
    DHMAddressBook = listing;


    % Import DHM Tiles

    TileList_DHM = DHMAddressBook(TileIndex);
    NumTiles_DHM = sum(TileIndex);

    DHMMatPerRxPoint.lidarLats = [];
    DHMMatPerRxPoint.lidarLons = [];
    DHMMatPerRxPoint.x = [];
    DHMMatPerRxPoint.y = [];
    DHMMatPerRxPoint.lidarZs = [];
    DSMMatPerRxPoint.lidarLats = [];
    DSMMatPerRxPoint.lidarLons = [];
    DSMMatPerRxPoint.x = [];
    DSMMatPerRxPoint.y = [];
    DSMMatPerRxPoint.lidarZs = [];
    % DHMMatPerRxPoint = zeros(NumTiles_DHM,3);

    for k = 1:NumTiles_DHM
        % structSize = 10^6*NumTiles_DHM;


        DHMfilename = strcat(dirname_DHM,TileList_DHM(k).name);

        maxAllowedAbsLidarZ = 10^38;
        flagGenFigsQuietly = true;

        % Load the repaired tile.
        [lidarDataImg, spatialRef] ...
            = readgeoraster(DHMfilename);
        lidarDataImg(abs( ...
            lidarDataImg(:))>maxAllowedAbsLidarZ) = nan;

        % Essentailly meshgrid matrices.
        [lidarRasterXs, lidarRasterYs] = worldGrid(spatialRef);

        % Column vectors.
        [lidarLats, lidarLons] = projinv( ...
            spatialRef.ProjectedCRS, ...
            lidarRasterXs(:), lidarRasterYs(:));

        DHMMatPerRxPoint.lidarLats = [DHMMatPerRxPoint.lidarLats;lidarLats];
        DHMMatPerRxPoint.lidarLons = [DHMMatPerRxPoint.lidarLons;lidarLons];

        % Convert survery feet to meter.
        LidarZs_Tmp = double(squeeze(distdim(lidarDataImg(:), 'ft', 'm')));
        DHMMatPerRxPoint.lidarZs = [DHMMatPerRxPoint.lidarZs;LidarZs_Tmp];

        % Convert LatLong to UTM
        [x_tmp,y_tmp,DHMMatPerRxPoint.UtmZone] = deg2utm(lidarLats,lidarLons);
        % DHMMatPerRxPoint.x = x_tmp;
        % DHMMatPerRxPoint.y = y_tmp;

        % DHMMatPerRxPoint.LidarZs = [DHMMatPerRxPoint.LidarZs,double(LidarZs_Tmp)];
        DHMMatPerRxPoint.x = [DHMMatPerRxPoint.x;x_tmp];
        DHMMatPerRxPoint.y = [DHMMatPerRxPoint.y;y_tmp];

    end
    % end

    % Import DSM Tiles

    TileList_DSM = DSMAddressBook(TileIndex);
    NumTiles_DSM = sum(TileIndex);

    % DSMMatPerRxPoint = zeros(NumTiles_DSM,3);

    for k = 1:NumTiles_DSM

        DSMfilename = strcat(dirname_DSM,TileList_DSM(k).name);

        maxAllowedAbsLidarZ = 10^38;
        flagGenFigsQuietly = true;

        % Load the repaired tile.
        [lidarDataImg, spatialRef] ...
            = readgeoraster(DSMfilename);
        lidarDataImg(abs( ...
            lidarDataImg(:))>maxAllowedAbsLidarZ) = nan;

        % Essentailly meshgrid matrices.
        [lidarRasterXs, lidarRasterYs] = worldGrid(spatialRef);

        % Column vectors.
        [lidarLats, lidarLons] = projinv( ...
            spatialRef.ProjectedCRS, ...
            lidarRasterXs(:), lidarRasterYs(:));

        DSMMatPerRxPoint.lidarLats = [DSMMatPerRxPoint.lidarLats;lidarLats];
        DSMMatPerRxPoint.lidarLons = [DSMMatPerRxPoint.lidarLons;lidarLons];

        % Convert survery feet to meter.
        LidarZs_Tmp = double(squeeze(distdim(lidarDataImg(:), 'ft', 'm')));
        LidarZs_Tmp(LidarZs_Tmp==0) = min(LidarZs_Tmp(LidarZs_Tmp>0)); % Filter out zeros
        DSMMatPerRxPoint.lidarZs = [DSMMatPerRxPoint.lidarZs;LidarZs_Tmp];

        % % Convert LatLong to UTM
        [x_tmp,y_tmp,DSMMatPerRxPoint.UtmZone] = deg2utm(lidarLats,lidarLons);
        DSMMatPerRxPoint.x = [DSMMatPerRxPoint.x;x_tmp];
        DSMMatPerRxPoint.y = [DSMMatPerRxPoint.y;y_tmp];

    end
    
    
    Radius = 50;
    
    % simState.CellAntsXyhEffective;
    % simState.mapGridXYPts;

    clear Features  

    AoIMatrix = [DSMMatPerRxPoint.x,DSMMatPerRxPoint.y]; 
    
    
    
    for n = 1:NumRxPoints
    
        RxPoint_Lat = RxPoints(n,1);
        RxPoint_Lon = RxPoints(n,2);
    
        if n > 1
            if NumTiles_DHM ~= NumTiles_DSM
                disp("Tile Number MisMatch");
            end
        end
    
        
        % AoIMatrix = [DSMMatPerRxPoint.lidarLats,DSMMatPerRxPoint.lidarLons];
        % XYCandIndices = (AoIMatrix(:,1) <= RxPoints_XY(n,1) + Radius & AoIMatrix(:,1) >= RxPoints_XY(n,1) - Radius) & (AoIMatrix(:,2)<=RxPoints_XY(n,2)+Radius & AoIMatrix(:,2)>=RxPoints_XY(n,2)-Radius);
        
        % Find points in radius r
        XYCandIndices = find((AoIMatrix(:,1) <= RxPoints_XY(n,1) + Radius & AoIMatrix(:,1) >= RxPoints_XY(n,1) - Radius) & (AoIMatrix(:,2)<=RxPoints_XY(n,2)+Radius & AoIMatrix(:,2)>=RxPoints_XY(n,2)-Radius));
        xCand = AoIMatrix(XYCandIndices,1);
        yCand = AoIMatrix(XYCandIndices,2);
        PoIMatrix = [xCand,yCand]; 
        RepMatXY = repmat([RxPoints_XY(n,1),RxPoints_XY(n,2)],length(XYCandIndices),1);
        DistVec = sqrt(mean((PoIMatrix - RepMatXY).^2,2));
        [~,NearestPointInd] = min(DistVec);
        TargetIndices = XYCandIndices(DistVec < Radius);
    
        % Calculate the Average Clutter Height
    
        RxPointHeight = DSMMatPerRxPoint.lidarZs(NearestPointInd(1)) - DHMMatPerRxPoint.lidarZs(NearestPointInd(1)) + 1.5;
        % ClutterIndex = DHMMatPerRxPoint.lidarZs(TargetIndices) >= 0
        HeightList = DSMMatPerRxPoint.lidarZs(TargetIndices) - RxPointHeight;
        Features.ClutterHeight(n) = mean(HeightList);
        Features.TerrainHeight(n) = mean(DSMMatPerRxPoint.lidarZs(TargetIndices));
    
        % Terrain Roughness 3D
        [~,HeightInd] = sort(HeightList);
        top90percentInd = (round(length(HeightInd)*0.1));
        top10percentInd = (round(length(HeightInd)*0.9));
        top10Height = DSMMatPerRxPoint.lidarZs(top10percentInd) - DHMMatPerRxPoint.lidarZs(top10percentInd);
        top90Height = DSMMatPerRxPoint.lidarZs(top90percentInd) - DHMMatPerRxPoint.lidarZs(top90percentInd);
        Features.TerrainRoughness3D(n) = top10Height - top90Height;
    
        % BS Height
    
        Features.RelativeBSHeight(n) = BSLocations(n,3) - RxPointHeight;
    
        % TxHAAT
        Features.TxHAAT(n) = BSLocations(n,3) - Features.TerrainHeight(n);
    
        % Nearest BS Distance
        Features.NearestBSDist(n) = norm(BSLocations(n,1:2)-RxPoints_XY(n,1:2));
        
        % Calculate Alpha
        Features.Alpha(n) = (Features.RelativeBSHeight(n)-Features.ClutterHeight(n))/Features.NearestBSDist(n);

        tech = DataPerOperator.tech(n);
    
        Features.CenterFreq(n) = Earfcn2Freq(DataPerOperator.earfcn(n),tech{1});
        
        % plot(RxPoints_XY(n,1),RxPoints_XY(n,2),'r*');hold on;
        % plot(BSLocations(BSInd(1),1),BSLocations(BSInd(1),2),'bo');

        
        
    end

    % Plot to check whether the features are generated correctly
    
    % figure(3)
    % % x = linspace(min(Features.ClutterHeight(:,1)),max(Features.ClutterHeight(:,1)),200) ;
    % % y = linspace(min(Features.ClutterHeight(:,2)),max(Features.ClutterHeight(:,2)),200) ;
    % x = linspace(min(RxPoints_XY(:,1)),max(RxPoints_XY(:,1)),100) ;
    % y = linspace(min(RxPoints_XY(:,2)),max(RxPoints_XY(:,2)),100) ;
    % [Xi,Yi] = meshgrid(x,y) ;
    % Zi = griddata(RxPoints_XY(:,1),RxPoints_XY(:,2),Features.ClutterHeight,Xi,Yi) ;
    % surf(Xi,Yi,Zi)
    % colorbar
    % % xlim([min(RxPoints_XY(:,1)),max(RxPoints_XY(:,1))]);
    % % ylim([min(RxPoints_XY(:,2)),max(RxPoints_XY(:,2))]);
    % 
    % 
    % figure(4)
    % imagesc(RxPoints_XY(:,1),RxPoints_XY(:,2),Features.ClutterHeight)
    % xlabel('Angle'), ylabel('Range Bins')
    % box on
    % % view(2)
    % colorbar
    % 
    % figure(5)
    % ecdf(Features.ClutterHeight(:))
    % xlabel('Average Clutter Height')
    
    % figure(6)
    % x = linspace(min(simState.CellAntsXyhEffective(:,1)),max(simState.CellAntsXyhEffective(:,1)),200) ;
    % y = linspace(min(simState.CellAntsXyhEffective(:,2)),max(simState.CellAntsXyhEffective(:,2)),200) ;
    % [Xi,Yi] = meshgrid(x,y) ;
    % Zi = griddata(simState.CellAntsXyhEffective(:,1),simState.CellAntsXyhEffective(:,2),simState.CellAntsXyhEffective(:,3),Xi,Yi) ;
    % surf(Xi,Yi,Zi)
    % colorbar
    % xlim([min(simState.CellAntsXyhEffective(:,1)),max(simState.CellAntsXyhEffective(:,1))]);
    % ylim([min(simState.CellAntsXyhEffective(:,2)),max(simState.CellAntsXyhEffective(:,2))]);
    
    % figure(7)
    % pointsize = 10;
    % scatter(RxPoints_XY(:,1),RxPoints_XY(:,2),pointsize,Features.ClutterHeight)
    % colorbar
    % % caxis([-140 -50]);
    % title('Average Clutter Height')
        
    % FeatureMatrix = [NearestBSDist,ClutterHeight,RelativeBSHeight,TerrainRoughness3D];
    % csvwrite('.\Data\',M)
    
    save(strcat("./Data/Real/Processed/",dataname(p),".mat"))


end


% figure(1)
% x = linspace(min(DHMMatPerRxPoint.x),max(DHMMatPerRxPoint.x),200) ;
% y = linspace(min(DHMMatPerRxPoint.y),max(DHMMatPerRxPoint.y),200) ;
% [Xi,Yi] = meshgrid(x,y) ;
% Zi = griddata(DHMMatPerRxPoint.x,DHMMatPerRxPoint.y,DHMMatPerRxPoint.lidarZs,Xi,Yi) ;
% surf(Xi,Yi,Zi)
% colorbar
% 
% figure(2)
% x = linspace(min(DSMMatPerRxPoint.x),max(DSMMatPerRxPoint.x),200) ;
% y = linspace(min(DSMMatPerRxPoint.y),max(DSMMatPerRxPoint.y),200) ;
% [Xi,Yi] = meshgrid(x,y) ;
% Zi = griddata(DSMMatPerRxPoint.x,DSMMatPerRxPoint.y,DSMMatPerRxPoint.lidarZs,Xi,Yi) ;
% surf(Xi,Yi,Zi)
% colorbar

