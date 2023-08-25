clear all

% DataType = 'real';
DataType = 'sim';
% dataname = "LycaMobile";
% dataname = "GoogleFi";
% dataname = "ATT";
dataname = "Sim_885MHz_Verizon";
% dataname = "Sim_885MHz_ATT";

dirname_DSM = "./Data/DSM/";
dirname_DHM = "./Data/DHM/";

switch DataType
    case 'real'
        % Load Real Data

        Data = readtable('cleaned_combined_indiana_2023_August.csv');

        OperatorList = unique(Data(:,1));
        DataPerOperator = cell(height(OperatorList)-1,1);
        
        for n=2:height(OperatorList)
            index = strfind(Data.operator,OperatorList.operator{n});
            index = cellfun(@(x) ~isempty(x) && x~=0,index);
            DataPerOperator{n} = Data(index,:);
        end
        
        RxPoints = [DataPerOperator{3}.latitude,DataPerOperator{3}.longitude];
        [x_tmp,y_tmp,~] = deg2utm(RxPoints(:,1),RxPoints(:,2));
        RxPoints_XY = [x_tmp,y_tmp];

        NumRxPoints = length(RxPoints);
        % BSLocations_LatLon = [40.4754,	-87.0004; 40.4831,	-86.9633]; % Verizon
        BSLocations_LatLon = [40.4754,	-87.0004]; % Verizon
        % BSLocations_LatLon = [40.4894,	-86.9785]; % AT&T

        % 40.4754	-87.0004	89.88552	294.9 feet | Crown Castle Usa - Dds | Verizon	
        % 40.4831	-86.9633	80.19288	263.1 feet | Gte Mobilnet Incorporated | Verizon	
        % 40.4894	-86.9785	60.68568	199.1 feet | At&t	

        [x_tmp,y_tmp,~] = deg2utm(BSLocations_LatLon(:,1),BSLocations_LatLon(:,2));
        % z_tmp = [89.88552; 80.19288];
        z_tmp = [89.88552]; % Verizon
        % z_tmp = [60.68568]; % AT&T
        BSLocations = [x_tmp,y_tmp,z_tmp];
        NumBS = length(BSLocations(:,1));

        LatLim = [min(min(BSLocations_LatLon(:,1)),min(RxPoints(:,1))),max(max(BSLocations_LatLon(:,1)),max(RxPoints(:,1)))];
        LongLim = [min(min(BSLocations_LatLon(:,2)),min(RxPoints(:,2))),max(max(BSLocations_LatLon(:,2)),max(RxPoints(:,2)))];

    case 'sim'

        % Load Sim Data
        load("./Data/ACRE/ACRE_885MHz/simState.mat");
        load("./Data/ACRE/ACRE_885MHz/simConfigs.mat");
        
        RxPoints = simState.mapGridLatLonPts;
        MaskInd = (RxPoints(:,1) > 40.4648 & RxPoints(:,1) < 40.491) & (RxPoints(:,2) > -87.0032 & RxPoints(:,2) < -86.9675);
        RxPoints = RxPoints(MaskInd,:);
        % RxPoints = [linspace(40.4648,40.4920,1000)',linspace(-87.0033,-86.9675,1000)'];
        [x_tmp,y_tmp,~] = deg2utm(RxPoints(:,1),RxPoints(:,2));
        RxPoints_XY = [x_tmp,y_tmp];
        
        NumRxPoints = length(RxPoints);
        BSLocations = simState.CellAntsXyhEffective;
        
        % BSLocations = BSLocations(1,:); % Verizon 1
        BSLocations = BSLocations(3,:); % AT&T

        NumBS = length(BSLocations(:,1));

        [lat,lon] = utm2deg(BSLocations(:,1),BSLocations(:,2),repmat(simConfigs.UTM_ZONE,NumBS,1));
        BSLocations_LatLon = [lat,lon];
        
        
        UTM_Zone_vec = repmat(simConfigs.UTM_ZONE,length(simState.mapGridXYPts(:,2)),1);
        % [Lat,Long] = utm2deg(simState.mapGridXYPts(:,1),simState.mapGridXYPts(:,2),UTM_Zone_vec);
        LatLim = [min(RxPoints(:,1)),max(RxPoints(:,1))];
        LongLim = [min(RxPoints(:,2)),max(RxPoints(:,2))];

