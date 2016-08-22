function [ simulation ] = FFT_MA_3D( correlation_function, noise )

X = correlation_function;

% I = size(noise,1);
% J = size(noise,2);
% K = size(noise,3);


Y = noise;


%     X1 = zeros(size(X,1) + size(Y,1) - 1, size(X,2) + size(Y,2) - 1, size(X,3) + size(Y,3) - 1);
%     X1(1:size(X,1), 1:size(X,2), 1:size(X,3)) = X;
%     Y1 = zeros(size(X1));    
%     Y1(1:size(Y,1), 1:size(Y,2), 1:size(Y,3)) = Y;
    c2 = ifftn(sqrt(abs(fftn(X,size(Y)))) .* fftn(Y,size(Y)));
    %c2 = ifftn(sqrt(abs(fftn(X1))) .* fftn(Y1,));

   %%c2 = c2(1:I, 1:J, 1:K);
    simulation = real(c2);
    
%     noise_points = I * J * K;    
%     figure
%     imagesc(c2_r(:,:,end/2))
%     title('FFT')
% 
%     fft_c2 = fftn(ifftshift(c2));
%     corr_c2_w = (conj(fft_c2) .* fft_c2) / noise_points;
%     corr_c2_t = ifftshift(real(ifftn(corr_c2_w)));
%     
%     figure
%     imagesc(corr_c2_t(:,:,end/2))
    
end