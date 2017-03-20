function [ image_prop ] = gray2prop( image_gray, min, max, noise )
%GRAY2PROP Summary of this function goes here
%   Detailed explanation goes here
% 
% max = image_gray.max;
% min = image_gray.min;
% noise = image_gray.noise;

im = image_gray + noise;
im = ((im + min)/256)*max;
image_prop = im;
end

