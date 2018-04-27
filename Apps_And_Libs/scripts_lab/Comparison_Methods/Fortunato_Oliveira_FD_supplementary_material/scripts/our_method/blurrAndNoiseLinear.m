function [im_blurred, im_in_valid, noise] = blurrAndNoiseLinear(im_in, small_kernel, sigma)

[R, C, CH] = size(im_in);

    for ch = 1:CH
        im_blurred(:,:,ch) = conv2(im_in(:,:,ch), small_kernel, 'valid');
    end;
    
    [RB, CB, CH] = size(im_blurred);
    
    noise = randn(RB, CB, CH) * sigma;
    im_blurred = im_blurred + noise; 
    im_blurred = double(uint8(im_blurred .* 255))./255;
    
    RB2 = floor((R-RB)/2); CB2 = floor((C-CB)/2);
    im_in_valid = im_in(RB2+1:RB2+RB, CB2+1:CB2+CB, :);
 