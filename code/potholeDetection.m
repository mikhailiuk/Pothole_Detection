function [] = potholeDetection(params)
% The main function of the algorithm calling the following steps to
% execute:

% 1) Read images
% 2) Find the region of interest
% 3) Select points for a number (specified in the params argument) of grids
% to use when building the model of the road
% 3) Copy it to the format suitable for least squares algorithm.
% 4) Use selection of points to find the model of the road surface
% 5) Identify points which can potentially be potholes
% 6) Filter out outliers
% 7) Cluster points belonging to potholes
% 8) Put a box around the pothole
% 9) Display the images

% Params file includes:

% Paths to images with pothole data: image of the road, its disparity map
% params.nameRoadImage = '...';
% params.nameDisparityImage ='...';

% The shape of the region of interest is trapezium with a longer side on the bottom
% Top row in the region of intereset
% params.topRow
% Top collumn in the region of interest in the region of interest
% params.topColum
 
% Last column in the region of interest
% params.bottomColum;
% 
% Number of points to skip (do not use all the points when estimating the 
% model of the road), good choice is 5 (every 5th point is used)
% params.skipPoints
% 
% Number of random grids (1-100), good choice is 10-20
% params.numberOfGrids
% 
% Number of columns in a grid (vertical) (From 10-20)
% params.gridCollumns
% 
% Number of rows in a grid (horisontal) (From 10-20)
% params.gridRows


% Author: Aliaksei Mikhailiuk

    % Read the images from the files
    [image,dMap] = readImages(params.nameRoadImage,params.nameDisparityImage);

    [dMapRow, dMapColum]=size(dMap);

    % Allocate memory for the disparity map
    ROIdMap=zeros(dMapRow, dMapColum);

    % The shape of the region of interest is trapezium with a longer side on the bottom
    % Top row in the region of intereset
    topRow=params.topRow;
    % Top collumn in the region of interest in the region of interest
    topColum=params.topColum;
    %Last row is the same as the last row in the image
    bottomRow=dMapRow;
    
    %Save new variables into params
    params.bottomRow= bottomRow;
    params.dMapColum=dMapColum;
    params.dMapRow =dMapRow;
    
    % Last column in the region of interest
    bottomColum=params.bottomColum;

    % Number of points to skip
    skipPoints = params.skipPoints;

    % Number of random grids
    numberOfGrids = params.numberOfGrids;

    % Number of columns in a grid (vertical)
    gridCollumns  = params.gridCollumns;

    % Number of rows in a grid (horisontal)
    gridRows = params.gridRows; 

    % By how much the width of the next row changes, relative to the previous row
    stepInc=abs((topColum-bottomColum)/(bottomRow-topRow));

    
    step=0;
    % Create a region of interest (ROI)
    for ii=topRow:bottomRow
        % The length of every row in the ROI is increasing from top to bottom
        currentRow=round(topColum-stepInc*step):round(dMapColum-topColum+stepInc*step);
        ROIdMap(ii,currentRow)=dMap(ii,currentRow);
        step=step+1;
    end
    
    %Create random grids of points covering ROI
    randomGrids=createRandomGrids(params,dMap);
    
    realPoints = zeros(nnz(ROIdMap),3);
    % get non zero elements from disparity map and put them into the least
    % squares format, i.e. 1st col: value, 2nd col: vertical pos, 3rd col:
    % horizontal position.
    ff=0;
    [m,n]=size(ROIdMap);
    % Go through all pixels in the ROIdMap and put them in the format
    % required by least squares 
    for jj=1:m
        for ii = 1:n
            % If pixel is greater than 0
            if (ROIdMap(jj,ii)>0)
                % Increment counter and save the pixel value and its
                % coordinates
                ff=ff+1;
                realPoints(ff,1)=ROIdMap(jj,ii);
                realPoints(ff,2)=jj;
                realPoints(ff,3)=ii;
            end
        end
    end

    % Fit models into numberOfGrids grids, and choose the best
    for ff = 1:numberOfGrids 

        % Assign old residual infinity in the first iteration
        residualOld = Inf;

        % Get current grid from the cell array of grids 
        leastSq = randomGrids{ff,1};

        % Remove outliers from the data
        leastSq = removeOutliersFromGrid(leastSq, gridRows, gridCollumns);

        % Least square regression with the given points and reference (all) 
        % points
        [coefficientsLeastSquares,residualNew] = leastSquares (leastSq,realPoints);

        % If new residual is less than the old residual, save current state
        if (residualOld >residualNew)
            coefficientsLeastSquaresOld = coefficientsLeastSquares;
            residualOld = residualNew;
        end
    end

    % Find points below the modeled road surface
    [potholes,potholePoints] = findPointsBelowEstimatedSurface(realPoints,coefficientsLeastSquaresOld,skipPoints);

    % If there are points belonging to a pothole
    if(potholePoints>1)

        % Remove outliers from the pothole i.e. points too far away from the
        % esimated surface and points too close to the estimated surface,
        % points with no neighbouts around
        potholesLarge=removeOutliersPotholes(potholes,skipPoints);

        [numberOfLargePotholes,~] = size(potholesLarge);

        % if there are large potholes
        if numberOfLargePotholes > 1
            % Cluster points close to each other and mark them as the same
            % pothole
            [potholesLarge,numberOfClusters] = clusterLargePotholes(potholesLarge,skipPoints);

            % Put boxes around current pothole estimates
            [boxes, boxCount] = boxPotholes(potholesLarge,numberOfClusters);

            
            % Draw the image with a pothole
            drawImageWithPothole(image,boxes,potholesLarge,numberOfClusters,boxCount);

        end

    end


end
