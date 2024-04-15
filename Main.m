clear all
close all


DataType = 'real'; % Measurement
% DataType = 'sim'; % Simulation

% Input data files
filename = ["./Data/ACRE/S21.csv","./Data/ACRE/lyca.csv","./Data/ACRE/google_fi.csv"];
dataname = ["ACRE_S21","ACRE_Lyca","ACRE_GoogleFi"];

% dirname = "./Data/ACRE/Sim/"; % Lidar File Directory
% dir
% dir dirname
% dataname = dir(dirname);
% dataname(1:2) = [];

ExtractFeatures;
