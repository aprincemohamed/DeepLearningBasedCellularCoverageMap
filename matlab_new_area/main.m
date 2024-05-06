clear all
close all

% Configure data type

DataType = 'real'; % Measurement Data
% DataType = 'sim'; % Simulation Data

switch DataType
    case 'real'
        %RawDirname = "./Data/Real/Raw1/";  Simulation data directory   
        RawDirname = "./Data/Real/Test/"; % Simulation data directory   
        dataname = dir(RawDirname);
        dataname(1:2) = [];
        ExtractFeatures_Real;
        CSVDirname = "./Data/Real/CSV/";
        
    case 'sim'
        RawDirname = "./Data/Sim/Raw/"; % Simulation data directory
        dir
        dir dirname
        dataname = dir(RawDirname);
        dataname(1:2) = [];
        ExtractFeatures_Sim;
        CSVDirname = "./Data/Sim/CSV/"; 
end