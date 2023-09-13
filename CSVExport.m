% clear all

dataname = ["./Data/ACRE/ACRE_S21.mat","./Data/ACRE/ACRE_Lyca.mat","./Data/ACRE/ACRE_GoogleFi.mat"];

for n = 1:length(dataname)

    switch dataname(n)
        case "Lindberg_S8"
            Offset = 13;
        case "ACRE_Lyca"
             Offset = 13;
        case "ACRE_GoogleFi"
             Offset = 13;
        % case "ATT"
        %     Offset = 13;
        % case "GoogleFi"
        %     Offset = 8;
        % case "LycaMobile"
        %     Offset = 15;
    end
    
    switch DataType
        case 'real'
            % FeatureMatrix = [DataPerOperator{4}.rsrp-Offset,NearestBSDist,ClutterHeight,RelativeBSHeight,Alpha];
Features.ClutterHeight(n) = mean(HeightList);
    Features.TerrainHeight(n) = mean(DSMMatPerRxPoint.lidarZs(TargetIndices));
    Features.TerrainRoughness3D(n) = top10Height - top90Height;
     Features.RelativeBSHeight(n) = BSLocations(n,3) - RxPointHeight;
     Features.TxHAAT(n) = BSLocations(n,3) - Features.TerrainHeight(n);
     Features.NearestBSDist(n) = norm(BSLocations(n,1:2)-RxPoints_XY(n,1:2));
     Features.TerrainRoughness3D(n) = (Features.RelativeBSHeight(n)-Features.ClutterHeight(n))/Features.NearestBSDist(n);
     Features.CenterFreq(n) = Earfcn2Freq(DataPerOperator.earfcn(n),tech{1});

            FeatureMatrix = [DataPerOperator.rsrp,Features.CenterFreq,Features.NearestBSDist,Features.ClutterHeight,Features.TerrainRoughness3D,Features.RelativeBSHeight,Features.TxHAAT]
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

end

% save(strcat("./Data/ACRE/",dataname,".mat"))
