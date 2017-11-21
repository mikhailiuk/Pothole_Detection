function [imgL,dispMapLRC ] = readImages(nameRoadImage,nameDisparityImage)

	path = pwd;
	s = strcat(pwd,nameRoadImage);
	imgL=imread(s);
	imgL=imgL(1:600,:);
	s = strcat(pwd,nameDisparityImage);
	dispMapLRC=imread(s);

end