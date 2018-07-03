LEN = 3;
THETA = 15;
PSF = fspecial('motion', LEN, THETA);
%PSF = fspecial('log', 9, .5) 

blurred = imfilter(y_teste_1, PSF, 'conv', 'circular');
figure, imagesc(blurred)

noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred, 'gaussian', ...
                        noise_mean, noise_var);
figure, imagesc(blurred_noisy)
title('Simulate Blur and Noise')

estimated_nsr = noise_var / var(y_teste_1(:));
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure, imagesc(wnr3)
title('Saída método Deconvwnr - Wiener Filter');
%calcfrequencies(y_test_corte_x,x_test_corte_x,wnr3,3);

figure; subplot(1,3,1);imagesc(y_test_corte_x(:,:,2));
set(gca,'Color','white'); colormap('jet');
subplot(1,3,2); imagesc(cnnout(:,:,2));
set(gca,'Color','white'); colormap('jet');
subplot(1,3,3); imagesc(x_test_corte_x(:,:,2));
set(gca,'Color','white'); colormap('jet');