% Este arquivo carrega os dados a serem usados como referencia na otimizacao

clear all;
close all;
crop = false;

deslocamento_max = 32;
profundidade_max = 32;
num_imgs = 8;
idx = 1;
batch_size = 32;


%max_val = 5500;
%min_val = 4500;

%max_val = 3500;
%min_val = 2500;
max_val = 4500;
min_val = 3500;

mkdir Cunha/cunha_lr_test
mkdir Cunha/cunha_hr_test
mkdir Cunha/cunha_hr
mkdir Cunha/cunha_lr

hr_im_cube_class = ImageCubeClass;
lr_im_cube_class = ImageCubeClass;
hr_im_cube_test = ImageCubeClass;
lr_im_cube_test = ImageCubeClass;

cube_high = [];
cube_low = [];
idx = 1;
idx2 = 1;
for image=1:num_imgs

    
% if mod(image,2) == 0
%     max_val = 2500;
%     min_val = 1500;
% else 
%     max_val = 4500;
%     min_val = 3500;
% end

espessura_cunha_max = 10 + rand*15;
base_cunha = 15 + rand*17;
tamanho_cunha = 0.5 + rand*0.40;
inicio_cunha = randi(12,1);

% Calcula a espessura da cunha ao longo do deslocamento
for coluna = 5:deslocamento_max
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
		tempo_ate_topo_cunha(coluna) = 2 * (1000 * topo_cunha / max_val); % 1000 de milissegundos
		tempo_na_cunha(coluna) = tempo_ate_topo_cunha(coluna) + 2 * (1000 * (base_cunha - topo_cunha) / min_val);
		tempo_depois_cunha(coluna) = tempo_na_cunha(coluna) + 2 * (1000 * (profundidade_max - base_cunha) / max_val);
	else
		tempo_ate_topo_cunha(coluna) = 0;
		tempo_na_cunha(coluna) = 0;
		tempo_depois_cunha(coluna) = 2 * (1000 * profundidade_max / max_val);
	end;
	% Calcula valores de impedância em uma matriz Deslocamento x Tempo
	tempo_max = tempo_depois_cunha(1);
	for tempo = 1:tempo_max
		if tempo <= tempo_ate_topo_cunha(coluna)
			impedancia_tempo_deslocamento(tempo,coluna) = 2.6 * max_val;
		elseif tempo <= tempo_na_cunha(coluna)
			impedancia_tempo_deslocamento(tempo,coluna) = 2.4 * min_val;
		else
			impedancia_tempo_deslocamento(tempo,coluna) = 2.6 * max_val;
		end;
	end;
	for linha = 1:profundidade_max
	% Armazema matriz de impedância Deslocamento x Profundidade
		if linha >= topo_cunha && linha < base_cunha
			impedancia_profundidade_deslocamento(linha,coluna) = 2.4 * min_val;
            
		else
			
            impedancia_profundidade_deslocamento(linha,coluna) = 2.6 * max_val;
            
		end;
	end;
end;
for i = 1 : 4
    %ang = randi(360,1);
    ang = 90;
    if image <= 8
         imm = imrotate(impedancia_profundidade_deslocamento, i*ang);
         %imm = imm(1:32,1:32);
         images_hr(:,:,idx2) = imm;
         %images_lr(:,:,idx2) = lowPassFilter2(imm,4,100,20);
         images_lr(:,:,idx2) = imrotate(lowPassFilter2(impedancia_profundidade_deslocamento,4,randi(100,1),randi(50,1)), i*ang);
         idx2 = idx2 + 1;
    else
        cube_high(:,:,idx) = imrotate(impedancia_profundidade_deslocamento, ang);
        cube_low(:,:,idx) = imrotate(lowPassFilter2(impedancia_profundidade_deslocamento,4,100,20), ang);
        idx = idx + 1;
    end
    
end

% img_high = impedancia_profundidade_deslocamento;
% 
% impedancia_profundidade_deslocamento_low = lowPassFilter2(impedancia_profundidade_deslocamento,4,100,20);
% img_low =  impedancia_profundidade_deslocamento_low;

%imgrgb = prop2rgb(img_high);

%     if image <= num_imgs - batch_size 
%        
%         cube_high(:,:,image) = img_high;
%         cube_low(:,:,image) = img_low;
%     else
%      
%         images_hr(:,:,idx) = img_high;
%         images(:,:,idx) = img_low;
%         idx = idx+1;
%     end
    

end


X = 5000:3:15000;
X = X';
[~,Centroides] = kmeans(X,255);
cent_sort = sort(Centroides);
[indClt,Centroides] = kmeans(X,255,'Start',cent_sort);

% %% Gera cubo e arquivos de Imagens de treinamento
% [ hr_im_cube_class] = prop2gray(cube_high,hr_im_cube_class,Centroides);
% imgs_hr = crop_and_print(hr_im_cube_class,'Cunha/cunha_hr/');
% % 
% [lr_im_cube_class] = prop2gray(cube_low,lr_im_cube_class,Centroides);
% imgs_lr = crop_and_print(lr_im_cube_class,'Cunha/cunha_lr/');
% % % 

%% Gera cubo e arquivos de imagens de teste
[hr_im_cube_test] = prop2gray(images_hr,hr_im_cube_test,Centroides);
imgs_hr = crop_and_print(hr_im_cube_test,'Cunha/cunha_hr_test/');

[lr_im_cube_test] = prop2gray(images_lr,lr_im_cube_test,Centroides);
imgs_lr = crop_and_print(lr_im_cube_test,'Cunha/cunha_lr_test/');
images = [];
for i = 1:size(lr_im_cube_test.gray_images,3)
   im =  lr_im_cube_test.gray_images(:,:,i);
 
   images(i,:,:) = im;
   
end
save 'images_teste.mat' images;
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

