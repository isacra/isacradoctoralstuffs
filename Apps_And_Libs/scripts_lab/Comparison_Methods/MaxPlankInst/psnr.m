function PSNR = psnr(x, xest)
% Computes PSNR error criterion

if max(x(:) > 2), max_l2 = 255*255; else max_l2 = 1; end;

mse_noisy = mean((xest(:)-x(:)).^2);
psnr_noisy = 10*log10(max_l2/mse_noisy);
PSNR = psnr_noisy;