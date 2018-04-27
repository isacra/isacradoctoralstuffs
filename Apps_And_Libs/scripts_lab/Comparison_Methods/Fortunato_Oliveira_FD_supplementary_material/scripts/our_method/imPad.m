function [im_out, mask] = imPad(im_in, pad)

im_pad   = padarray(im_in, [pad, pad],'replicate','both');
[R,C,CH] = size(im_pad);

[X Y] = meshgrid (1:C, 1:R);

X0 = 1 + floor ( C / 2); Y0 = 1 + floor ( R / 2);
DX = abs( X - X0 )     ; DY = abs( Y - Y0 );
C0 = X0 - pad          ; R0 = Y0 - pad;

alpha = 0.01;

% force mask value at the borders aprox equal to alpha
% this makes the transition smoother for large kernels
nx = ceil(0.5 * log((1-alpha)/alpha) / log(X0 / C0));
ny = ceil(0.5 * log((1-alpha)/alpha) / log(Y0 / R0));

mX = 1 ./ ( 1 + ( DX ./ C0 ).^ (2 * nx));
mY = 1 ./ ( 1 + ( DY ./ R0 ).^ (2 * ny));
mask_0 = mX .* mY;

mask   = zeros(R,C,CH);
for ch = 1:CH
    mask(:,:,ch) = mask_0;
end;

im_out = zeros(R,C,CH);
im_out = im_pad .* mask;

