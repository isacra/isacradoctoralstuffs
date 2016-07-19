function [G] = acoustic_forward_matrix(wavelet,n)

D = zeros(n-1,n);
for i=1:n-1
    D(i,i) = -1;
    D(i,i+1) = 1;
end

n_w = length(wavelet); 
nl2 = int32((n_w-1)/2);  

C = convmtx(wavelet,n-1);
C = C(nl2+1:end - nl2,:);

G = (1/2)*C*D;