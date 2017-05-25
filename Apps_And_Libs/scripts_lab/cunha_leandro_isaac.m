% Este arquivo carrega os dados a serem usados como referencia na otimizacao

clear all;
close all;
crop = false;

deslocamento_max = 32;
profundidade_max = 32;
num_imgs = 696;
idx = 1;
batch_size = 32;

mkdir Images/cunha_lr_test
mkdir Images/cunha_hr_test
mkdir Images/cunha_hr
mkdir Images/cunha_lr
delete Images/cunha_hr/*.jpg;
delete Images/cunha_lr/*.jpg;
delete Images/cunha_lr_test/*.jpg;
delete Images/cunha_hr_test/*.jpg;

if crop
    deslocamento_max = 320;
    profundidade_max = 320;
    mkdir Images/cunha320_hr
    mkdir Images/cunha320_lr
    mkdir Images/cunha320_lr_test
    mkdir Images/cunha320_hr_test
    delete Images/cunha320_hr/*.jpg;
    delete Images/cunha320_lr/*.jpg;
    delete Images/cunha320_lr_test/*.jpg;
    delete Images/cunha320_hr_test/*.jpg;
    num_imgs = 100;
end

hr_im_cube_class = ImageCubeClass;
lr_im_cube_class = ImageCubeClass;

for image=1:num_imgs
    
espessura_cunha_max = 10 + rand*15;
base_cunha = 15 + rand*15;
tamanho_cunha = 0.5 + rand*0.40;

if crop
    espessura_cunha_max = 32 + rand*160;
    base_cunha = 192 + rand*132;
    tamanho_cunha = 0.5 + rand*0.45;1
end


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


%cunha(:,:,image) = impedancia_profundidade_deslocamento;
%im = prop2rgb(impedancia_profundidade_deslocamento);

[img_hr, hr_im_cube_class] = prop2gray(impedancia_profundidade_deslocamento,hr_im_cube_class);
[img_lr, lr_im_cube_class] = prop2gray(impedancia_profundidade_deslocamento_low,lr_im_cube_class);

if crop
    imgs_hr = crop_and_print(img_hr,'Images/cunha_hr/', image);
    imgs_lr = crop_and_print(img_lr,'Images/cunha_lr/', image);
else
    if image <= num_imgs - batch_size 
        imwrite(img_hr,strcat('Images/cunha_hr/',int2str(image),'.jpg'));
        imwrite(img_lr,strcat('Images/cunha_lr/',int2str(image),'.jpg'));
    
    else
        imwrite(img_hr,strcat('Images/cunha_hr_test/',int2str(image),'.jpg'));
        imwrite(img_lr,strcat('Images/cunha_lr_test/',int2str(image),'.jpg'));
    
        images_hr(idx,:,:) = img_hr;
        images(idx,:,:) = img_lr;
        idx = idx+1;
    end
    
end


end
save 'images.mat' images;
save workspace.mat;

