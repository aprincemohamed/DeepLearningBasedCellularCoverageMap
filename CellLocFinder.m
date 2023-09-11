function CellLoc = CellLocFinder(cellId)

    CellIdTable = [191004 196004 191040 191016];
    
    CellLocTable = [
        
    % [40.4754, -87.0004, 89.88552,]; % ACRE Verizon
    [40.429,-86.8754,188,] % Happy Hollows 1
    [40.429,-86.8754,188,] % Happy Hollows 1
    [40.4452,-86.8635,178.1,] % Happy Hollows 2
    [40.4546, -86.966, 192.9,]]; % Lindberg Village

    Index = CellIdTable==cellId;
    CellLoc = CellLocTable(Index, :);

end