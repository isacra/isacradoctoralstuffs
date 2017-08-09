
load /home/isaac/Documentos/Dados_Doutorado/Dados_leandro/dados.mat

%% Inversão Acústica MAP

%wavelet_ = lowPassFilter2(wavelet,4,100,8);
wavelet_ = wavelet;

refl = impedancia2refletividade(impedancia_cubo);
traces_sintetico = conv2(refl,wavelet_,'same');

ruido_branco = 0.30*randn(size(traces_sintetico))*std(traces_sintetico(:));

ruido = conv2(ruido_branco,wavelet_,'same');
ruido = conv2(ruido,wavelet_','same');

traces_sintetico_ruido = traces_sintetico + ruido;

imp_low = lowPassFilter2(impedancia_cubo,4, 100,4);

[uzl,uzl_Merged,sySeismic] = MAP_inversion(imp_low,wavelet_,0.1,1.5,traces_sintetico_ruido,200);

impedance_Cube = reshape(impedancia_cubo,251,199,47561/199);
uzl_Cube =  reshape(uzl,251,199,47561/199);


%% Geração das imagens
xini = 80;
yini = 170;
delta = 31;

impedance_cut = impedance_Cube(yini:yini+delta,xini:xini+delta,:);
inversion_cut = uzl_Cube(yini:yini+delta,xini:xini+delta,:);

delete Images/sintetico_hr;
delete Images/sintetico_lr;
delete Images/sintetico_lr_test/*.jpg;
delete Images/sintetico_hr_test/*.jpg;

mkdir Images/sintetico_hr
mkdir Images/sintetico_lr
mkdir 'Images/sintetico_lr_test/'
mkdir 'Images/sintetico_hr_test/'

images = [];
randomIndx = randi(239,[1,32]);

images_hr_test = impedance_cut(:,:,randomIndx);
images_lr_test = inversion_cut(:,:,randomIndx);
impedance_cut(:,:,randomIndx) = [];
inversion_cut(:,:,randomIndx) = [];

%% Geração das imagens para teste obtidas da inversão
im_lr_cube_test = ImageCubeClass;
[~,im_lr_cube_test] = prop2gray(images_lr_test,im_lr_cube_test);
crop_and_print(im_lr_cube_test, 'Images/sintetico_lr_test/');
save 'images.mat' images;


%% Geração das imagens de teste sinteticas para comparação
im_hr_cube_test = ImageCubeClass;
[~,im_hr_cube_test] = prop2gray(images_hr_test,im_hr_cube_test);
crop_and_print(im_hr_cube_test, 'Images/sintetico_hr_test/');


%% Geração das imagens de alta resolução sintéticas
im_cube_impedancia_sint = ImageCubeClass;
[~, im_cube_impedancia_sint] = prop2gray(impedance_cut,im_cube_impedancia_sint);
crop_and_print(im_cube_impedancia_sint, 'Images/sintetico_hr/');

%% Geração das imagens de baixa resolução resultantes da inversão sísmica
im_cube_impedancia_inv = ImageCubeClass;
[img_inv, im_cube_impedancia_inv] = prop2gray(inversion_cut,im_cube_impedancia_inv);
crop_and_print(im_cube_impedancia_sint,'Images/sintetico_lr/');

save workspace_sintetico.mat

%Imprime a imagem com retângulo na posição onde a imagem foi cortada
    %figure; imagesc(impedance_Cube(:,:,100))
    h = colorbar;
    xlabel('Traço','FontSize',12)
    ylabel('Profundidade','FontSize',12)
    ylabel(h,'Impedância','FontSize',12)
    set(gcf,'color','w')
    rectangle('Position',[xini,yini,32,32],'EdgeColor','r',...
        'LineWidth',1.5)
    figure; imagesc(impedance_Cube(yini:yini+delta,xini:xini+delta,100))
    set(gcf,'color','w')


 

