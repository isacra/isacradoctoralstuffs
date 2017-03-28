function [img, im_cube_class] = Impedance_Image_Blur(file_dir, isSave, image_size,isRGB)

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
    im_cube_class = ImageCubeClass;
    
    %cd /home/isaac/Documents/isacradoctoralstuffs/Apps_And_Libs;
    impedancia_structure = read_segy_file(file_dir);

    impedance_cube = reshape(impedancia_structure.traces, imHight,imWidth,cube_depth);

    H = fspecial('disk',5);
    im_h_beggin = imHight-(image_size-1);
    im_w_beggin = imWidth-(image_size-1);
    cut_cube = impedance_cube(im_h_beggin:imHight,im_w_beggin:imWidth,:);
    

    % Scale the matrix to the range of the map.
    for i=1:550
        im_cut = cut_cube(:,:,i);

        %cube_rgb(i,:,:,:) = prop2rgb(im_cut_gray);
        if(isRGB)
            %[img, im_cube_class] = prop2rgb(im_cut,im_cube_class); %Falta
            %ajustar a função prop2rgb
        else
            [img, im_cube_class] = prop2gray(im_cut,im_cube_class);
        end
        if(isSave)
            
            imwrite(img,strcat('impedance_hr/',int2str(i),'.jpg'));
        end
    end
    
end
