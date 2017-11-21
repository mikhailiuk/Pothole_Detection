%This file creates a file with parameteres required for the pothole
%detection and passes them to the pothole detection algorithm. 

% Author: Aliaksei Mikhailiuk

clear all

% Add path to the code directory
addpath('./code')

% Paths to images with pothole data: 
% image of the road
% disparity map
params.nameRoadImage = '/data/Rec_L0236.png';
params.nameDisparityImage ='/data/Disp0236.png';

% The shape of the region of interest is trapezium with a longer side on the bottom
% Top row in the region of intereset
params.topRow=130;
% Top collumn in the region of interest in the region of interest
params.topColum=330;

% Last column in the region of interest
params.bottomColum=1;

% Number of points to skip
params.skipPoints = 5;

% Number of random grids
params.numberOfGrids = 10;

% Number of columns in a grid (vertical)
params.gridCollumns  = 10;

% Number of rows in a grid (horisontal)
params.gridRows = 10; 

% Run pothole detection algorithm
potholeDetection(params);