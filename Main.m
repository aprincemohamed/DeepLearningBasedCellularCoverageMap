clear all
close all

% Configure data type

% DataType = 'real'; % Measurement
DataType = 'sim'; % Simulation


switch DataType
    case 'real'
        RawDirname = "./Data/Real/Raw/"; % Simulation data directory   
        dir
        dir dirname
        dataname = dir(RawDirname);
        dataname(1:2) = [];
        ExtractFeatures_Real;

        ProcDirname = "./Data/Real/Processed/";
        CSVDirname = "./Data/Real/CSV/";
        
    case 'sim'
        RawDirname = "./Data/Sim/Raw/"; % Simulation data directory
        dir
        dir dirname
        dataname = dir(RawDirname);
        dataname(1:2) = [];
        ExtractFeatures_Sim;

        ProcDirname = "./Data/Sim/Processed/";
        CSVDirname = "./Data/Sim/CSV/";
end

CSVExport;




