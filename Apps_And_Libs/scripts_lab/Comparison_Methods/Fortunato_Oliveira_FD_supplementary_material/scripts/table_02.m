function table_02()
clc;
clear all;
close all;
path (path, genpath(pwd));

%==========================================================================
%                      O P T I O N S
%==========================================================================

% methods to run: 
  methods = {'none', 'Shan','Krishnan', 'Our'};

% Method Levin_Sparse L0.8 is not run by default
% To enable it comment out the following line
% methods = {'Levin_Sparse L0.8', 'Shan','Krishnan', 'Our'};

sigma   = 0.01; % noise standard deviation

% load kernel = Krishnan 13 x 13;
%load kernels.mat; 
load  Krishnan_kernel1.mat;

filt = kernel1;
small_kernel = im2double(filt);   
small_kernel = imresize(small_kernel, [13,13]);
small_kernel = small_kernel ./ sum(small_kernel(:));

% load image
im_d = im2double(imread('./images/in/im_table_02.jpg'));

im1_d = imresize(im_d, [256, 256]);
im2_d = imresize(im_d, [512, 512]);
im3_d = imresize(im_d, [1024, 1024]);
im4_d = imresize(im_d, [2048, 2048]);
im5_d = imresize(im_d, [3072, 3072]);
ims = {im1_d, im2_d, im3_d, im4_d, im5_d};
rows = size(ims,2); 

disp(sprintf('Table 02: Output will be writen to file ./tables/table_02.txt\n\n'));

disp(sprintf('Table 01: Output will be writen to file ./tables/table_01.txt\n'));
disp(sprintf('Levin_Sparse L0.8 method is not run by default'));
disp(sprintf('Read script comments to enable it\n'));

fid = fopen('./tables/table_02.txt','w');    

fprintf(fid, '\nPart of Supplementary Materials\n');
fprintf(fid, 'CGI 2014 - Submission 11\n');
fprintf(fid, 'High-Quality Fast non-Blind Deconvolution Using Sparse Adaptive Priors\n');
fprintf(fid, '\nTable 02:\n\n');

fprintf(fid, '-------------------------------------------------\n');
fprintf(fid, ' Image  size |  IRLS  |  Shan  |Krishnan|   Our  |\n');
fprintf(fid, '-------------------------------------------------\n');

t        = {0, 0, 0, 0};

for image_num  = 1:rows

    im_in_orig = ims{image_num};
    [R,C,CH] = size(im_in_orig);
        
    clear('im_blurred');
    clear('im_out_padded');
    clear('im_out');
        
    [R,C,CH] = size(im_in_orig);
    disp(sprintf('\nImage %d: %d x %d x %d:', image_num, R, C, CH));
 
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
        if strcmp(method,'Shan') && image_num  >= (rows - 1)
          time = -1; %Shan code reports an error for big images
        else
            if (strcmp(method,'none')) 
                im_out = zeros(size(im_in));
                time = 0;
                snr_recon = 0;
            else
                [im_out, method, time, snr_recon] = run_method(method, im_blurred, im_in, small_kernel, sigma, pad_size, SNR_pad_size);
            end
            show(im_out, method, time, snr_recon);
        end;
        t{method_num} = time;
    end;
    fprintf(fid,' %4d x %4d |%8.2f|%8.2f|%8.2f|%8.2f|\n', R, C, t{1}, t{2}, t{3}, t{4});

end;
fprintf(fid, '-------------------------------------------------\n');
fclose(fid);

function show(im_out, method, time, snr_recon)

disp(sprintf('%05.2f sec, (%s)', time, method));

