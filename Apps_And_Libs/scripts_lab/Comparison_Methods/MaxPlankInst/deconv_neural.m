function im_deblurred = deconv_neural_circ(im_blurry, weights, step, circular)
%DECONV_NEURAL_CIRC - Neural net deconvolution function
%   Given a blurry image preprocessed with direct deconvolution, returns a
%   deblurred version of that image.
% 
%   Inputs
%   ------
%   im_blurry: An image preprocessed with direct deconvolution. The image is
%     assumed to be in the range 0..1.
%   weights: The weights of the pretrained neural network for this blur.
%   step: The sliding window stride of the deblurring.
%   circular: If true assumes circular boundary conditions.
%
%   Outputs
%   -------
%   im_deblurred: The estimate of the deblurred image.
%
%   Example
%   -------
%     sigma = 0.04;
%     f = fspecial('gaussian', 25, 3.);
%     im_blurry = imfilter(im_clean, f, 'circular', 'conv')...
%          + sigma*randn(size(im_clean));
%     im_deblurred = deconv_neural_circ(...
%          deconv(im_blurry, f, 20.*sigma^2), weights, 3, true);
%     psnr_blurry = psnr_noborder(im_clean, im_blurry, size(f));
%     psnr_deblurred = psnr_noborder(im_clean, im_deblurred, size(f));
%
%   Authors: Harold Christopher Burger, Christian J. Schuler

% default parameters
if ~exist('weights', 'var')
  weights = 'weights/neuralweights.mat';
end
if ~exist('step', 'var')
  step = 3;
end

% load the weights, if possible use GPU
load(weights);
w = {};
w{1} = single(w_1);
w{2} = single(w_2);
w{3} = single(w_3);
w{4} = single(w_4);
w{5} = single(w_5);
try
  w{1} = gpuArray(w_1);
  w{2} = gpuArray(w_2);
  w{3} = gpuArray(w_3);
  w{4} = gpuArray(w_4);
  w{5} = gpuArray(w_5);
  gpu = true;
catch %#ok<CTCH>
  gpu = false;
end
clear w_1; clear w_2; clear w_3; clear w_4; clear w_5;

size_patch_in = sqrt(size(w{1}, 2)-1);
size_patch_out = sqrt(size(w{5}, 1));

p_diff = (size_patch_in - size_patch_out)/2;
% check if input is larger than output and extend image accordingly
size_im = size(im_blurry);
if (p_diff>0)
  if circular
    % circular boundary conditions
    im_blurry = padarray(im_blurry, [p_diff p_diff], 'circular');
  else
    % extend image by reflection of border regions
    im_blurry = [fliplr(im_blurry(:,(1:p_diff)+1)) im_blurry...
                 fliplr(im_blurry(:, size_im(2)-p_diff:size_im(2)-1))];  
    im_blurry = [flipud(im_blurry((1:p_diff)+1,:)); im_blurry;...
                 flipud(im_blurry((size_im(1)-p_diff:size_im(1)-1), :))];
  end
end

% gaussian weights for blending overlapping patches
pixel_weights = zeros(size_patch_out);
mid = ceil(size_patch_out/2);
sig = floor(size_patch_out/2)/2.;
for i=1:size_patch_out
  for j=1:size_patch_out
    d = sqrt((i-mid)^2 + (j-mid)^2);    
    pixel_weights(i,j) = exp((-d^2)/(2*(sig^2))) / (sig*sqrt(2*pi));
  end
end
pixel_weights = pixel_weights/max(pixel_weights(:));

range = 1.;  % assumes range 0..1
% transform image to normalization used in the neural network
im_blurry = single(((im_blurry/range)-0.5)/0.2);

% process patches in chunks
chunk_size = 1024;

% ranges for overlapping patches
range_y = 1:step:(size(im_blurry,1)-size_patch_in+1);
range_x = 1:step:(size(im_blurry,2)-size_patch_in+1);
if (range_y(end)~=(size(im_blurry,1)-size_patch_in+1))
  range_y = [range_y (size(im_blurry,1)-size_patch_in+1)];
end
if (range_x(end)~=(size(im_blurry,2)-size_patch_in+1))
  range_x = [range_x (size(im_blurry,2)-size_patch_in+1)];
end

patches_in = zeros(size_patch_in^2, chunk_size, 'single');
positions_out = zeros(2, chunk_size);

im_deblurred = zeros(size_im);
im_weights = zeros(size_im);

idx = 0;
for y = range_y
  for x = range_x
    patch = im_blurry(y:y+size_patch_in-1, x:x+size_patch_in-1)';
    idx = idx + 1;
    patches_in(:, idx) = patch(:);
    positions_out(:, idx) = [y; x];
    if (idx >= chunk_size)
      % predict with neural network
      temp = patches_in;
      for i = 1:5
        if gpu
          temp = vertcat(...
              temp, gpuArray.ones(1, size(temp,2), 'single')); %#ok<AGROW>
        else
          temp = vertcat(...
              temp, ones(1, size(temp,2))); %#ok<AGROW>
        end
        
        if (i < 5)
          temp = tanh(w{i} * temp);
        else
          if gpu
            patches_out = gather(w{i} * temp);
          else
            patches_out = w{i} * temp;
          end

          patches_weights = repmat(pixel_weights(:), [1 size(patches_out, 2)]);
          patches_out = patches_out .* patches_weights;

          % place in output im_deblurred            
          for j = 1:chunk_size
            tmp_p_y = positions_out(1,j):positions_out(1,j)+size_patch_out-1;
            tmp_p_x = positions_out(2,j):positions_out(2,j)+size_patch_out-1;
            im_deblurred(tmp_p_y, tmp_p_x) = im_deblurred(tmp_p_y,tmp_p_x)...
                + reshape(patches_out(:,j), [size_patch_out size_patch_out])';
            im_weights(tmp_p_y, tmp_p_x) = im_weights(tmp_p_y, tmp_p_x)...
                + reshape(patches_weights(:,j),...
                          [size_patch_out size_patch_out]);
          end
        end
      end
      idx = 0;
    end
  end
end

% predict remaining patches
temp = patches_in(:,1:idx);
for i = 1:5
  if gpu
    temp = vertcat(temp, gpuArray.ones(1, size(temp,2), 'single')); %#ok<AGROW>
  else
    temp = vertcat(temp, ones(1, size(temp,2))); %#ok<AGROW>
  end
  
  if (i < 5)
    temp = tanh(w{i} * temp);
  else
    if gpu
      patches_out = gather(w{i} * temp);
    else
      patches_out = w{i} * temp;
    end

    patches_weights = repmat(pixel_weights(:), [1 size(patches_out, 2)]);
    patches_out = patches_out .* patches_weights;

    % place in output im_deblurred            
    for j=1:size(temp,2)
      tmp_p_y = positions_out(1,j):positions_out(1,j)+size_patch_out-1;
      tmp_p_x = positions_out(2,j):positions_out(2,j)+size_patch_out-1;
      im_deblurred(tmp_p_y, tmp_p_x) = im_deblurred(tmp_p_y, tmp_p_x)...
          + reshape(patches_out(:,j), [size_patch_out size_patch_out])';
      im_weights(tmp_p_y, tmp_p_x) = im_weights(tmp_p_y, tmp_p_x)...
          + reshape(patches_weights(:,j), [size_patch_out size_patch_out]);
    end
  end
end

% remove effect of overlapping patches and invert normalization
im_deblurred = im_deblurred ./ im_weights;
im_deblurred = ((im_deblurred*0.2)+0.5)*range;
