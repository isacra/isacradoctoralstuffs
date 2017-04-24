%%Read the images generated on output CNN (Images/gen_hr_imgs)
imp_hr_dir = '/home/malik/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance_sparse.segy';
imp_lr_dir = '/home/malik/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance.segy';
im_size = 32;
save_ims = false;
isRGB = false;

[~, hr_cube_class] = Impedance_Image_Blur(imp_hr_dir, save_ims,im_size,isRGB);
[~, lr_cube_class] = Impedance_Image_Blur(imp_lr_dir, save_ims,im_size,isRGB);

imagefiles = dir('Images/gen_hr_imgs/*.jpg');
nfiles = length(imagefiles);
images = [];
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentfilename = strcat('Images/gen_hr_imgs/',currentfilename);
   currentimage = imread(currentfilename);
   
   images(:,:,ii) = currentimage;
end

%new_impedance_cube = gray2prop(images,hr_cube_class);

cnn_imgs_fourier_cube = fourier_transform(images); %Transformada para imagens geradas pela rede
original_imgs_fourier_cube = fourier_transform(hr_cube_class.images); %Transformada para imagens originais de alta resolucao
lr_imgs_fourier_cube = fourier_transform(lr_cube_class.images); % Transformada para imagens originais de baixa resolucao

%% Busca os matches dos índices de fourier entre as imagens geradas pela rede
%e as imagens de alta resolução originais
[immatches, four_inds_map] = fourier_indices_calculate(images, hr_cube_class.images, cnn_imgs_fourier_cube,original_imgs_fourier_cube);

%% Busca os matches dos indices de fourier entre as imagens de alta e baixa
%resolucao originais
[immmatches2, four_inds_map2] = fourier_indices_calculate(lr_cube_class.images, hr_cube_class.images, lr_imgs_fourier_cube,original_imgs_fourier_cube);


%% Recupera a propriedade original das imagens e plota o trio de imagens (CNN, Alta e Baixa resolução)
%bem como seus histogramas
recovered_props = recover_props(immatches,immmatches2, images, lr_cube_class, hr_cube_class);