function table_03()
clc;
clear all;
close all;
path (path, genpath(pwd));

%==========================================================================
%                      O P T I O N S
%==========================================================================

% methods to run: 
  methods = {'Lucy_Richarson','zhou','Levin_Gaussian','none'             ,'TV_L2', 'TV_L1', 'Shan','Krishnan','Our'};

% Method Levin_Sparse L0.8 is not run by default
% To enable it comment out the following line
% methods = {'Lucy_Richarson','zhou','Levin_Gaussian','Levin_Sparse L0.8','TV_L2', 'TV_L1', 'Shan','Krishnan','Our'};

sigma   = 0.01; % noise standard deviation

% load kernel => kernel1 from Krishnan scaled 
% load kernels.mat; 
load  Krishnan_kernel1.mat;

filt = kernel1;
small_kernel = im2double(filt);   

small_kernel1 = imresize(small_kernel, [13, 13]);
small_kernel2 = imresize(small_kernel, [15, 15]);
small_kernel3 = imresize(small_kernel, [17, 17]);
small_kernel4 = imresize(small_kernel, [19, 19]);
small_kernel5 = imresize(small_kernel, [21, 21]);
small_kernel6 = imresize(small_kernel, [23, 23]);
small_kernel7 = imresize(small_kernel, [27, 27]);
small_kernel8 = imresize(small_kernel, [41, 41]);

small_kernel1 = small_kernel1 ./ sum(small_kernel1(:));
small_kernel2 = small_kernel2 ./ sum(small_kernel2(:));
small_kernel3 = small_kernel3 ./ sum(small_kernel3(:));
small_kernel4 = small_kernel4 ./ sum(small_kernel4(:));
small_kernel5 = small_kernel5 ./ sum(small_kernel5(:));
small_kernel6 = small_kernel6 ./ sum(small_kernel6(:));
small_kernel7 = small_kernel7 ./ sum(small_kernel7(:));
small_kernel8 = small_kernel8 ./ sum(small_kernel8(:));

small_kernels  = {small_kernel1, small_kernel2, small_kernel3, small_kernel4, ...
    small_kernel5, small_kernel6, small_kernel7, small_kernel8};

rows = size(small_kernels, 2); 

% load image 3 from kodak set
im_in_orig  = im2double(imread('./images/in/kodim03.png'));  

SNR      = {0, 0, 0, 0, 0, 0, 0, 0, 0};
t        = {0, 0, 0, 0, 0, 0, 0, 0, 0};
avg_gain = {0, 0, 0, 0, 0, 0, 0, 0, 0};
avg_t    = {0, 0, 0, 0, 0, 0, 0, 0, 0};


disp(sprintf('Table 03: Output will be writen to file ./tables/table_03.txt\n'));
disp(sprintf('Levin_Sparse L0.8 method is not run by default'));
disp(sprintf('Read script comments to enable it\n'));

fid = fopen('./tables/table_03.txt','w');
fprintf(fid, '\nPart of Supplementary Materials\n');
fprintf(fid, 'CGI 2014 - Submission 11\n');
fprintf(fid, 'High-Quality Fast non-Blind Deconvolution Using Sparse Adaptive Priors\n');
fprintf(fid, '\nTable 03:\n\n');

fprintf(fid, '-------------------------------------------------------------------------------------------------------\n');
fprintf(fid, '   Image    | Blurry |  Lucy  |  Zhou  |  l_2   |  IRLS  |   TV   |  l_1   |  Shan  |Krishnan|   Our  |\n');
fprintf(fid, '-------------------------------------------------------------------------------------------------------\n');

[R,C,CH] = size(im_in_orig);

for kernel_num  = 1:rows
        
    clear('im_blurred');
    clear('im_out_padded');
    clear('im_out');
         
    small_kernel = small_kernels{kernel_num};
    [R,C,CH] = size(small_kernel);
    disp('------------------------------------');
    disp(sprintf('\nkernel size: %d x %d\n', R, C));
   
    KR  = floor((size(small_kernel, 1) - 1)/2); KC = floor((size(small_kernel, 2) - 1)/2); 
    SNR_pad_size = max(KR,KC); pad_size = 2 * SNR_pad_size;
    
    [im_blurred, im_in, noise] = blurrAndNoiseLinear(im_in_orig, small_kernel, sigma);
    snr_blur  = our_snr(im_blurred, SNR_pad_size, im_in);

    rows1 = size(methods,2);    
    for method_num = 1:rows1
        method = methods{method_num};

        disp(sprintf('Running method: %s. Please wait', method));
        if (strcmp(method,'Levin_Sparse L0.8')) 
            disp('. It may take a few minutes, please be patient.'); 
        end
        if (strcmp(method,'none')) 
            im_out = zeros(size(im_in));
            time = 0;
            snr_recon = 0;
        else
            [im_out, method, time, snr_recon] = run_method(method, im_blurred, im_in, small_kernel, sigma, pad_size, SNR_pad_size);
        end;
        show(kernel_num, im_out, method, time, snr_recon);
        SNR{method_num} = snr_recon;
        t  {method_num} = time;
        avg_gain{method_num} = avg_gain{method_num} + snr_recon - snr_blur;
        avg_t{method_num}    = avg_t{method_num}    + time;     
    end;

    fprintf(fid,'  %2d x %2d   |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |\n', ...
         R, C, snr_blur, SNR{1}, SNR{2}, SNR{3}, SNR{4}, SNR{5}, SNR{6}, SNR{7}, SNR{8}, SNR{9} );

end;

for method_num = 1:rows1
   avg_gain{method_num} = (avg_gain{method_num} / rows);
   avg_t{method_num}    = avg_t{method_num}    /rows;  
end;

fprintf(fid, '-------------------------------------------------------------------------------------------------------\n');
fprintf(fid,' Av. PSNR gain       | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f |\n', ...
          avg_gain{1}, avg_gain{2}, avg_gain{3}, avg_gain{4}, avg_gain{5}, avg_gain{6}, avg_gain{7}, avg_gain{8}, avg_gain{9} );
fprintf(fid, '-------------------------------------------------------------------------------------------------------\n');
fprintf(fid,' Av. Time            | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f |\n', ...
          avg_t{1}, avg_t{2}, avg_t{3}, avg_t{4}, avg_t{5}, avg_t{6}, avg_t{7}, avg_t{8}, avg_t{9} );
fprintf(fid, '-------------------------------------------------------------------------------------------------------\n');

fclose(fid);

function show(kernel_num, im_out, method, time, snr_recon)
    
disp(sprintf('%02d: %05.2f sec, PSNR:%6.3f (%s)', kernel_num, time, snr_recon, method));

