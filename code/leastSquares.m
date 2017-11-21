function [coefs,residual] = leastSquares (fittingData,targetData)
% Function computing least squares estimate of the road surface, the
% equation is z = a+b*y+c*x+d*x*y+e*y^2+f*x^2, error is computed with 
% respect to targetData

% The arguments are:
% fittingData - used for the surface fitting
% targetData - we compute the error for this data

% Returns:

% coeffs - coefficients of the least squares fit
% residual - computed with respect to targetData

% Author: Aliaksei Mikhailiuk


    % copy the target values
    z=fittingData(:,1);
    
    % set target value to 1 (need to estimate it)
    fittingData(:,1) = 1;
    fittingData(:,4) = fittingData(:,2).*fittingData(:,3); %xy
    fittingData(:,5) = fittingData(:,2).*fittingData(:,2); %y^2
    fittingData(:,6) = fittingData(:,3).*fittingData(:,3); %x^2
    
    % Transpose of the data
    datatr =  transpose (fittingData);
    
    % Find the coefficients
    coefs = (inv (datatr*fittingData))*datatr*z;


    [tt,~] = size(targetData);
    acc = 0;
    
    % Find the residual
    for i = 1:tt
        vx = targetData(i,3);
        vy = targetData(i,2);
        check1 = coefs(1)+vy*coefs(2)+vx*coefs(3)+vx*vy*coefs(4)+vy^2*coefs(5)+vx^2*coefs(6);
        check =targetData(i,1);
        acc = acc+ (check - check1)^2;
    end
    residual = acc/tt;
    clear data;
end