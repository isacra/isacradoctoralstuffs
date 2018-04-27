function [im_out, method, t2, snr_recon] = run_method(method, im_blurred, im_in, small_kernel, sigma, pad_size, SNR_pad_size)

warning('OFF', 'Images:initSize:adjustingMag');
%==========================================================================
%                      O P T I O N S
%==========================================================================
%  Valid methods: 
%  'Lucy_Richarson', 'zhou', 'Levin_Gaussian', 'Levin_Sparse L0.8', 'TV_L2', 'TV_L1', 'Shan', 'Krishnan', 'Our'

%======================================================================
if strcmp(method, 'Our') 
    tic
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);   
    big_kernel  = getBigKernel(R, C, small_kernel);
    wev   = [0.001, 20, 0.033, 0.05];   

    im_out_padded = our_method_bifilter(im_blurred_padded, big_kernel, wev);
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc; 
    snr_recon  = our_snr(im_out, SNR_pad_size, im_in);   
end;
%--------------------------------------------------------------------------
% Lucy-Richardson MATLAB implementation
if strcmp(method,'Lucy_Richarson')
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    im_out_padded = deconvlucy(im_blurred_padded, small_kernel, 20);
    t2 = toc;
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;
%-----------------------------------------------------------------------
% Image and Depth from a Conventional Camera with a Coded Aperture
% Anat Levin,  Rob Fergus,  Fredo Durand,  Bill Freeman
% script deconvL2_frequency downloded from:
% http://groups.csail.mit.edu/graphics/CodedAperture/DeconvolutionCode.html
if strcmp(method, 'Levin_Gaussian')
    we = 0.004;
    small_kernel_rot = rot90(small_kernel,2);
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);  
    for ch = 1:CH
        im_out_padded(:,:,ch) = deconvL2_frequency(im_blurred_padded(:,:,ch), small_kernel_rot, we);
    end;
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc;
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;
%--------------------------------------------------------------------------
% Wiener Deconvolution Using 1/f Law
% Changyin Zhou @ Columbia U, 2009'
% zhou calls code downloaded from
% http://www1.cs.columbia.edu/~changyin/SharedCode/ICCP2009/zDemo.html (27/09/2012)
if strcmp(method, 'zhou')
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);   
    big_kernel  = getBigKernel(R, C, small_kernel);
    im_out_padded = zhou(im_blurred_padded, big_kernel, sigma);
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc;
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;
%--------------------------------------------------------------------------
% High-quality Motion Deblurring from a Single Image
% Qi Shan, Jiaya Jia, Aseem Agarwala
% program robust_deconv.exe downloded from:
% http://www.cse.cuhk.edu.hk/~leojia/projects/motion_deblurring/index.html

if strcmp(method, 'Shan')
    imwrite(small_kernel , './images/out/small_kernel.png');
    
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);  
    [R, C, CH] = size(im_blurred_padded);      
    imwrite(im_blurred_padded, './images/out/im_blurred.png');
    shan_command = ' robust_deconv.exe ./images/out/im_blurred.png ./images/out/small_kernel.png ./images/temp/im_out_temp_Shan.png 0 0.1 10';
    tic;
    if isunix  % use wine in Linux (for execution time comparison use Windows)
        [status, result] = unix(strcat('wine', shan_command));
    else
        [status, result] = dos(shan_command);
    end;
    t2 = toc;
    im_out_padded = im2double(imread('./images/temp/im_out_temp_Shan.png'));
    if CH == 1  
        im_out_padded = im_out_padded(:,:,1); 
    end;    
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);

    snr_recon = our_snr(im_out, SNR_pad_size, im_in);

    %output image is shifted by one row and one column?
    im_out_temp = im_out;
    im_out_temp(1:end-1,1:end-1,:) = im_out(2:end,2:end,:); 
    snr_recon_temp = our_snr(im_out_temp, SNR_pad_size, im_in);   
    if snr_recon_temp > snr_recon
        snr_recon = snr_recon_temp;
        im_out    = im_out_temp;
    end;    
    
