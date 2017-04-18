function [ image_gray im_cube] = prop2gray( image,im_cube )
    %PROP2GRAY Summary of this function goes here
    %   Detailed explanation goes here
    [~,indx] = size(im_cube.max);
    indx = indx +1;
    max_im = max(max(image));
    min_im = min(min(image));

    im_cube.max(:,indx) = max_im;
    im_cube.min(:,indx) = min_im;

    new_impedance = 256*(image - min_im)/max_im;
    %O round vai arrendondar o valor para inteiro.
    %posso guardar uma matrix de ruido referente ao que foi retirado de cada
    %pixel para reconstruir depois. Fazer um cubo de ruidos para todas as
    %imagens. Uma opcao é esta funcao receber o cubo de imagens e retornar o
    %cubo convertido e o cubo de ruidos.
    image_gray = fix(new_impedance);
    noise = new_impedance - image_gray;
    im_cube.noise(:,:,indx) = noise;

    image_gray = uint8(image_gray);
    im_cube.images(indx,:,:) = image_gray;
    %recovery = gray2prop(image_gray,min_im, max_im, noise);
end

