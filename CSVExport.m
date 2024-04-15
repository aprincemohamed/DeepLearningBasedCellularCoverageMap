% Export the pre-processed Mat data as .csv

% dir
% dir Dirname
% Dataname = dir(ProcDirname);
% Dataname(1:2) = [];
% 
% for q = 1:length(Dataname)
% 
%     load(strcat(Dirname,Dataname(q).name))
    
switch DataType
    case 'real'
        % FeatureMatrix = [DataPerOperator{4}.rsrp-Offset,NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];

        FeatureMatrix = [DataPerOperator.rsrp,Features.CenterFreq',Features.NearestBSDist',Features.ClutterHeight',-Features.TerrainRoughness3D',Features.RelativeBSHeight',Features.TxHAAT',Features.Alpha'];
        FeatureMatrix = array2table(FeatureMatrix);
        FeatureMatrix.Properties.VariableNames(1:8) = {'Pathloss','CenterFreq','NearestBSDist','ClutterHeight','TerrainRoughness','BSHeight','TxHAAT','Alpha'};
        % csvwrite('.\Data\ACRE\',M)
        
        % writetable(FeatureMatrix,strcat("./Data/",Filename(q),".csv"))

        Filename = dataname(p).name;
        % Filename = Dataname(q).name;
        Filename(end-3:end) = [];
        writetable(FeatureMatrix,strcat(CSVDirname,Filename,".csv"))

        
    case 'sim'

        % FeatureMatrix = [-simState.coverageItmMapsForEachCell{1,1}{1,1}(MaskInd)',NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];
        % FeatureMatrix = array2table(FeatureMatrix);
        % FeatureMatrix.Properties.VariableNames(1:5) = {'Pathloss','NearestBSDist','ClutterHeight','BSHeight','Alpha'};
        % % csvwrite('.\Data\ACRE\',M)
        FeatureMatrix = [-simState.coverageItmMapsForEachCell{1,1}{1,1}',Features.CenterFreq',Features.NearestBSDist',Features.ClutterHeight',-Features.TerrainRoughness3D',Features.RelativeBSHeight',Features.TxHAAT',Features.Alpha'];
        FeatureMatrix = array2table(FeatureMatrix);
        FeatureMatrix.Properties.VariableNames(1:8) = {'Pathloss','CenterFreq','NearestBSDist','ClutterHeight','TerrainRoughness','BSHeight','TxHAAT','Alpha'};
        % csvwrite('.\Data\ACRE\',M))
        
        % Filename = Dataname(q).name;
        % Filename(end-3:end) = [];
        Filename = strcat("./Data/Sim/Processed/",dataname(p).name,'_BS',num2str(iter_BS));
        writetable(FeatureMatrix,strcat(CSVDirname,Filename,".csv"))
end

% end

% save(strcat("./Data/ACRE/",dataname,".mat"))
