function [potholes,potholePoints] = findPointsBelowEstimatedSurface(realPoints,aLSrg_old,skipPoints)
    [tt,jj] = size(realPoints);
    potholePoints= 0;
    for ii = 1:skipPoints:tt

        % Position of the pixel  
        xx = realPoints(ii,3);
        yy = realPoints(ii,2);

        % Get estimation from the Least Squares algorithm for the current
        % position of the pixel
        estimation = aLSrg_old(1)+yy*aLSrg_old(2)+xx*aLSrg_old(3)+xx*yy*aLSrg_old(4)+yy^2*aLSrg_old(5)+xx^2*aLSrg_old(6);


        disparityGiven =realPoints(ii,1);

        % Algorithm is more sensitive to the points closer to the camera
        condition1 =(2*abs(exp(600/(yy-30)))+15*yy/600-10);

        % Don't take into account outliers, points need to be sufficiently close
        % to the road surface
        condition2 = (yy*0.063+18);

        % If the condition is satisfied, put current index into the array with
        % pothole values
        if((disparityGiven - estimation)^2>condition1 & (disparityGiven - estimation)<0 &(disparityGiven - estimation)^2<condition2)
            potholePoints=potholePoints+1;
            potholes(potholePoints,:)=realPoints(ii,:);
        end
    end
end