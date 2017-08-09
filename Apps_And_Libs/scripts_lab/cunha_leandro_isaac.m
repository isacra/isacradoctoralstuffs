% Este arquivo carrega os dados a serem usados como referencia na otimizacao

clear all;
close all;
crop = false;

deslocamento_max = 32;
profundidade_max = 32;
num_imgs = 672;
idx = 1;
batch_size = 32;

mkdir Cunha/cunha_lr_test
mkdir Cunha/cunha_hr_test
mkdir Cunha/cunha_hr
mkdir Cunha/cunha_lr
delete Cunha/cunha_hr/*.jpg;
delete Cunha/cunha_lr/*.jpg;
delete Cunha/cunha_lr_test/*.jpg;
delete Cunha/cunha_hr_test/*.jpg;

if crop
    deslocamento_max = 320;
    profundidade_max = 320;
    mkdir Cunha/cunha320_hr
    mkdir Cunha/cunha320_lr
    mkdir Cunha/cunha320_lr_test
    mkdir Cunha/cunha320_hr_test
    delete Cunha/cunha320_hr/*.jpg;
    delete Cunha/cunha320_lr/*.jpg;
    delete Cunha/cunha320_lr_test/*.jpg;
    delete Cunha/cunha320_hr_test/*.jpg;
    num_imgs = 100;
end

hr_im_cube_class = ImageCubeClass;
lr_im_cube_class = ImageCubeClass;
hr_im_cube_test = ImageCubeClass;
lr_im_cube_test = ImageCubeClass;

cube_high = [];
cube_low = [];

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
			impedancia_profundidade_deslocamento(linha,coluna) = 2.6 * 3s500;
		end;
	end;
end;

img_high = impedancia_profundidade_deslocamento;

impedancia_profundidade_deslocamento_low = lowPassFilter2(impedancia_profundidade_deslocamento,4,100,20);
img_low =  impedancia_profundidade_deslocamento_low;

if crop
    imgs_hr = crop_and_print(img_hr,'Cunha/cunha_hr/', image);
    imgs_lr = crop_and_print(img_lr,'Cunha/cunha_lr/', image);
else
    if image <= num_imgs - batch_size 
       
        cube_righ(:,:,image) = img_high;
        cube_low(:,:,image) = img_low;
    else
     
        images_hr(:,:,idx) = img_high;
        images(:,:,idx) = img_low;
        idx = idx+1;
    end
    
end


end

%% Gera cubo e arquivos de Imagens de treinamento
[~, hr_im_cube_class] = prop2gray(cube_righ,hr_im_cube_class);
imgs_hr = crop_and_print(hr_im_cube_class,'Cunha/cunha_hr/');

[~, lr_im_cube_class] = prop2gray(cube_low,lr_im_cube_class);
imgs_lr = crop_and_print(lr_im_cube_class,'Cunha/cunha_lr/');


%% Gera cubo e arquivos de imagens de teste
[~, hr_im_cube_test] = prop2gray(images_hr,hr_im_cube_test);
imgs_hr = crop_and_print(hr_im_cube_test,'Cunha/cunha_hr_test/');

[~, lr_im_cube_test] = prop2gray(images,lr_im_cube_test);
imgs_lr = crop_and_print(lr_im_cube_test,'Cunha/cunha_lr_test/');
images = [];
for i = 1:size(lr_im_cube_test.gray_images,3)
   images(i,:,:) =  lr_im_cube_test.gray_images(:,:,i);
end
save 'images.mat' images;
save workspace_cunha.mat;

%% Impressão das imagens unidadas em uma única imagem
% image = [];
% ims = [];
% for i=1:25
% image = [image, reshape(images_hr_test(:,:,i),32,32)];
% if mod(i, 5) == 0
% ims = [ims;image];
% image = [];
% end
% end

