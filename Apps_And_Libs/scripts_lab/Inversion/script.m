
load /home/isaac/Documentos/Dados_Doutorado/dados.mat

wavelet_ = lowPassFilter2(wavelet,40,100,4);
%wavelet_ = wavelet;

refl = impedancia2refletividade(impedancia_cubo);
traces_sintetico = conv2(refl,wavelet_,'same');

ruido_branco = 0.15*randn(size(traces_sintetico))*std(traces_sintetico(:));

ruido = conv2(ruido_branco,wavelet_,'same');
ruido = conv2(ruido,wavelet_','same');

traces_sintetico_ruido = traces_sintetico + ruido;

imp_low = lowPassFilter2(impedancia_cubo,40, 100,2);

[uzl,uzl_Merged,sySeismic] = MAP_inversion(imp_low,wavelet_,0.1,1.5,traces_sintetico_ruido,200);

% for i = 100:120
%     figure
%     imagesc(uzl(:,(i-1)*199 +1:(i-1)*199+199))
%     figure
%     imagesc(impedancia_cubo(:,(i-1)*199 +1:(i-1)*199+199))
%     caxis([5000 8000])
% end

impedance_Cube = reshape(impedancia_cubo,251,199,47561/199);
uzl_Cube =  reshape(uzl,251,199,47561/199);

% imWidth = 199;
% imHight = 251;
% im_h_beggin = imHight-(32-1);
% im_w_beggin = imWidth-(32-1);
impedance_cut = impedance_Cube(160:192,100:132,:);
inversion_cut = uzl_Cube(160:191,100:131,:);

%gen_images(dir_lr_imgs, dir_hr_imgs, im_width, im_hight, im_res_size);

delete Images/sintetico_hr/*.jpg;
delete Images/sintetico_hr/*.jpg;
mkdir Images/sintetico_hr
mkdir Images/sintetico_lr
images = [];
randomIndx = randi(239,[1,32]);

images_hr_test = impedance_cut(:,:,randomIndx);
images_lr_test = inversion_cut(:,:,randomIndx);
impedance_cut(:,:,randomIndx) = [];
inversion_cut(:,:,randomIndx) = [];

for i=1:size(images_lr_test,3)
    images(i,:,:)= images_lr_test(:,:,i);
    
end
save 'images.mat' images;
im_cube_class = ImageCubeClass;
im_cube_class_inv = ImageCubeClass;
for i=1:size(impedance_cut,3)
    imp_cut = impedance_cut(:,:,i);
    inv_cut = inversion_cut(:,:,i);
    
    [img, im_cube_class] = prop2gray(imp_cut,im_cube_class);
    [img_inv, im_cube_class_inv] = prop2gray(inv_cut,im_cube_class_inv);
    
    imwrite(img,strcat('Images/sintetico_hr/',int2str(i),'.jpg'));
    imwrite(img_inv,strcat('Images/sintetico_lr/',int2str(i),'.jpg'));    
end
