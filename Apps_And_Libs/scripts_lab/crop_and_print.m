function [images] = crop_and_print(img,path,indx)

    imgs = mat2tiles(img,[32,32]);
    [l c] = size(imgs);
    n= 1;
    for i =1 : l
       for j=1 : c
           imwrite(imgs{i,j},strcat(path,strcat(int2str(indx),'_',int2str(i),'_',int2str(j)),'.jpg'));
           if size(imgs{i,j},1) == 32 && size(imgs{i,j},2)==32
              images(n,:,:) = imgs{i,j};
              n = n+1;
           end
       end
    end


end