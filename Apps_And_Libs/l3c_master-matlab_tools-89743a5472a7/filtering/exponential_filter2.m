function [filtered] = exponential_filter2(order, signal, Ts, Ncoef, cutFreq);

Ts = 1e-3*Ts;
filtered = zeros(size(signal));

limits = round(Ncoef/2 - 1);
L = 1/(2*pi*Ts*cutFreq);
filter = exp( -( abs(-limits:limits ).^order ) / (L.^order) );
filter = filter/sum(filter);

for j=1:size(signal,2)
    signalMod(1:Ncoef) = signal(1,j);
    signalMod(Ncoef+1:Ncoef+length(signal(:,j))) = signal(1:end,j);
    signalMod(Ncoef+length(signal(:,j))+1:2*Ncoef+length(signal(:,j))+1) = signal(end,j);
    [aux] = conv(signalMod,filter,'same');
    filtered(:,j) = aux((Ncoef+1):(length(signal(:,j))+Ncoef));
end
