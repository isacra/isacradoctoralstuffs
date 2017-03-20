% Este arquivo carrega os dados a serem usados como referencia na otimizacao

clear all;
close all;

deslocamento_max = 32;
profundidade_max = 32;
mkdir cunha_hr
mkdir cunha_lr
delete cunha_hr/*.jpg;
delete cunha_lr/*.jpg;

for image=1:640

espessura_cunha_max = 10 + rand*22;
base_cunha = 10 + rand*22;
tamanho_cunha = 0.5 + rand*0.45;

% Calcula a espessura da cunha ao longo do deslocamento
for coluna = 1:deslocamento_max
	espessura = espessura_cunha_max - ( (espessura_cunha_max / (tamanho_cunha * deslocamento_max)) * (coluna - 1) );
	if espessura < 0
		espessura_cunha(coluna) = 0;
	else
		espessura_cunha(coluna) = espessura;
	end;
end;

for coluna = 1:deslocamento_max
	% Calcula tempo ate atingir determinada profundidade, baseado na velocidade do meio
	topo_cunha = base_cunha - espessura_cunha(coluna);
	if topo_cunha ~= base_cunha
		tempo_ate_topo_cunha(coluna) = 2 * (1000 * topo_cunha / 3500); % 1000 de milissegundos
		tempo_na_cunha(coluna) = tempo_ate_topo_cunha(coluna) + 2 * (1000 * (base_cunha - topo_cunha) / 2500);
		tempo_depois_cunha(coluna) = tempo_na_cunha(coluna) + 2 * (1000 * (profundidade_max - base_cunha) / 3500);
	else
		tempo_ate_topo_cunha(coluna) = 0;
		tempo_na_cunha(coluna) = 0;
		tempo_depois_cunha(coluna) = 2 * (1000 * profundidade_max / 3500);
	end;
	% Calcula valores de impedância em uma matriz Deslocamento x Tempo
	tempo_max = tempo_depois_cunha(1);
	for tempo = 1:tempo_max
		if tempo <= tempo_ate_topo_cunha(coluna)
			impedancia_tempo_deslocamento(tempo,coluna) = 2.6 * 3500;
		elseif tempo <= tempo_na_cunha(coluna)
			impedancia_tempo_deslocamento(tempo,coluna) = 2.4 * 2500;
		else
			impedancia_tempo_deslocamento(tempo,coluna) = 2.6 * 3500;
		end;
	end;
	for linha = 1:profundidade_max
	% Armazema matriz de impedância Deslocamento x Profundidade
		if linha >= topo_cunha && linha < base_cunha
			impedancia_profundidade_deslocamento(linha,coluna) = 2.4 * 2500;
		else
			impedancia_profundidade_deslocamento(linha,coluna) = 2.6 * 3500;
		end;
	end;
end;

impedancia_profundidade_deslocamento_low = lowPassFilter2(impedancia_profundidade_deslocamento,4,100,20);
%impedancia_profundidade_deslocamento_low  = exponential_filter2(2,impedancia_profundidade_deslocamento,4,100,10);


cunha(:,:,image) = impedancia_profundidade_deslocamento;
im = prop2rgb(impedancia_profundidade_deslocamento);
imwrite(im,strcat('cunha_hr/',int2str(image),'.jpg'));


cunha_low(:,:,image) = impedancia_profundidade_deslocamento_low;
im = prop2rgb(impedancia_profundidade_deslocamento_low);
imwrite(im,strcat('cunha_lr/',int2str(image),'.jpg'));

% Desenha a cunha Deslocamento x Profundidade
 figure;
 subplot(2,1,1)
 imagesc(impedancia_profundidade_deslocamento);
 subplot(2,1,2)
 imagesc(impedancia_profundidade_deslocamento_low);
% drawnow
% pause
% set(gca,'YDir','reverse');
% xlabel('Deslocamento')
% ylabel('Profundidade')

end