end





% Search for DSM Tiles

load("./Data/ACRE/TileAddressBook_DSM.mat");
% load("./Data/TileAddressBook_DSM_ALL.mat");

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

load("./Data/ACRE/TileAddressBook_DHM.mat");


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


% Calculate the BS Heights

for n = 1:length(BSLocations(:,1))

    RxPoint_Lat = BSLocations_LatLon(n,1);
    RxPoint_Lon = BSLocations_LatLon(n,2);

    LatLimMat = zeros(length(DHMAddressBook),2);
    LongLimMat = zeros(length(DHMAddressBook),2);

    for l = 1:length(DHMAddressBook)
        LatLimMat(l,:) = DHMAddressBook(l).LatLim;
        LongLimMat(l,:) = DHMAddressBook(l).LongLim;
    end    
    
    index1 = LatLimMat(:,1) <= RxPoint_Lat & LatLimMat(:,2) >= RxPoint_Lat;
    index2 = LongLimMat(:,1) <= RxPoint_Lon & LongLimMat(:,2) >= RxPoint_Lon;

    TileIndex = index1 & index2;
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

    AoIMatrix = [DSMMatPerRxPoint.x,DSMMatPerRxPoint.y]; 
    RepMatXY = repmat([BSLocations(n,1),BSLocations(n,2)],length(AoIMatrix(:,1)),1);
    DistVec = sqrt(mean((AoIMatrix - RepMatXY).^2,2));
    [~,NearestPointInd] = min(DistVec);
    BSLocations(n,3) = DSMMatPerRxPoint.lidarZs(NearestPointInd(1)) - DHMMatPerRxPoint.lidarZs(NearestPointInd(1)) + BSLocations(n,3);
    

end

% Set the Area of Interest (AoI)

NearestBSDist = zeros(NumRxPoints,1);
ClutterHeight = zeros(NumRxPoints,1);
RelativeBSHeight = zeros(NumRxPoints,1);
Alpha = zeros(NumRxPoints,1);
Radius = 100;

% simState.CellAntsXyhEffective;
% simState.mapGridXYPts;




for n = 1:NumRxPoints

    RxPoint_Lat = RxPoints(n,1);
    RxPoint_Lon = RxPoints(n,2);

    % Import DHM Tiles

    LatLimMat = zeros(length(DHMAddressBook),2);
    LongLimMat = zeros(length(DHMAddressBook),2);

    for l = 1:length(DHMAddressBook)
        LatLimMat(l,:) = DHMAddressBook(l).LatLim;
        LongLimMat(l,:) = DHMAddressBook(l).LongLim;
    end    
    
    index1 = LatLimMat(:,1) <= RxPoint_Lat & LatLimMat(:,2) >= RxPoint_Lat;
    index2 = LongLimMat(:,1) <= RxPoint_Lon & LongLimMat(:,2) >= RxPoint_Lon;


    if n == 1 || find(TileIndex) ~= find(index1 & index2)
        
            TileIndex = index1 & index2;
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

    % LatLimMat = zeros(length(DSMAddressBook),2);
    % LongLimMat = zeros(length(DSMAddressBook),2);
    % 
    % for l = 1:length(DSMAddressBook)
    %     LatLimMat(l,:) = DSMAddressBook(l).LatLim;
    %     LongLimMat(l,:) = DSMAddressBook(l).LongLim;
    % end    
    % 
    % index1 = LatLimMat(:,1) <= RxPoint_Lat & LatLimMat(:,2) >= RxPoint_Lat;
    % index2 = LongLimMat(:,1) <= RxPoint_Lon & LongLimMat(:,2) >= RxPoint_Lon;
    % 
    % if n == 1 || find(TileIndex) ~= find(index1 & index2)
    
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

    if n > 1
        if NumTiles_DHM ~= NumTiles_DSM
            disp("Tile Number MisMatch");
        end
    end

    AoIMatrix = [DSMMatPerRxPoint.x,DSMMatPerRxPoint.y]; 
    % AoIMatrix = [DSMMatPerRxPoint.lidarLats,DSMMatPerRxPoint.lidarLons];
    % XYCandIndices = (AoIMatrix(:,1) <= RxPoints_XY(n,1) + Radius & AoIMatrix(:,1) >= RxPoints_XY(n,1) - Radius) & (AoIMatrix(:,2)<=RxPoints_XY(n,2)+Radius & AoIMatrix(:,2)>=RxPoints_XY(n,2)-Radius);
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
    HeightList = DSMMatPerRxPoint.lidarZs(TargetIndices) - RxPointHeight;
    ClutterHeight(n) = mean(HeightList);

    % Calculate the Average Height of the N-Nearest BSs
    
    RepMatXY = repmat([RxPoints_XY(n,1),RxPoints_XY(n,2)],NumBS,1);
    DistVec = sqrt(mean((BSLocations(:,1:2) - RepMatXY).^2,2));
    [~,BSInd] = min(DistVec);
    % RelativeBSHeight(n) = mean(simState.CellAntsXyhEffective(BSInd,3));
    RepMatXY = repmat([BSLocations(BSInd,1),BSLocations(BSInd,2)],length(AoIMatrix(:,1)),1);
    DistVec = sqrt(mean((AoIMatrix - RepMatXY).^2,2));

    RelativeBSHeight(n) = mean(BSLocations(BSInd,3)) - RxPointHeight;

    % Nearest BS Distance
    NearestBSDist(n) = DistVec(BSInd(1));
    
    % Calculate Alpha
    Alpha(n) = (RelativeBSHeight(n)-ClutterHeight(n))/NearestBSDist(n);
    
    % plot(RxPoints_XY(n,1),RxPoints_XY(n,2),'r*');hold on;
    % plot(BSLocations(BSInd(1),1),BSLocations(BSInd(1),2),'bo');
    
