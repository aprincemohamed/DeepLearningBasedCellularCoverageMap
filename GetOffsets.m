clear all

load('./Data/Training Data/Lindberg_S20.mat')

[max_rsrp , ind] = max(DataPerOperator.rsrp);

Features.CenterFreq(ind)

XY = RxPoints_XY(ind,:)

SimBSLoc = BSLocations(1,:)

load("./Data/Lindberg Village/Sim/Simulation_LindbergVillage_ML_Carrier_2160MHz_LiDAR_IN_DSM_2019/simState.mat");
load("./Data/Lindberg Village/Sim/Simulation_LindbergVillage_ML_Carrier_2160MHz_LiDAR_IN_DSM_2019/simConfigs.mat");

RxPoints = simState.mapGridLatLonPts;
% MaskInd = (RxPoints(:,1) > 40.4648 & RxPoints(:,1) < 40.491) & (RxPoints(:,2) > -87.0034 & RxPoints(:,2) < -86.9674);
% RxPoints = RxPoints(MaskInd,:);
[x_tmp,y_tmp,~] = deg2utm(RxPoints(:,1),RxPoints(:,2));
RxPoints_XY = [x_tmp,y_tmp];

Target_XY = repmat(XY,length(RxPoints_XY),1);
Dist = sqrt(sum((RxPoints_XY - Target_XY).^2,2));
[~,min_ind] = min(Dist); 

NumRxPoints = length(RxPoints);
RealBSLoc = simState.CellAntsXyhEffective;


offset = max_rsrp + simState.coverageItmMapsForEachCell{1,1}{1,1}(min_ind)