end;
%--------------------------------------------------------------------------
% fast_deconv solves the deconvolution problem in the paper (see Equation (1))
% D. Krishnan, R. Fergus: "Fast Image Deconvolution using Hyper-Laplacian
% Priors", Proceedings of NIPS 2009.
%
% This paper and the code are related to the work and code of Wang
% et. al.:
%
% Y. Wang, J. Yang, W. Yin and Y. Zhang, "A New Alternating Minimization
% Algorithm for Total Variation Image Reconstruction", SIAM Journal on
% Imaging Sciences, 1(3): 248:272, 2008.
% and their FTVd code.

if strcmp(method, 'Krishnan')
    if (exist('pointOp') ~= 3)
        fprintf('WARNING: Will use slower interp1 for LUT interpolations. For speed please see comments at the top of fast_deconv.m\n');
    end;
    lambda = 2e3; alpha = 2/3;
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);  
    for ch = 1:CH
        % im_out(:,:,ch) = fast_deconv(im_blurred(:,:,ch), small_kernel, lambda, alpha); % original (verbose)
        im_out_padded(:,:,ch) = our_fast_deconv(im_blurred_padded(:,:,ch), small_kernel, lambda, alpha); % some sprintf's commented
    end;
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc;
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;

%--------------------------------------------------------------------------
% out = FTVd_v4(H,Bn,mu,str,opts)
%
% FTVd_v4 solves TV models (TV/L2, TV/L1 and their color variants)
% by Alternating Direction Method (ADM).
%
% Copyright (c), May, 2009
%       Junfeng Yang, Dept. Math., Nanjing Univiversity
%       Wotao Yin,    Dept. CAAM, Rice University
%       Yin Zhang,    Dept. CAAM, Rice University

if strcmp(method, 'TV_L2')
    mu = 1750;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [im_in_padded, mask_pad] = imPad(im_in, pad_size);    
    snr(im_blurred_padded(:,:,1), im_in_padded(:,:,1));
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);  
    big_kernel  = getBigKernel(R, C, small_kernel);
    for ch = 1:CH
        out = our_FTVd_v4(fftshift(big_kernel), im_blurred_padded(:,:,ch), mu, 'L2'); % some disp's commented
        im_out_padded(:,:,ch) = out.sol;
    end;
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc;
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;

if strcmp(method, 'TV_L1')
    mu = 15;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [im_in_padded, mask_pad] = imPad(im_in, pad_size);    
    snr(im_blurred_padded(:,:,1), im_in_padded(:,:,1));
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);  
    big_kernel  = getBigKernel(R, C, small_kernel);
    for ch = 1:CH
        out = our_FTVd_v4(fftshift(big_kernel), im_blurred_padded(:,:,ch), mu, 'L1'); % some disp's commented
        im_out_padded(:,:,ch) = out.sol;
    end;
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc;
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;

%--------------------------------------------------------------------------
% Image and Depth from a Conventional Camera with a Coded Aperture
% Anat Levin,  Rob Fergus,  Fredo Durand,  Bill Freeman
% script deconvSps downloded from:
% http://groups.csail.mit.edu/graphics/CodedAperture/DeconvolutionCode.html
if strcmp(method, 'Levin_Sparse L0.8')
    
    small_kernel_rot = rot90(small_kernel,2);
    we = 0.004;  max_it = 200;
    tic;
    [im_blurred_padded, mask_pad] = imPad(im_blurred, pad_size);    
    [R, C, CH] = size(im_blurred_padded);  
    for ch = 1:CH
        im_out_padded(:,:,ch) = deconvSps(im_blurred_padded(:,:,ch), small_kernel_rot, we, max_it);
    end;
    im_out = imUnpad(im_out_padded, mask_pad, pad_size);
    t2 = toc;
    snr_recon = our_snr(im_out, SNR_pad_size, im_in);
end;
