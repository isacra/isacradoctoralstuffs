function [ output_args ] = recover_props( immatches, images, im_cube_class)
%SELECT_IMAGES Summary of this function goes here
%   This method recover from gray (0 - 255) images obtained from de CNN to
%   the property. It uses the correspondence between the CNN response and
%   the original image. The correspondence is based on the FFT spectrum
%   frequence analysis. The method gets the max and min of the
%   corresponding image and makes the grayscale image back to the
%   propertie image. Both, the original property and the new one are showed
%   side by side.
    [~ ,num_imgs] = size(immatches);
   
    
    for i = 1 : num_imgs
        corr_idx = immatches{i}.immatch;
        
        prop(:,:,i) = gray2prop(images(:,:,i), im_cube_class,false,corr_idx);
        orig_prop = gray2prop(im_cube_class.images(:,:,corr_idx), im_cube_class,true,corr_idx);
        
        figure;
        subplot(2,2,1)
        imagesc(prop(:,:,i));
        subplot(2,2,2)
        imagesc(orig_prop);
        subplot(2,2,3)
        hist(prop(:,:,i));
        subplot(2,2,4)
        hist(orig_prop)
    end
    
end