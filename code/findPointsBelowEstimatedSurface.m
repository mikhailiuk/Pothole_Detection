function [potholes,potholesSize] = findPointsBelowEstimatedSurface(realPoints,coefs,skipPoints)
% A function to find points laying below the modeled surface. Goes through
% all the points and find thouse which value is withing certain range below
% the modelled surface

% Takes arguments:

% realPoints - point belonging to the road surface
% coefs - Least squares coefficients
% skipPoints - number of points to skip (improves the speed)

% Returns: 
% potholes - potholes array (points potentially belonging to potholes)

% Author: Aliaksei Mikhailiuk

    [tt,jj] = size(realPoints);
    potholesSize= 0;
    for ii = 1:skipPoints:tt

        % Position of the pixel  
        xx = realPoints(ii,3);
        yy = realPoints(ii,2);

        % Get estimation from the Least Squares algorithm for the current
        % position of the pixel
        estimation = coefs(1)+yy*coefs(2)+xx*coefs(3)+xx*yy*coefs(4)+yy^2*coefs(5)+xx^2*coefs(6);


        disparityGiven =realPoints(ii,1);

        % Algorithm is more sensitive to the points closer to the camera
        condition1 =(2*abs(exp(600/(yy-30)))+15*yy/600-10);

        % Don't take into account outliers, points need to be sufficiently close
        % to the road surface
        condition2 = (yy*0.063+18);

        % If the condition is satisfied, put current index into the array with
        % pothole values
        if((disparityGiven - estimation)^2>condition1 & (disparityGiven - estimation)<0 &(disparityGiven - estimation)^2<condition2)
            potholesSize=potholesSize+1;
            potholes(potholesSize,:)=realPoints(ii,:);
        end
    end
end