function PSNR = our_snr(sig, hk, ref)

sig = double(uint8(sig .* 255))./255;
ref = double(uint8(ref .* 255))./255;

ref2  = ref  (hk+1:end-hk, hk+1:end-hk, :);
sig2  = sig  (hk+1:end-hk, hk+1:end-hk, :);

mse  = mean ((ref2(:) - sig2(:)).^2);
PSNR = 10 * log10( 1 / mse);

