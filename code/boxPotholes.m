function [clusters,boxCount] = boxPotholes(potholesLarge,numberOfClusters,numberOfLargePotholes)
    boxCount = 0;
    % 1 - top, 2 - left, 3 - bottom, 4 - right
    for i = 1:numberOfClusters
        flag = 0;
        for k = 1:numberOfLargePotholes
            if (potholesLarge(k,4) == i)
                if flag == 0
                    boxCount = boxCount+1;
                    clusters(boxCount,1) = potholesLarge(k,2); 
                    clusters(boxCount,2) = potholesLarge(k,3);
                    clusters(boxCount,3) = potholesLarge(k,2); % 2 - row
                    clusters(boxCount,4) = potholesLarge(k,3); % 3 - col
                    flag = 1;
                end
                if (clusters(boxCount,1) > potholesLarge(k,2))
                   clusters(boxCount,1) = potholesLarge(k,2);
                end
                if (clusters(boxCount,3) < potholesLarge(k,2))
                   clusters(boxCount,3) = potholesLarge(k,2);
                end
                if (clusters(boxCount,2) > potholesLarge(k,3))
                   clusters(boxCount,2) = potholesLarge(k,3);
                end
                if (clusters(boxCount,4) < potholesLarge(k,3))
                   clusters(boxCount,4) = potholesLarge(k,3);
                end
            end
        end
    end
end