% clear all

% Dataname = ["./Data/Lindberg_S20.mat","./Data/Lindberg_S8.mat","./Data/HappyHollows_S20.mat","./Data/HappyHollows_S8.mat","./Data/ACRE_Lyca.mat"];
% Filename = ["Lindberg_S20","Lindberg_S8","HappyHollows_S20","HappyHollows_S8","ACRE_Lyca"];

% Dataname = ["./Data/HappyHollows_S21.mat"];
% Filename = ["HappyHollows_S21"];

% Dataname = ["./Data/ACRE_GoogleFi.mat"];
% Filename = ["ACRE_GoogleFi"];
% 
% Dataname = ["./Data/ACRE_S21.mat"];
% Filename = ["ACRE_S21"];

Dirname = "./Data/Sim/"; % Lidar File Directory
% dir
% dir Dirname
Dataname = dir(Dirname);
Dataname(1:2) = [];

for q = 1:length(Dataname)

    load(strcat(Dirname,Dataname(q).name))
    
    switch DataType
        case 'real'
            % FeatureMatrix = [DataPerOperator{4}.rsrp-Offset,NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];

            FeatureMatrix = [DataPerOperator.rsrp,Features.CenterFreq',Features.NearestBSDist',Features.ClutterHeight',-Features.TerrainRoughness3D',Features.RelativeBSHeight',Features.TxHAAT',Features.Alpha'];
            FeatureMatrix = array2table(FeatureMatrix);
            FeatureMatrix.Properties.VariableNames(1:8) = {'Pathloss','CenterFreq','NearestBSDist','ClutterHeight','TerrainRoughness','BSHeight','TxHAAT','Alpha'};
            % csvwrite('.\Data\ACRE\',M)
            
            % writetable(FeatureMatrix,strcat("./Data/",Filename(q),".csv"))
            Filename = Dataname(q).name;
            Filename(end-3:end) = [];
            writetable(FeatureMatrix,strcat("./Data/",Filename,".csv"))

            

    
        case 'sim'
            % 
            % FeatureMatrix = [-simState.coverageItmMapsForEachCell{1,1}{1,1}(MaskInd)',NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];
            % FeatureMatrix = array2table(FeatureMatrix);
            % FeatureMatrix.Properties.VariableNames(1:5) = {'Pathloss','NearestBSDist','ClutterHeight','BSHeight','Alpha'};
            % % csvwrite('.\Data\ACRE\',M)
            FeatureMatrix = [-simState.coverageItmMapsForEachCell{1,1}{1,1}',Features.CenterFreq',Features.NearestBSDist',Features.ClutterHeight',-Features.TerrainRoughness3D',Features.RelativeBSHeight',Features.TxHAAT',Features.Alpha'];
            FeatureMatrix = array2table(FeatureMatrix);
            FeatureMatrix.Properties.VariableNames(1:8) = {'Pathloss','CenterFreq','NearestBSDist','ClutterHeight','TerrainRoughness','BSHeight','TxHAAT','Alpha'};
            % csvwrite('.\Data\ACRE\',M))
            
            Filename = Dataname(q).name;
            Filename(end-3:end) = [];
            writetable(FeatureMatrix,strcat("./Data/",Filename,".csv"))
    end

end

% save(strcat("./Data/ACRE/",dataname,".mat"))
