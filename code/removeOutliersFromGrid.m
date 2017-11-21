function [leastSq] = removeOutliersFromGrid(leastSq,gridRows,gridCollumns)
    sum_means = 0;
    sum_y = 0;
    sum_n_xy = 0;
    sum_d_xx = 0;

    
    means = zeros(gridRows,2);

    for ii = 1:gridRows



        sum = 0;
        sum_cent = 0;
        zero_cent = 0;
        zero_counter= 0;
        cent_count = 0;



        for jj = 1:gridCollumns

            % Current index in a grid
            index= (ii-1)*gridCollumns+jj;
            
            % Sum over all element in the row
            sum =sum+leastSq(index,1);

            % Current value is in the center of the row
            if (abs(gridCollumns/2 - jj)<gridCollumns/4)
                
                % Sum all disparity values in a row
                sum_cent = sum_cent+leastSq(index,1);

                % If the disparity value of the current pixel is missing 
                if (leastSq(index,1)<=0)
                    zero_cent = zero_cent+1;
                else
                    cent_count = cent_count+1;
                end

            end

            % If current element is 0 increment 0 counter
            if (leastSq(index,1)<=0)
                zero_counter = zero_counter+1;
            end
        end



        mean_cent = (sum_cent)/(cent_count);
        mean_side = (sum-sum_cent)/(gridCollumns-cent_count-zero_counter);
        mean = sum /(gridCollumns-zero_counter);
        
        for jj = 1:gridCollumns
            index= (ii-1)*gridCollumns+jj;
            factor = abs(leastSq(index,1)-mean)/mean;
            
            % If current value significantly deviates from the mean
            if factor > 0.15
                
                % If current value is in the centre
                if (abs(gridCollumns/2 - jj)<gridCollumns/4)
                    
                    % If mean of the central part is very different from
                    % the normal mean
                    if (abs(mean_cent -  mean)/mean>0.075)
                        leastSq(index,1) = mean - (mean-mean_side)/2;
                    else
                        leastSq(index,1) = mean_cent;
                    end
                    
                % If current value is on the side of the grid
                else
                    % If mean of the central part is very different from
                    % the normal mean
                    if (abs(mean_side -  mean)/mean>0.05)
                        leastSq(index,1) = mean - (mean-mean_cent)/2;
     
                    else
                        leastSq(index,1) = mean_side;
                    end
                end
            end
        end
        means(ii,1)  = mean;
        means (ii,2)= leastSq((ii-1)*gridCollumns+1,2);
        sum_d_xx = leastSq((ii-1)*gridCollumns+1,2)^2;
        sum_n_xy =  mean*leastSq((ii-1)*gridCollumns+1,2);
        sum_means = sum_means+mean;
        sum_y  = leastSq((ii-1)*gridCollumns+1,2)+sum_y;
    end
    
    sum_means = sum_means/gridRows;
    sum_y = sum_y/gridRows;
    bLS = (sum_n_xy - gridRows*sum_y*sum_means)/(sum_d_xx-gridRows*sum_y*sum_y);
    aLS = sum_means-bLS*sum_y;

    % Assuming that the disparity is linearly decreasing with an object
    % being further away from the camera, calibrate values of every row
    % which deviate significantly from the prediction
    for ii = 1:gridRows
        ind = (means(ii,1)-(aLS+bLS*means(ii,2)))/means(ii,1);
        if (ind>0.035) 
            for jj = 1:gridCollumns
                index= (ii-1)*gridCollumns+jj;
                leastSq (index,1)= leastSq(index,1)*(1-ind);
            end
        end
    end
end