function im_out = zhou(im_blurred, kernel, sigma)
% based on code from Changyin Zhou @ Columbia U, 2009'
% http://www1.cs.columbia.edu/~changyin/SharedCode/ICCP2009/zDemo.html
% 27/09/2012

[R, C, CH] = size(im_blurred);

if R > C
    AStarR = eMakePrior_01(C, R) + 0.00000001;
    AStar = rot90(AStarR);
else
    AStar = eMakePrior_01(R, C) + 0.00000001;
end;

C1 = sigma * sigma * R * C ./ AStar;

fft2_kernel = fft2(kernel);
for ch = 1:CH
    im_out(:,:,ch) = real(ifft2((fft2(im_blurred(:,:,ch)) .* conj(fft2_kernel))./ (fft2_kernel .* conj(fft2_kernel) + C1 )));
end;
