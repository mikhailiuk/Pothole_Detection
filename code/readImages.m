function [imgRoad,dispMap ] = readImages(nameRoadImage,nameDisparityImage)
% A function to read images from the files paths to which are provided in
% the arguments:

% Takes arguments: 
% nameRoadImage - path to the image of the road surface
% nameDisparityImage - path to the image of the disparity

% imgRoad - image of the road surface
% dispMap - disparity map of the road surface

% Author: Aliaksei Mikhailiuk

    % Get the path to current directory
	path = pwd;
    
    % Concatenate the current path with the path to the images and read
	s = strcat(pwd,nameRoadImage);
	imgRoad=imread(s);
	imgRoad=imgRoad(1:600,:);
	s = strcat(pwd,nameDisparityImage);
	dispMap=imread(s);

end