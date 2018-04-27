function figure_natural()

path ('our_method', path);
clc;
clear all;
close all;

% ==========================================================================
im_blurred   = x_test_corte_x;%   im2double(imread('./images/in/test4.bmp'));
im_blurred = im_blurred + 0.1;
im_kernel = im2double(imread('./images/in/kernel4.bmp'));
small_kernel = im_kernel(:,:,1);
wev   = [0.001, 20, 0.033, 0.05]; 
% ==========================================================================
KR  = floor((size(small_kernel, 1) - 1)/2); 
KC = floor((size(small_kernel, 2) - 1)/2); 
SNR_pad_size = max(KR,KC); 
pad_size = 2 * SNR_pad_size;

[R, C, CH] = size(im_blurred);
[im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
[R, C, CH] = size(im_blurred_padded);   
big_kernel  = getBigKernel(R, C, small_kernel);
%--------------------------------------------------------------------------
im_out_padded = our_method_bifilter(im_blurred_padded, big_kernel, wev);       
im_out = imUnpad(im_out_padded, mask_pad, pad_size);
%--------------------------------------------------------------------------
   
figure; 
subplot(1,3,1);imagesc(im_blurred );title('blurred'); 
subplot(1,3,2);imagesc(im_out);title('out'); 
subplot(1,3,3);imagesc(small_kernel); title('small kernel');drawnow;

% ==========================================================================
im_blurred   =  x_test_corte_x;%im2double(imread('./images/in/redTreeBlurImage.png'));
im_kernel = im2double(imread('./images/in/outKernelRT.png'));
small_kernel = im_kernel(:,:,1);
wev   = [0.0001, 20, 0.01, 0.01];
% ==========================================================================
KR  = floor((size(small_kernel, 1) - 1)/2); 
KC = floor((size(small_kernel, 2) - 1)/2); 
SNR_pad_size = max(KR,KC); 
pad_size = 2 * SNR_pad_size;

[R, C, CH] = size(im_blurred);
[im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
[R, C, CH] = size(im_blurred_padded);   
big_kernel  = getBigKernel(R, C, small_kernel);
%--------------------------------------------------------------------------
im_out_padded = our_method_bifilter(im_blurred_padded, big_kernel, wev);       
im_out = imUnpad(im_out_padded, mask_pad, pad_size);
%--------------------------------------------------------------------------
   
figure; 
subplot(1,3,1);imagesc(im_blurred );title('blurred'); 
subplot(1,3,2);imagesc(im_out);title('out'); 
subplot(1,3,3);imagesc(small_kernel); title('small kernel');drawnow;

