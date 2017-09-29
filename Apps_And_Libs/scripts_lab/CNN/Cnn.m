
    [cunhas_hr, cunhas_lr, gray_hr, gray_lr] = gen_cunhas(500);
    %load workspace_cunha.mat

%     for i=1:size(hr_im_cube_class.images,3)
%        gray_hr(i,:) = reshape(mat2gray(hr_im_cube_class.images(:,:,i)),1,1024);
%        gray_lr(:,:,1,i) = mat2gray(lr_im_cube_class.images(:,:,i));
%     end
    layers = [ ...
        imageInputLayer([32 32 1])
        
        convolution2dLayer( 5, 50, 'Stride', 1, 'Padding', 1)
        maxPooling2dLayer(2,'Stride',2);
        reluLayer
        convolution2dLayer( 3, 50, 'Stride', 1, 'Padding', 0)
        maxPooling2dLayer(2,'Stride',2);
        reluLayer
        fullyConnectedLayer(1024)
        regressionLayer
        
        ];

    options = trainingOptions('sgdm','InitialLearnRate',0.001, ...
        'MaxEpochs',100,'MiniBatchSize',32);

    net = trainNetwork(gray_lr,gray_hr,layers,options);
    save 'trained_net.mat' net
   
%% F
[~,~,im_hr,im_lr] = gen_cunhas(1);
im_pred = predict(net,im_lr);

%[im_hr,im_lr] = gen_cunhas_ang(4);
%im_pred = predict(net,im_lr);

% load workspace_teste.mat
% im_test = [];
for i=1:4
%    im_test(:,:,1,1) =  gray_lr(:,:,i));
%    im_pred = predict(net,im_test);
   fig = figure;
   subplot(1,3,1)
   imagesc(reshape(im_hr(i,:),32,32))
   colorbar
   title('HIGH');
   subplot(1,3,2)
   imagesc(im_lr(:,:,i))
   colorbar
   title('LOW');
   subplot(1,3,3)
   imagesc(reshape(im_pred(i,:),32,32))
   colorbar
   title('CNN');
   savefig(fig,strcat(num2str(i),'.fig'))
end
