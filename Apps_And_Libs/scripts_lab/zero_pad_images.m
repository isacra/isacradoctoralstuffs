function[x_low, x_truth] = zero_pad_images(x, y)
    
    %%% Set to zero the pixels that corresponds to zero in each
    %%% cube%%%%%%%%%%%%

    [l,c,num_images] = size(x);
    for i=1:num_images
       im1 = x(:,:,i);
       im2 = y(:,:,i);
       
       logicalIm1 = im1==0;
       logicalIm2 = im2==0;
       logicalIm1 = 1-logicalIm1;
       logicalIm2 = 1-logicalIm2;
       
       image1 = im1.*logicalIm2;
       image2 = im2.*logicalIm1;
       
       if any(image1(:)>0)&& any(image2(:)>0)
            x_low(:,:,i) = image1;
            x_truth(:,:,i) = image2;
       else
          msg = 'image tudo 0'; 
       end
    end

end