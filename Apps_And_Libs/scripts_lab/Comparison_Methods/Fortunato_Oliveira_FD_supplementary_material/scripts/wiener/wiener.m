function im_out = wiener(im_in, im_blurred, kernel, noise)

[R,C,CH] = size(im_in);
im_out = zeros(R,C,CH);
fft2_kernel  = fft2(kernel);

% An unrealistic implementation of Wiener Filter (assumes F and N known)
for ch = 1:CH
    fft2_noise   = fft2(noise(:,:,ch));
    fft2_im_in   = fft2(im_in(:,:,ch));
    fft2_blurred = fft2(im_blurred(:,:,ch));

    Hpower = abs(fft2_kernel .* conj(fft2_kernel)); 
    Fpower = abs(fft2_im_in  .* conj(fft2_im_in)); 
    Npower = abs(fft2_noise  .* conj(fft2_noise)); 
    im_out(:,:,ch) = real(ifft2( fft2_blurred .* conj(fft2_kernel) ./ (Hpower + (Npower ./ Fpower))));
%   K = 0.01;
%   im_out(:,:,ch) = real(ifft2( fft2_blurred .* conj(fft2_kernel) ./ (Hpower + K )));
end;

