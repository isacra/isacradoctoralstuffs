function[impFiltrada2] = lowPassFilter2(signal, Ts, Ncoef, cutFreq)
% lowPassFilter2(signal, Ts, Ncoef, cutFreq)
% signal - Sinal 2d, matriz de impedancia no caso.
%       obs. signal deve ser uma matriz ou um vetor coluna. No caso da
%       cada coluna que será filtrada
% Ts - Intervalo de amostragem  em ms
% Ncoef - Numero de coeficientes do filtro (analogo ao overlap do Jason)
% cutFreq - Frequencia de corte em HZ
%
% Exemple  dado_filtrado = lowPassFilter2(signal, 4, 110, 8);

Ts = Ts*1e-3;
for j=1:size(signal,2)
    [impFiltrada2(:,j),h] = lowPassFilter(signal(:,j), Ts, Ncoef, cutFreq);
end
%figure
%plot(abs(fft(h,250)));
end

function[impFiltrada,h] = lowPassFilter(signal, Ts, Ncoef, cutFreq)

Fnorm = cutFreq*2*Ts;

h=fir1(Ncoef,Fnorm)';

signalMod(1:Ncoef) = signal(1);
signalMod(Ncoef+1:Ncoef+length(signal)) = signal(1:end);
signalMod(Ncoef+length(signal)+1:2*Ncoef+length(signal)+1) = signal(end);

impFiltrada = filter(h,1,signalMod);
impFiltrada = impFiltrada((3*Ncoef/2+1):(length(signal)+(3*Ncoef/2)));
end