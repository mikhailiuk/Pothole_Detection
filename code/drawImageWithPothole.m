function [] = drawImageWithPothole(image,clusters,potholesLarge,numberOfLargePotholes,count,clusterCount)

[m, n, ~]=size(image);
rgb=zeros(m,n,3); 
rgb(:,:,1)=image;
rgb(:,:,2)=rgb(:,:,1);
rgb(:,:,3)=rgb(:,:,1);
image=rgb/255; 


if(numberOfLargePotholes>1)
    [sizer,~]=size(potholesLarge);
    for i = 1:count
      for k = 1:sizer
        if (potholesLarge(k,4) == i)
          image(potholesLarge(k,2),potholesLarge(k,3),1)=255;
        end
      end
    end

    for k = 1:clusterCount
       for i = clusters(k,1):clusters(k,3)
         image(i,clusters(k,2),3)=255;
         image(i,clusters(k,4),3)=255;
       end
       for i = clusters(k,2):clusters(k,4)
         image(clusters(k,1),i,3)=255;
         image(clusters(k,3),i,3)=255;
       end
    end 
end

figure();
imshow(image);
title ('Color');


end