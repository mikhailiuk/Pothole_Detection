function [aLS,residual] = leastSquares (data,fullData)

    z=data(:,1);
    data(:,1) = 1;
    data(:,4) = data(:,2).*data(:,3); %xy
    data(:,5) = data(:,2).*data(:,2); %y^2
    data(:,6) = data(:,3).*data(:,3); %x^2

    datatr =  transpose (data);
    aLS = (inv (datatr*data))*datatr*z;


    [tt,~] = size(fullData);
    acc = 0;
    for i = 1:tt
        vx = fullData(i,3);
        vy = fullData(i,2);
        check1 = aLS(1)+vy*aLS(2)+vx*aLS(3)+vx*vy*aLS(4)+vy^2*aLS(5)+vx^2*aLS(6);
        check =fullData(i,1);
        acc = acc+ (check - check1)^2;
    end
    residual = acc/tt;
    clear data;
end