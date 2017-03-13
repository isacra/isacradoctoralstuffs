function [filtered] = exponential_filter2(order, signal, Ts, Ncoef, cutFreq);

filtered = zeros(size(signal));

limits = round(Ncoef/2 - 1);
L = 1/(2*pi*Ts*cutFreq)
filter = exp( -( (-limits:limits ).^order ) / (L.^order) );

for j=1:size(signal,2)
    [filtered(:,j)] = conv(signal(:,j),filter,'same');
end
