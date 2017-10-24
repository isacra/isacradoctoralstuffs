function [ mrse ] = MRSE( low_image, high_image )
%MRSE Summary of this function goes here
%   Detailed explanation goes here
    mrse =  round(sqrt(sum(sum(power((low_image - high_image),2)))/1024),5);

end

