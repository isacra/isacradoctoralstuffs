function xest = deconv(y, f, alpha, beta)
%DECONV - Direct deconvolution in Fourier space
%   Given a blurry image, does a regularized direct deconvolution with circular
%   boundary conditions
%   (the minimum of |f*x - y|^2 + alpha*|nabla*x|^2 + beta*|x|^2).
% 
%   Inputs
%   ------
%   y: Blurry image.
%   f: Blur kernel.
%   alpha: L2 gradient regularization
%   beta: L2 regularization
%
%   Outputs
%   -------
%   xest: The deconvolved image.
%
%   Example
%   -------
%     sigma = 0.04;
%     f = fspecial('gaussian', 25, 3.);
%     y = imfilter(x, f, 'circular', 'conv') + sigma*randn(size(x));
%     xest = deconv(im_blurry, f, 20.*sigma^2);
%
%   Author: Christian J. Schuler

% default parameters
if ~exist('beta', 'var')
  beta = 0.;
end
sx = size(y);
sfft = sx;

% gradient regularization
G1 = fftn([1,-1]/sqrt(2), sfft);
G2 = fftn([1;-1]/sqrt(2), sfft);
reg = conj(G1).*G1 + conj(G2).*G2;

% deconvolution
sf = size(f);
pad_size = sfft - sf;
f = padarray(f, pad_size, 'post');
f = fftn(circshift(f, -floor(sf/2)));
y = fftn(y, sfft);
xest = ifftn(...
    (conj(f).*y) ./ (conj(f).*f + alpha*reg + beta), sx, 'symmetric');
