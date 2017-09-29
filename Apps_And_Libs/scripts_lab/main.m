%%Read the images generated on output CNN (Images/gen_hr_imgs)
%imp_hr_dir = '/home/malik/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance_sparse.segy';
%imp_lr_dir = '/home/malik/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance.segy';
%im_size = 32;
%save_ims = false;
%isRGB = false;

%[~, hr_cube_class] = Impedance_Image_Blur(imp_hr_dir, save_ims,im_size,isRGB);
%[~, lr_cube_class] = Impedance_Image_Blur(imp_lr_dir, save_ims,im_size,isRGB);

%lr_dir_name = 'Images/sintetico_lr_test/';
%hr_dir_name = 'Images/sintetico_hr_test/'; 

result_dir_name ='Images/Resultados/Cunha/'; 
lr_dir_name = 'Cunha/cunha_lr_test/';
hr_dir_name = 'Cunha/cunha_hr_test/'; 


%result_dir_name = 'Resultados/Sintetico/';

imagefiles = dir(strcat(result_dir_name,'*.jpg'));
hr_imagesfiles = dir(strcat(hr_dir_name,'*.jpg'));
lr_imagesfiles = dir(strcat(lr_dir_name,'*.jpg'));

nfiles = length(imagefiles);
filesNames = natsort({imagefiles.name});
cnn_images = [];
for ii=1:nfiles
   currentfilename = char(filesNames(ii));
   currentfilename = strcat(result_dir_name,currentfilename);
   currentimage = imread(currentfilename);
   
   cnn_images(:,:,ii) = currentimage;
end

nfiles = length(hr_imagesfiles);
filesNames = natsort({hr_imagesfiles.name});
sintetic_images = [];
for ii=1:nfiles
   currentfilename = char(filesNames(ii));
   currentfilename = strcat(hr_dir_name,currentfilename);
   currentimage = imread(currentfilename);
   
   sintetic_images(:,:,ii) = currentimage;
end

nfiles = length(lr_imagesfiles);
filesNames = natsort({lr_imagesfiles.name});
low_images = [];
for ii=1:nfiles
   currentfilename = char(filesNames(ii));
   currentfilename = strcat(lr_dir_name,currentfilename);
   currentimage = imread(currentfilename);
   
   low_images(:,:,ii) = currentimage;
end

%new_impedance_cube = gray2prop(images,hr_cube_class);

cnn_imgs_fourier_cube = fourier_transform(cnn_images); %Transformada para imagens geradas pela rede
original_imgs_fourier_cube = fourier_transform(sintetic_images); %Transformada para imagens originais de alta resolucao
lr_imgs_fourier_cube = fourier_transform(low_images); % Transformada para imagens originais de baixa resolucao

%% Busca os matches dos índices de fourier entre as imagens geradas pela rede
%e as imagens de alta resolução originais
[immatches, four_inds_map] = fourier_indices_calculate(cnn_images, sintetic_images, cnn_imgs_fourier_cube,original_imgs_fourier_cube);

%% Busca os matches dos indices de fourier entre as imagens da rede e baixa resolução
%resolucao originais
[immmatches2, four_inds_map2] = fourier_indices_calculate(cnn_images,low_images, cnn_imgs_fourier_cube, lr_imgs_fourier_cube);


%% Recupera a propriedade original das imagens e plota o trio de imagens (CNN, Alta e Baixa resolução)
%bem como seus histogramas
recovered_props = recover_props(immatches,immmatches2, cnn_images , low_images, sintetic_images);

