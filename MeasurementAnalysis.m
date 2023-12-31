close all

% Data = readtable('./Data/Happy Hollows/happy_hallow_s21.csv');
Data = readtable('./Data/Lindberg Village/lindberg_s20.csv');

OperatorList = unique(Data(:,1));
% DataPerOperator = cell(height(OperatorList)-1,1);
DataPerOperator = cell(height(OperatorList),1);

for n=1:height(OperatorList)
    index = strfind(Data.operator,OperatorList.operator{n});
    index = cellfun(@(x) ~isempty(x) && x~=0,index);
    DataPerOperator{n} = Data(index,:);
end

[X,Y,~] = deg2utm(DataPerOperator{1}.latitude,DataPerOperator{1}.longitude);

figure(1)
pointsize = 10;
scatter(X,Y,pointsize,DataPerOperator{1}.rsrp)
colorbar
caxis([-140 -50]);
title('Lindberg Village RSRP Distribution (AT&T)')


% [X,Y,~] = deg2utm(DataPerOperator{3}.latitude,DataPerOperator{3}.longitude);
% 
% [max_val,max_ind] = max(DataPerOperator{3}.rsrp);
% X(max_ind)
% Y(max_ind)
% return
% figure(2)
% pointsize = 10;
% scatter(X,Y,pointsize,DataPerOperator{3}.rsrp); hold on;
% plot(X(max_ind),Y(max_ind),'khexagram','MarkerSize',5)
% colorbar
% title('GoogleFi Distribution')
% caxis([-140 -50]);
% 
% [X,Y,~] = deg2utm(DataPerOperator{4}.latitude,DataPerOperator{4}.longitude);
% 
% figure(3)
% pointsize = 10;
% scatter(X,Y,pointsize,DataPerOperator{4}.rsrp)
% colorbar
% title('LycaMobile Distribution')
% caxis([-140 -50]);


load("./Data/Lindberg Village/Sim/Simulation_LindbergVillage_ML_Carrier_2538.2MHz_LiDAR_IN_DSM_2019/simState.mat");
load("./Data/Lindberg Village/Sim/Simulation_LindbergVillage_ML_Carrier_2538.2MHz_LiDAR_IN_DSM_2019/simConfigs.mat");

RxPoints = simState.mapGridLatLonPts;
% MaskInd = (RxPoints(:,1) > 40.4648 & RxPoints(:,1) < 40.491) & (RxPoints(:,2) > -87.0034 & RxPoints(:,2) < -86.9674);
% RxPoints = RxPoints(MaskInd,:);
[x_tmp,y_tmp,~] = deg2utm(RxPoints(:,1),RxPoints(:,2));
RxPoints_XY = [x_tmp,y_tmp];

NumRxPoints = length(RxPoints);
BSLocations = simState.CellAntsXyhEffective;

% 
figure(4)
pointsize = 10;
scatter(RxPoints_XY(:,1),RxPoints_XY(:,2),pointsize,-simState.coverageItmMapsForEachCell{1,1}{1,1});hold on;
plot(BSLocations(1,1),BSLocations(1,2),'khexagram','MarkerSize',20);
colorbar
title('Sim (Lindberg) Distribution')
% 
% 
% figure(5)
% pointsize = 10;
% scatter(RxPoints_XY(:,1),RxPoints_XY(:,2),pointsize,-simState.coverageItmMapsForEachCell{3,1}{1,1});hold on;
% plot(BSLocations(3,1),BSLocations(3,2),'khexagram','MarkerSize',20);
% colorbar
% title('Sim (AT&T) Distribution')
% caxis([-140 -50]);