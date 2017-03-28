function [ image_prop ] = gray2prop( image_gray,im_cube)
%GRAY2PROP Summary of this function goes here
%   Detailed explanation goes here
% 
% max = image_gray.max;
% min = image_gray.min;
% noise = image_gray.noise;
    [~,~,num_imgs] = size(im_cube);
    for k = 1 : num_imgs
        i = image_gray; %+ im_cube.noise(:,:,k); %%Esta linha de código so
        %serve se as imagens forem as mesmas.  ou se eu souber a
        %correspondencia das imagens
        i = (i + im_cube.max(k) + 256*im_cube.min(k))/256;
        image_prop(:,:,k) = i;
    end

end

