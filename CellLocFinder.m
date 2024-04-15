function CellLoc = CellLocFinder(cellId)

    CellLoc = zeros(length(cellId),5);
        
    CellIdTable = [190684 192695 193022 527198 527199 537253 28265 107969 117769 191004 196004 191040 191016 ];
    % CellIdTable = repmat(CellIdTable,length(cellId),1);
    
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

    BSHeight = [
        252.697908286133	
        276.207164375000	
        287.192141895909	
        276.207164375000	
        276.207164375000	
        276.207164375000	
        276.207164375000	
        276.207164375000	
        271.004210100098	
        235.720480590665	
        235.720480590665	
        234.098944025879	
        271.004210100098    
    ];

    CellLocTable = [CellLocTable,x,y];
    CellLocTable(:,3) = 0.3048*CellLocTable(:,3); % Change unit from ft to m

    % CellLocTable = [CellLocTable(:,1:2),x,y];    
    % CellLocTable = [CellLocTable,BSHeight];
    

    for n = 1:length(cellId)
        Index = CellIdTable==cellId(n);
        CellLoc(n,:) = CellLocTable(Index, :);
    end

    

    % 40.4754	-87.0004	89.88552	294.9 feet | Crown Castle Usa - Dds | Verizon	
    % 40.4831	-86.9633	80.19288	263.1 feet | Gte Mobilnet Incorporated | Verizon	
    % 40.4894	-86.9785	60.68568	199.1 feet | At&t	

    % BSLocations_LatLon = [40.4754,	-87.0004; 40.4831,	-86.9633]; % Verizon
    % BSLocations_LatLon = [40.4754,	-87.0004]; % Verizon
    % BSLocations_LatLon = [40.4894,	-86.9785]; % AT&T



    % BSLocations_LatLon = [40.4754,	-87.0004; 40.4831,	-86.9633]; % Verizon
    % BSLocations_LatLon = [40.4754,	-87.0004]; % Verizon
    % BSLocations_LatLon = [40.4894,	-86.9785]; % AT&T

    % z_tmp = [89.88552; 80.19288];
    % z_tmp = [89.88552]; % Verizon
    % z_tmp = [60.68568]; % AT&T


end