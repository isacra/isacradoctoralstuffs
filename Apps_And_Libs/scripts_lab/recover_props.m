function [ output_args ] = recover_props( immatches,immatches2, images,lr_cube_class, hr_cube_class)
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
        figure;
        
        corr_idx = immatches{i}.immatch;
        
        prop(:,:,i) = gray2prop(images(:,:,i), hr_cube_class,false,corr_idx);
        orig_prop = gray2prop(hr_cube_class.images(:,:,corr_idx), hr_cube_class,true,corr_idx);
        lr_prop = gray2prop(lr_cube_class.images(:,:,corr_idx), lr_cube_class,true,corr_idx);
        
        set(gcf, 'color','w')
        
        subplot(3,1,1)
        imagesc(prop(:,:,i));
        text = strcat('Impedância gerada - Similaridade com (IE).: ', mat2str(round(abs(immatches{i}.fft_param),4)));
        title(text);
        
        %subplot(3,2,2)
        %hist(prop(:,:,i));
        
        subplot(3,1,2)
        imagesc(orig_prop);
        text = strcat('Impedância Esparsa (IE)');
        title(text);
        %subplot(3,2,4)
        %hist(orig_prop);
        
        subplot(3,1,3)
        imagesc(lr_prop);
        text = strcat('Impedância MAP - Similaridade com (IE).: ', mat2str(round(abs(immatches2{i}.fft_param),4)));
        title(text);
        %subplot(3,2,6)
        %hist(lr_prop)
        
        
    end
    
end