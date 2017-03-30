function [ image_prop ] = gray2prop( image_gray,im_cube, addNoise, idx)
%GRAY2PROP Summary of this function goes here
%   Detailed explanation goes here
% 
% max = image_gray.max;
% min = image_gray.min;
% noise = image_gray.noise;
    if (addNoise)
        i = image_gray + im_cube.noise(:,:,idx); %%Esta linha de código so
        %serve se as imagens forem as mesmas.  ou se eu souber a
        %correspondencia das imagens
    else
        i = image_gray;
    end

    i = (i + im_cube.max(idx) + 256*im_cube.min(idx))/256;
    image_prop = i;

end

