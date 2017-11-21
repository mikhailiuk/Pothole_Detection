function [potholesLarge]= removeOutliersPotholes(potholes,skipPoints)
% A funciton to remove too small cluster of points

% Takes as arguments:

% potholes - array of points identified as pothols
% skipPoints - number of points to skip (improves speed)

% Returns:
% potholesLarge - array containing only potholes points having enough
% neighbours

% Author: Aliaksei Mikhailiuk


    [potholePoints,~] = size(potholes);
    potholes (:,4) = 0;
    for ii = 1:potholePoints
        for jj = (ii+1):potholePoints
            % Find number of neighbours in the radius of 11 around each point
            % belonging to a pothole
            if (abs(potholes(ii,2) - potholes(jj,2))<11 & abs(potholes(ii,3) - potholes(jj,3))<11)
               potholes(ii,4)=potholes(ii,4)+1;
               potholes(jj,4)=potholes(jj,4)+1;
            end
        end 
    end

    potholesLarge = 0;
    cnt = 1;
    for ii = 1:potholePoints
        % Leave only large clusters of potholes
        if (potholes(ii,4) > 250/skipPoints)
            potholesLarge(cnt,1) = potholes(ii,1);
            potholesLarge(cnt,2) = potholes(ii,2);
            potholesLarge(cnt,3) = potholes(ii,3);
            cnt = cnt+1;
        end
    end 
end