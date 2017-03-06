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
im_h_beggin = imHight-27;
im_w_beggin = imWidth-27;
cut_cube = impedance_cube(im_h_beggin:imHight,im_w_beggin:imWidth,:);

for i=1:550
    im_cut_gray = mat2gray(cut_cube(:,:,i)); %Pega a imagem cortada e gera escala de cinza
    im_cut = reshape(im_cut_gray,[28*28,1]); %Transforma a matriz em linha
    open_cut_cube(i,:) = im_cut';            %Coloca em ordem de coluna
    
    %image_reshaped = reshape(impedance_cube(:,:,i),[251*315,1]);
    %open_cube(i,:) = image_reshaped';
    
%     Blur = imfilter(image,H,'replicate');
%     blured_cube(:,:,i) = Blur;
end
im  = cut_cube(:,:,1);
figure; imagesc(im);
C = jet(64);  % Get the figure's colormap.
L = size(C,1);
% Scale the matrix to the range of the map.
Gs = round(interp1(linspace(min(im(:)),max(im(:)),L),1:L,im));
H = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
figure; image(H)  % Does this image match the other one?


csvwrite('impedance_cut_gray_images.csv', open_cut_cube);

