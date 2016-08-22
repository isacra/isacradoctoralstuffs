function [correlation_function] = construct_correlation_function_correct(Lv,Lh, signal)


ordem = 3;
I = size(signal,1);
J= size(signal,2);
K = size(signal,3);
desvio = 1.0*1/4;

correlation = 0;
C = [ Lv^2  Lv*Lh*correlation  Lv*Lh*correlation  ; 
      Lv*Lh*correlation    Lh^2  Lh*Lh*correlation  ; 
      Lv*Lh*correlation      Lh*Lh*correlation    Lh^2];

correlation_function = zeros(I,J,K);
for i=1:I
    for j=1:J
        for k=1:K
            value = exp( -([(i-round(I/2)) (j-round(J/2)) (k-round(K/2))]*inv(C)*[(i-round(I/2)) ;(j-round(J/2)); (k-round(K/2))] ));                                             
            value_window = exp( -(abs((i-I/2)/(desvio*I))^ordem + abs((j-J/2)/(desvio*J))^ordem  + abs((k-K/2)/(desvio*K))^ordem));
            correlation_function(i,j,k) = value*value_window;
        end
    end
end


           
