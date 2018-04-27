function im_out = our_method_bifilter(im_blurred, kernel, we)

[R, C, CH] = size(im_blurred);

im_out      = zeros(R, C, CH);
im_out_temp = zeros(R, C, CH);
im_out_bi   = zeros(R, C, CH);
im_out_bi2  = zeros(R, C, CH);
B0          = zeros(R, C, CH);

fft2_kernel = fft2(kernel);
conj_fft2_kernel = conj(fft2_kernel);
A0 = real(conj_fft2_kernel .* fft2_kernel);

%clear fft2_kernel;
A1 = getA1(R,C);
A10  = A0 + we(1) .* A1;

% Gaussian step
for ch = 1:CH % RGB channels
    B0(:,:,ch)  = conj_fft2_kernel .* fft2(im_blurred(:,:,ch));
    im_out_temp(:,:,ch)   = real(ifft2(B0(:,:,ch) ./ A10)); 
end;

% Bilateral filter:
sigma_s = we(2);  sigma_r = we(3);

im_out_bi = our_RF(im_out_temp, sigma_s, sigma_r);

A12  = A0 + we(4) .* A1;
for ch = 1:CH % RGB channels
    b1 = get_b1(im_out_bi(:,:,ch));
    B = B0(:,:,ch) + we(4) .* fft2(b1);    
    im_out(:,:,ch)  = real(ifft2(B ./ A12)); 
end;


