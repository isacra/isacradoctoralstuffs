%%Read the images generated on output CNN (Images/gen_hr_imgs)
imp_hr_dir = '/home/isaac/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance_sparse.segy';
imp_lr_dir = '/home/isaac/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance.segy';
im_size = 32;
save_ims = false;
isRGB = false;

[~, im_cube_class] = Impedance_Image_Blur(imp_hr_dir, save_ims,im_size,isRGB);

imagefiles = dir('Images/gen_hr_imgs/*.jpg');
nfiles = length(imagefiles);
images = [];
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentfilename = strcat('Images/gen_hr_imgs/',currentfilename);
   currentimage = imread(currentfilename);
   
   images(:,:,ii) = currentimage;
end

%new_impedance_cube = gray2prop(images,im_cube_class);

cnn_imgs_fourier_cube = fourier_transform(images);

original_imgs_fourier_cube = fourier_transform(im_cube_class.images);
%original_imgs_fourier_cube = fourier_transform(images); %linha de teste do
%método

[immatches, four_inds_map] = fourier_indices_calculate(images, im_cube_class.images, cnn_imgs_fourier_cube,original_imgs_fourier_cube);

recovered_props = recover_props(immatches, images, im_cube_class);