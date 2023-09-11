% clear all

% dataname = "ATT";
% dataname = "GoogleFi";
% dataname = "LycaMobile";

% load(strcat("./Data/ACRE/",dataname,".mat"));

% NR EARFCN 520110 --> CenterFreq 2600.550
%

switch dataname
    case "ATT"
        Offset = 13;
    case "GoogleFi"
        Offset = 8;
    case "LycaMobile"
        Offset = 15;
end

switch DataType
    case 'real'
        FeatureMatrix = [DataPerOperator{4}.rsrp-Offset,NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];
        FeatureMatrix = array2table(FeatureMatrix);
        FeatureMatrix.Properties.VariableNames(1:5) = {'Pathloss','NearestBSDist','ClutterHeight','BSHeight','Alpha'};
        % csvwrite('.\Data\ACRE\',M)
        
        writetable(FeatureMatrix,strcat("./Data/ACRE/",dataname,".csv"))

    case 'sim'

        FeatureMatrix = [-simState.coverageItmMapsForEachCell{1,1}{1,1}(MaskInd)',NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];
        FeatureMatrix = array2table(FeatureMatrix);
        FeatureMatrix.Properties.VariableNames(1:5) = {'Pathloss','NearestBSDist','ClutterHeight','BSHeight','Alpha'};
        % csvwrite('.\Data\ACRE\',M)
        
        writetable(FeatureMatrix,strcat("./Data/ACRE/",dataname,".csv"))
end

% save(strcat("./Data/ACRE/",dataname,".mat"))
