function PSNR = psnr_noborder(x, xest, sf)
% Computes PSNR error criterion, ignoring the border region

sfh = floor(sf/2);
x = x(1+sfh(1):end-sfh(1), 1+sfh(2):end-sfh(2));
xest = xest(1+sfh(1):end-sfh(1), 1+sfh(2):end-sfh(2));
if max(x(:) > 2), max_l2 = 255*255; else max_l2 = 1; end;

mse_noisy = mean((xest(:)-x(:)).^2);
psnr_noisy = 10*log10(max_l2/mse_noisy);
PSNR = psnr_noisy;
