function gen_images(database_name, im_width, im_hight, im_res_size)
hr_dir = strcat(database_name,'/Images/',database_name,'_hr/*.jpg');
lr_dir = strcat(database_name,'/Images/',database_name,'_lr/*.jpg');
delete(hr_dir);
delete (lr_dir);
mkdir(hr_dir);
mkdir (lr_dir);

images = [];
randomIndx = randi(239,[1,32]);

images_hr_test = impedance_cut(:,:,randomIndx);
images = inversion_cut(:,:,randpasomIndx);
impedance_cut(:,:,randomIndx) = [];
inversion_cut(:,:,randomIndx) = [];

for i=1:size(impedance_cut,3)
    
    imwrite(impedance_cut(:,:,i),strcat('Images/sintetico_hr/',int2str(i),'.jpg'));
    imwrite(inversion_cut(:,:,i),strcat('Images/sintetico_lr/',int2str(i),'.jpg'));    
end
for i=1:size(images_lr_test,3)
    images(i,:,:)= images(:,:,i);
    
end
save 'images.mat' images;



end