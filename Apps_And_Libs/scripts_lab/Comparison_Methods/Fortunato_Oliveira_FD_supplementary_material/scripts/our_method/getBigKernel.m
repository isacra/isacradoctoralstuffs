function kernel = getBigKernel(R, C, small_kernel)

kernel = zeros(R,C); 
RC     = floor(R/2); CC = floor(C/2); 

[RF,CF] = size(small_kernel); 
RCF = floor(RF/2); CCF = floor(CF/2); 

kernel(RC-RCF+1:RC-RCF+RF,CC-CCF+1:CC-CCF+CF) = small_kernel;
kernel = ifftshift(kernel);
kernel = kernel ./ sum(kernel(:));
