function plotaPocoImagesc( background, tempo, prop, inline, amp)
%plotaPocoImagesc faz um imagesc do $background$ e plota um poco em cima
% $tempo$ precisa estar em indices ex (tempo-tempoInicial)/amostragem
% $prop$ propriedade a ser plotada
% $inline$ indice do inline a ser plotado
% $amplitude$ amplitude do maior valor para fins de visualizacao


figure;
imagesc(background);

x = prop-min(prop);

x = x./max(x).*amp + inline;
hold on

plot(x,tempo,'b','LineWidth',3);

plot([inline inline],minmax(tempo),'k','LineWidth',10);

end

