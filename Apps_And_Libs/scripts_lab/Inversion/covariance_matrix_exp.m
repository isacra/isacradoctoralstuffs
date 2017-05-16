function [C] = covariance_matrix_exp(sgm,L,order)

if order ~= '2' && order ~= '1' 
    disp('Order não aceita...  order deve ser ´1´ ou ´2´.')
end

n = length(sgm);
C = zeros(n,n);

if order == '1'     
    for i=1:n
        for j=1:n
            C(i,j) = sgm(i)*sgm(j)*exp(-abs(i-j)/L);
        end
    end
else
    if order == '2'     
        for i=1:n
            for j=1:n
                C(i,j) = sgm(i)*sgm(j)*exp(-((i-j)^2)/(L^2));
            end
        end        
    end
end
    
    