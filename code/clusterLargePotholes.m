function [potholesLarge,numberOfClusters]= clusterLargePotholes(potholesLarge,skipPoints)
% A function to put pothole points laying close to each other into clusters

% Takes as arguments:

% potholesLarge - array of large potholes
% skipPoints - how many points to skip in the computation

% Returns:
% potholesLarge - same array as in the input with additional column for the
% cluster number a point belongs to

% Author: Aliaksei Mikhailiuk


    [numberOfLargePotholes,~] = size(potholesLarge);
    potholesLarge(:,4) = 0;
    numberOfClusters = 0;
    % Go through all points belonging to potholes
    for ii = 1:numberOfLargePotholes

        % If encounter new cluster (i.e. point not belonging to any),
        % increment the cluster counter
        if potholesLarge(ii,4) == 0
            numberOfClusters = numberOfClusters + 1;
            potholesLarge(ii,4) = numberOfClusters;
        end
        % Go through all subsequent pothole points
        for jj = (ii+1):numberOfLargePotholes

            % If two points are sufficiently close together, cluster
            % them
            if (abs(potholesLarge(ii,2) - potholesLarge(jj,2))<skipPoints & abs(potholesLarge(ii,3) - potholesLarge(jj,3))<skipPoints) %<2
                % If jj pothole does not have a cluster, assign it
                % cluster of the ii pothole
                if (potholesLarge(jj,4)==0)
                    potholesLarge(jj,4) = potholesLarge(ii,4);
                else 

                   oldClusterId =  potholesLarge(ii,4);
                   % Reassign all the points in the ii point cluster, 
                   % cluster of point jj
                   for k=1:numberOfLargePotholes
                       if (potholesLarge(k,4) == oldClusterId)
                           potholesLarge(k,4) = potholesLarge(jj,4);
                       end
                   end

                end
            end
        end
    end

end