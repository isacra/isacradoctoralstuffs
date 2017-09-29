%dirImgs ='Resultado/'; 
%mkdir 'Resultados/ImagensSaida/'
clear all;
result_dir_name ='Resultado/'; 
lr_dir_name = 'cunha_lr_test/';
hr_dir_name = 'cunha_hr_test/'; 

imagefiles = dir(strcat(result_dir_name,'*.jpg'));
hr_imagesfiles = dir(strcat(hr_dir_name,'*.jpg'));
lr_imagesfiles = dir(strcat(lr_dir_name,'*.jpg'));

nfiles = length(imagefiles);
filesNames = natsort({imagefiles.name});
cnn_images = [];
for ii=1:nfiles
   currentfilename = char(filesNames(ii));
   currentfilename = strcat(result_dir_name,currentfilename);
   currentimage = imread(currentfilename);
   
   cnn_images(:,:,ii) = currentimage;
end

nfiles = length(hr_imagesfiles);
filesNames = natsort({hr_imagesfiles.name});
sintetic_images = [];
for ii=1:nfiles
   currentfilename = char(filesNames(ii));
   currentfilename = strcat(hr_dir_name,currentfilename);
   currentimage = imread(currentfilename);
   
   sintetic_images(:,:,ii) = currentimage;
end

nfiles = length(lr_imagesfiles);
filesNames = natsort({lr_imagesfiles.name});
low_images = [];
for ii=1:nfiles
   currentfilename = char(filesNames(ii));
   currentfilename = strcat(lr_dir_name,currentfilename);
   currentimage = imread(currentfilename);
   
   low_images(:,:,ii) = currentimage;
end


load 'workspace_cunha.mat'



for i=1:32
    figure;
    subplot(2,3,1)
     imagesc( hr_im_cube_test.gray_images(:,:,i))
     colorbar
     title('HIGH');
     
     subplot(2,3,2)
     imagesc(low_images(:,:,i))
     colorbar
     title('LOW');
     
     subplot(2,3,3)
     imagesc( cnn_images(:,:,i))
     colorbar
     title('CNN');

end





% 
% screenSize = get(0,'screensize');
% screenWidth = screenSize(3);
% screenHeight = screenSize(4);

% for i = 1 : num_imgs
%    
%     figure('Position', [0 0 screenWidth screenHeight]);
%     set(gcf, 'color','w')
%     colorbar
% 
%     set(gcf,'Visible','on');
%     
%     cnn_accoustic_impedance = gray2prop(cnn_images(:,:,i), hr_im_cube_test.images(:,:,i),Centroides);
%     %hr_accustic_impedance = gray2prop(sintetic_images(:,:,i), hr_im_cube_test,true,i);
%     hr_accustic_impedance = hr_im_cube_test.images(:,:,i);
%     %lr_accoustic_impedance = gray2prop(low_images(:,:,i), lr_im_cube_test,true,i);
%     lr_accoustic_impedance = lr_im_cube_test.images(:,:,i);
%     diffim = cnn_accoustic_impedance - hr_accustic_impedance;
%     
%      subplot(2,3,1)
%      imagesc(hr_accustic_impedance)
%      colorbar
%      title('IA Sintética');
%      
%      subplot(2,3,2)
%      imagesc(cnn_accoustic_impedance)
%      colorbar
%      title('IA Rede');
%      
%      subplot(2,3,3)
%      imagesc(diffim)
%      colorbar
%      title('Diferença');
%      
%      subplot(2,3,4)
%      histogram(hr_accustic_impedance)
%      title('Hist. 1');
%      
%      subplot(2,3,5)
%      histogram(cnn_accoustic_impedance)
%      title('Hist. 2');
%      
%      subplot(2,3,6)
%      imagesc(lr_accoustic_impedance)
%      colorbar
%      axis tight
%      %print(gcf,  strcat(dirImgs,mat2str(i)), '-dpng', '-r200');
%      saveas(gcf, strcat(dirImgs,mat2str(i)),'png')
% end


