function [boxes,boxCount] = boxPotholes(potholesLarge,numberOfClusters)
% The function to put boxes around the clusters of points belonging to a
% pothole:

% Takes arguments: 
% potholesLarge - array of large potholes
% numberOfClusters - number of clusters of potholes

% Returns array of boxes

% Author: Aliaksei Mikhailiuk


    % Find the size of the array with pothole points
    [numberOfLargePotholes,~] = size(potholesLarge);
    
    
    boxCount = 0;
    
    boxes = zeros(numberOfClusters,4);
    % 1 - top, 2 - left, 3 - bottom, 4 - right

    % Go through all clusters
    for i = 1:numberOfClusters
        flag = 0;
        % Go through all points belonging to potholes
        for k = 1:numberOfLargePotholes
            
            % If the cluster of current pothile is equal to the cluster we
            % are looking at
            if (potholesLarge(k,4) == i)
                
                % If it the first instance of this cluster encountered
                if flag == 0
                    % Increment box count
                    boxCount = boxCount+1;
                    boxes(boxCount,1) = potholesLarge(k,2); 
                    boxes(boxCount,2) = potholesLarge(k,3);
                    boxes(boxCount,3) = potholesLarge(k,2); % 2 - row
                    boxes(boxCount,4) = potholesLarge(k,3); % 3 - col
                    
                    % mark that already saw this cluster and thus initial
                    % box is set
                    flag = 1;
                end
                
                % if the point belonging to the pothole is not in the
                % box, change box parameters accordingly
                if (boxes(boxCount,1) > potholesLarge(k,2))
                   boxes(boxCount,1) = potholesLarge(k,2);
                end
                if (boxes(boxCount,3) < potholesLarge(k,2))
                   boxes(boxCount,3) = potholesLarge(k,2);
                end
                if (boxes(boxCount,2) > potholesLarge(k,3))
                   boxes(boxCount,2) = potholesLarge(k,3);
                end
                if (boxes(boxCount,4) < potholesLarge(k,3))
                   boxes(boxCount,4) = potholesLarge(k,3);
                end
            end
        end
    end
end