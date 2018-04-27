function table_01()
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

% load kernel = Krishnan 13 x 13;
% load kernels.mat; 
load  Krishnan_kernel1.mat;

filt = kernel1;
[RF,CF] = size(filt); 
small_kernel = im2double(filt);   
small_kernel = small_kernel ./ sum(small_kernel(:));

KR  = floor((size(small_kernel, 1) - 1)/2); 
KC = floor((size(small_kernel, 2) - 1)/2); 
SNR_pad_size = max(KR,KC); 
pad_size = 2 * SNR_pad_size;

% Load images of Kodak Lossless True Color Image Suite 
%
% To save space in zip file images 17 to 24 are missing 
% you can download them from http://r0k.us/graphics/kodak/
% Last access, Jan. 2014.
%
im1  = im2double(imread('./images/in/kodim01.png'));  
im2  = im2double(imread('./images/in/kodim02.png'));  
im3  = im2double(imread('./images/in/kodim03.png'));  
im4  = im2double(imread('./images/in/kodim04.png'));  
im5  = im2double(imread('./images/in/kodim05.png'));  
im6  = im2double(imread('./images/in/kodim06.png'));  
im7  = im2double(imread('./images/in/kodim07.png'));  
im8  = im2double(imread('./images/in/kodim08.png'));  
im9  = im2double(imread('./images/in/kodim09.png'));  
im10 = im2double(imread('./images/in/kodim10.png'));  
im11 = im2double(imread('./images/in/kodim11.png'));  
im12 = im2double(imread('./images/in/kodim12.png'));  
im13 = im2double(imread('./images/in/kodim13.png'));  
im14 = im2double(imread('./images/in/kodim14.png'));  
im15 = im2double(imread('./images/in/kodim15.png'));  
im16 = im2double(imread('./images/in/kodim16.png'));  
% im17 = im2double(imread('./images/in/kodim17.png'));  
% im18 = im2double(imread('./images/in/kodim18.png'));  
% im19 = im2double(imread('./images/in/kodim19.png'));  
% im20 = im2double(imread('./images/in/kodim20.png'));  
% im21 = im2double(imread('./images/in/kodim21.png'));  
% im22 = im2double(imread('./images/in/kodim22.png'));  
% im23 = im2double(imread('./images/in/kodim23.png'));  
% im24 = im2double(imread('./images/in/kodim24.png'));  

% ims = {im1, im2, im3, im4, im5, im6, im7, im8 ...
%        im9, im10, im11, im12, im13, im14, im15, im16 ...
%        im17, im18, im19, im20, im21, im22, im23, im24};
ims = {im1, im2, im3, im4, im5, im6, im7, im8 ...
        im9, im10, im11, im12, im13, im14, im15, im16};

rows = size(ims,2); 

disp(sprintf('Table 01: Output will be writen to file ./tables/table_01.txt\n'));
disp(sprintf('Levin_Sparse L0.8 method is not run by default'));
disp(sprintf('Read script comments to enable it\n'));

fid = fopen('./tables/table_01.txt','w');

fprintf(fid, '\nPart of Supplementary Materials\n');
fprintf(fid, 'CGI 2014 - Submission 11\n');
fprintf(fid, 'High-Quality Fast non-Blind Deconvolution Using Sparse Adaptive Priors\n');
fprintf(fid, '\nTable 01:\n\n');


fprintf(fid, '--------------------------------------------------------------------------------------------------\n');
fprintf(fid, ' Image | Blurry |  Lucy  |  Zhou  |  l_2   |  IRLS  |   TV   |  l_1   |  Shan  |Krishnan|   Our  |\n');
fprintf(fid, '--------------------------------------------------------------------------------------------------\n');

SNR      = {0, 0, 0, 0, 0, 0, 0, 0, 0};
t        = {0, 0, 0, 0, 0, 0, 0, 0, 0};
avg_gain = {0, 0, 0, 0, 0, 0, 0,1.0 0, 0};
avg_t    = {0, 0, 0, 0, 0, 0, 0, 0, 0};

for image_num  = 1:rows
    im_in_orig = ims{image_num};
   
    [im_blurred, im_in, noise] = blurrAndNoiseLinear(im_in_orig, small_kernel, sigma);
    
    snr_blur  = our_snr(im_blurred, SNR_pad_size, im_in);
    disp('------------------------------------');
    disp(sprintf('\nimage: %d blurred PSNR:%6.3f\n', image_num, snr_blur));

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
        show(image_num, im_out, method, time, snr_recon);
        SNR{method_num} = snr_recon;
        t  {method_num} = time;
        avg_gain{method_num} = avg_gain{method_num} + snr_recon - snr_blur;
        avg_t{method_num}    = avg_t{method_num}    + time;          
    end;
    
    fprintf(fid,'  %02d   |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |  %5.2f |\n', ...
        image_num, snr_blur, SNR{1}, SNR{2}, SNR{3}, SNR{4}, SNR{5}, SNR{6}, SNR{7}, SNR{8}, SNR{9} );

end;

for method_num = 1:rows1
   avg_gain{method_num} = (avg_gain{method_num} / rows);
   avg_t{method_num}    = avg_t{method_num}    /rows;  
end;

fprintf(fid, '--------------------------------------------------------------------------------------------------\n');
fprintf(fid,' Av. PSNR gain  | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f |\n', ...
          avg_gain{1}, avg_gain{2}, avg_gain{3}, avg_gain{4}, avg_gain{5}, avg_gain{6}, avg_gain{7}, avg_gain{8}, avg_gain{9} );
fprintf(fid, '--------------------------------------------------------------------------------------------------\n');
fprintf(fid,' Av. Time       | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f |\n', ...
          avg_t{1}, avg_t{2}, avg_t{3}, avg_t{4}, avg_t{5}, avg_t{6}, avg_t{7}, avg_t{8}, avg_t{9} );
fprintf(fid, '--------------------------------------------------------------------------------------------------\n');

fclose(fid);

function show(image_num, im_out, method, time, snr_recon)

if time > 0 || snr_recon > 0
    disp(sprintf('%02d: %6.2f sec, PSNR:%6.3f (%s)', image_num, time, snr_recon, method));
end;
%figure; imshow(im_out);    