end




figure(3)
% x = linspace(min(ClutterHeight(:,1)),max(ClutterHeight(:,1)),200) ;
% y = linspace(min(ClutterHeight(:,2)),max(ClutterHeight(:,2)),200) ;
x = linspace(min(RxPoints_XY(:,1)),max(RxPoints_XY(:,1)),100) ;
y = linspace(min(RxPoints_XY(:,2)),max(RxPoints_XY(:,2)),100) ;
[Xi,Yi] = meshgrid(x,y) ;
Zi = griddata(RxPoints_XY(:,1),RxPoints_XY(:,2),ClutterHeight,Xi,Yi) ;
surf(Xi,Yi,Zi)
colorbar
% xlim([min(RxPoints_XY(:,1)),max(RxPoints_XY(:,1))]);
% ylim([min(RxPoints_XY(:,2)),max(RxPoints_XY(:,2))]);


figure(4)
imagesc(RxPoints_XY(:,1),RxPoints_XY(:,2),ClutterHeight)
xlabel('Angle'), ylabel('Range Bins')
box on
% view(2)
colorbar

figure(5)
ecdf(ClutterHeight(:))
xlabel('Average Clutter Height')

% figure(6)
% x = linspace(min(simState.CellAntsXyhEffective(:,1)),max(simState.CellAntsXyhEffective(:,1)),200) ;
% y = linspace(min(simState.CellAntsXyhEffective(:,2)),max(simState.CellAntsXyhEffective(:,2)),200) ;
% [Xi,Yi] = meshgrid(x,y) ;
% Zi = griddata(simState.CellAntsXyhEffective(:,1),simState.CellAntsXyhEffective(:,2),simState.CellAntsXyhEffective(:,3),Xi,Yi) ;
% surf(Xi,Yi,Zi)
% colorbar
% xlim([min(simState.CellAntsXyhEffective(:,1)),max(simState.CellAntsXyhEffective(:,1))]);
% ylim([min(simState.CellAntsXyhEffective(:,2)),max(simState.CellAntsXyhEffective(:,2))]);

figure(7)
pointsize = 10;
scatter(RxPoints_XY(:,1),RxPoints_XY(:,2),pointsize,ClutterHeight)
colorbar
% caxis([-140 -50]);
title('Average Clutter Height')


FeatureMatrix = [NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];
% csvwrite('.\Data\',M)

% save("./Data/LycaMobile.Mat")
save(strcat("./Data/ACRE/",dataname,".mat"))


