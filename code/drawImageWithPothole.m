function [] = drawImageWithPothole(image,boxes,potholesLarge,numberOfClusters,boxCount)
% Function to draw the images of the road with potholes in color

% The arguments are: 
% image - original image of the road
% clusters - array with clusters of points belonging to potholes marked
% potholesLarge - points belonging to the pothole
% numberOfClusters - number of clusters
% boxCount - number of boxes

% Author: Aliaksei Mikhailiuk

    [m, n, ~]=size(image);
    rgb=zeros(m,n,3); 
    rgb(:,:,1)=image;
    rgb(:,:,2)=rgb(:,:,1);
    rgb(:,:,3)=rgb(:,:,1);
    image=rgb/255; 
    
    % Go through all the clusters of points and plot them in red
    [sizer,~]=size(potholesLarge);
    for i = 1:numberOfClusters
      for k = 1:sizer
        if (potholesLarge(k,4) == i)
          image(potholesLarge(k,2),potholesLarge(k,3),1)=255;
        end
      end
    end

    % Go through all the boxes and plot them blue
    for k = 1:boxCount
       for i = boxes(k,1):boxes(k,3)
         image(i,boxes(k,2),3)=255;
         image(i,boxes(k,4),3)=255;
       end
       for i = boxes(k,2):boxes(k,4)
         image(boxes(k,1),i,3)=255;
         image(boxes(k,3),i,3)=255;
       end
    end 


    figure();
    imshow(image);
    title ('Color');


end