function [ image_prop ] = gray2prop( image_gray,image, Centroides)

   
    newima = zeros(32);
    
    figure; imagesc(image)
    figure; imagesc(image_gray)
    
    for k = 1:32
       
       for l = 1:32

           newima(k,l) = Centroides(image_gray(k,l));
       end
      
    end
    
    figure; imagesc(newima)
    
end

