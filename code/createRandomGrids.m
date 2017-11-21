function [randomGrids]=createRandomGrids(params,dMap)

    % Number of random grids
    numberOfGrids = params.numberOfGrids;

    % Number of columns in a grid (vertical)
    gridCollumns  = params.gridCollumns;

    % Number of rows in a grid (horisontal)
    gridRows = params.gridRows;
   
    % The shape of the region of interest is trapezium with a longer side on the bottom
    % Top row in the region of intereset
    topRow=params.topRow;
    % Top collumn in the region of interest in the region of interest
    topColum=params.topColum;
    %Last row is the same as the last row in the image
    bottomRow=params.bottomRow;
    % Last column in the region of interest
    bottomColum=params.bottomColum;
    dMapColum=params.dMapColum;
    
    % heigth of a grid (region of interest)
    gridHeight = abs(topRow - bottomRow);
    
    % number of lines between the rows in the grid
    rowsBlockGrid = round(gridHeight/gridRows)-1;
    
    % By how much the width of the next row changes, relative to the previous row
    stepInc=abs((topColum-bottomColum)/(bottomRow-topRow));


    randomRowsNumbersAllGrids = cell(numberOfGrids,1);
    
    randomRowsNumbersOneGrid = zeros(gridRows,1);

    % Create an array of random numbers, used to select the rows in a grid
    for ii = 1:numberOfGrids
        for jj  = 1:gridRows
            randomRowsNumbersOneGrid(jj,1) = round(topRow + rowsBlockGrid*(jj-1) + rowsBlockGrid*rand);
        end
        randomRowsNumbersAllGrids{ii,1} = randomRowsNumbersOneGrid;
    end

    randomGrids = cell(numberOfGrids,1);
    randomGrid = zeros(gridRows*gridCollumns,3);
      
    % Create grids of points
    for ff = 1:numberOfGrids
        step=0;
        %Go through all rows in a grid
        for ii=1:gridRows
            
            % current row in the region of interest (the size changes as ROI
            % is a trapezium)
            currentRow=round(topColum-stepInc*step):round(dMapColum-topColum+stepInc*step);
            
            step=randomRowsNumbersAllGrids{ff,1}(ii,1)-topRow +1;
            
            % index of the current row in an image
            idx = randomRowsNumbersAllGrids{ff,1}(ii,1);
                
            % Copy spaced points from the image into a grid
            for currentCollumn=1:gridCollumns
                [~,currentRowSize] = size(currentRow);
                numberOfLinesBetweenGridRows = round(currentRowSize/gridCollumns);
                index = ((ii-1)*gridCollumns+currentCollumn);
                randomGrid(index,3) = currentRow(1,1)+round(numberOfLinesBetweenGridRows*currentCollumn);
                randomGrid(index,2) = idx;
                randomGrid(index,1)= dMap(idx,round(currentRow(1,1)+numberOfLinesBetweenGridRows*currentCollumn));
            end

        end
        randomGrids{ff,1} = randomGrid;
    end


end