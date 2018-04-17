function [images] = crop_and_print(cube,path)

%Esta função recebe um cubo de imagens de qualquer tamanho e recorta cada
%imagem no tamanho desejado. Os cortes são sem sobreposição das imagens. As
%imagens cortadas são salvar em formato jpg com indicado pela variavel path
    for indx=1:size(cube.gray_images,3)
        img = cube.gray_images(:,:,indx);
        %img = cube.images(:,:,indx);
        imwrite(uint8(img),strcat(path,strcat('Image',int2str(indx),int2str(indx),int2str(indx)),'.jpg'));
        
        %imwrite(uint16(img),strcat(path,strcat('Image',int2str(indx),int2str(indx),int2str(indx)),'.png'));
%         imgs = mat2tiles(img,[32,32]);
        [lc cc] = size(imgs);
        n= 1;
        for i =1 : lc
           for j=1 : cc
               imwrite(uint8(imgs{i,j}),strcat(path,strcat(int2str(indx),'_',int2str(i),'_',int2str(j)),'.jpg'));
%                if size(imgs{i,j},1) == 32 && size(imgs{i,j},2)==32
%                   %images(n,:,:) = imgs{i,j};
%                   n = n+1;
%                end
            
           end
       end

    end
images = cube.gray_images;
end