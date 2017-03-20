%%% Este script tem a finalidade de ler um cubo de impedancia e porosidade
% a partir de um arquivo segy. Após a leitura do arquivo, as imagens são
% borradas utilizando filtros do tipo disk, com parâmetro 5.
%   Além disso os pares de imagens (com e sem borro) são convertidas para um
% arquivo de extensão bin para serem lidas pelo script de RNC no tensorflow
%   As imagens são salvas em linha no formato .csv, para fazer a leitura das
% imagens no tensorflow é preciso fazer reshape para o tamanho original da
% imagem.
% 
%PS - por conta do estouro de memórias ao rodar o tensorflow com as imagens
%no tamanho original 251 x 315, o código foi editado para permitir cortar o
%cubo de imagens com altura e largura arbitrários

imWidth = 315;
imHight = 251;
cube_depth = 173250/315;
%cd /home/isaac/Documents/isacradoctoralstuffs/Apps_And_Libs;
impedancia_structure = read_segy_file('/home/isaac/Dados/MAPImpedancia_Porosidade/MAPjoint05_impedance.segy');

impedance_cube = reshape(impedancia_structure.traces, imHight,imWidth,cube_depth);

H = fspecial('disk',5);
im_h_beggin = imHight-31;
im_w_beggin = imWidth-31;
cut_cube = impedance_cube(im_h_beggin:imHight,im_w_beggin:imWidth,:);

% Scale the matrix to the range of the map.
for i=1:550
    %im_cut_gray = mat2gray(cut_cube(:,:,i)); %Pega a imagem cortada e gera escala de cinza
    im_cut_gray = cut_cube(:,:,i);
    C = colormap
    L = size(C,1);
    Gs = round(interp1(linspace(min(im_cut_gray(:)),max(im_cut_gray(:)),L),1:L,im_cut_gray));
    H1 = reshape(C(Gs,:),[size(Gs) 3]);
    minRGB = min(min(H1));
    maxRGB = max(max(H1));
    imR = H1(:,:,1) - minRGB(1); imR = 256*imR/maxRGB(1);
    imG = H1(:,:,2) - minRGB(2); imG = 256*imG/maxRGB(2);
    imB = H1(:,:,3) - minRGB(3); imB = 256*imB/maxRGB(3);
    %figure; imagesc(uint8(imR))
    %figure; imagesc(uint8(imG))
   %figure; imagesc(uint8(imB))
    %figure; imagesc(uint8(cat(3,imR, imG, imB)))
 
    cube_rgb(i,:,:,:) = uint8(cat(3,imR, imG, imB));
    imwrite(uint8(cat(3,imR, imG, imB)),strcat('CalebA/',int2str(i),'.jpg'))
    
%     im_R = reshape(im_cut_gray(:,:,1),[32*32,1]); %Transforma a matriz em linha
%     im_G = reshape(im_cut_gray(:,:,2),[32*32,1]); 
%     im_B = reshape(im_cut_gray(:,:,3),[32*32,1]); 
%     open_cut_cube(i,:) = im_cut';            %Coloca em ordem de coluna
    
    %image_reshaped = reshape(impedance_cube(:,:,i),[251*315,1]);
    %open_cube(i,:) = image_reshaped';
    
%     Blur = imfilter(image,H,'replicate');
%     blured_cube(:,:,i) = Blur;
end
save('/home/isaac/workspace/PixelCNN/data/cube.mat',cube_rgb);
im  = cut_cube(:,:,1);
figure; imagesc(im);



figure; image(H)  % Does this image match the other one?


csvwrite('impedance_cut_gray_images.csv', open_cut_cube);

