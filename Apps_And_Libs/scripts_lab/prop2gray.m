function [ im_cube] = prop2gray( image,im_cube,Centroides )
    %PROP2GRAY Summary of this function goes here
    %   Detailed explanation goes here
    
    
    for i=1:size(image,3)
         
        im_cube.images(:,:,i) = image(:,:,i);

        novaImg = zeros(32);
        for lin =1:32
            for col = 1:32
                D=[];
                for k=1:255
         
                    D(:,k) = ((image(lin,col,i)- Centroides(k,:)).^2).^0.5;
                end
                [~, novopixel] = min(D,[],2);
                novaImg(lin,col) = novopixel;
            end
            
        end
       
        im_cube.gray_images(:,:,i) = novaImg;
        %figure; imagesc(im_cube.gray_images(:,:,i));
    end
end

