PSF = fspecial('gaussian',2,5);
V = .0001;
BlurredNoisy = imnoise(imfilter(y_teste_1,PSF),'gaussian',0,V);
[J P] = deconvblind(BlurredNoisy,PSF,1);
%figure; imagesc(J1)

[J1 P1] = deconvblind(x_teste_1,PSF,1);