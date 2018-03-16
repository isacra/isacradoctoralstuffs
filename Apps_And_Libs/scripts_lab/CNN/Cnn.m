% 
      [cunhas_hr, cunhas_lr, gray_hr, gray_lr] = gen_cunhas(1);
% 
    layers = [ ...
        imageInputLayer([32 32 1])
        
        convolution2dLayer( 5, 50, 'Stride', 1, 'Padding', 1)
        maxPooling2dLayer(2,'Stride',2);
        dropoutLayer(0.2,'Name','dropout1')
        reluLayer
        convolution2dLayer( 3, 50, 'Stride', 1, 'Padding', 1)
        maxPooling2dLayer(2,'Stride',2);
        %dropoutLayer(0.2,'Name','dropout2')
        reluLayer
        fullyConnectedLayer(1024)
        regressionLayer
        
        ];

    options = trainingOptions('sgdm','InitialLearnRate',0.001, ...
        'MaxEpochs',100,'MiniBatchSize',32);

    net = trainNetwork(gray_lr,gray_hr,layers,options);
    save 'trained_net_with_dropout.mat' net
%    
% %% F
%load trained_net_1.mat
%load net_result_3_nov.mat
[cunhas_hr, cunhas_lr,im_hr,im_lr,randI] = gen_cunhas(1);
%im_pred = predict(net,im_lr);

%[im_hr,im_lr] = gen_cunhas_ang(4); randI=[4, 4, 4, 4];

im_pred = predict(net,im_lr);

% load workspace_teste.mat
% im_test = [];
k=1;

fig = figure;
for i=1:4
   k=4*i-3;
   sintetic = reshape(im_hr(i,:),32,32);
   blured = im_lr(:,:,i);
   cnn = reshape(im_pred(i,:),32,32);
   %subplot(1,2,1);imagesc(sintetic);subplot(1,2,2); imagesc(blured);set(gcf,'color','w')
   
   
   cnn_fourier = fourier_transform(cnn);
   sintetic_fourier = fourier_transform(sintetic);
   blured_fourier = fourier_transform(blured);

   [cnnmatches, cnn_inds] = fourier_indices_calculate(cnn, sintetic, cnn_fourier,sintetic_fourier);
   [bluredmatches, blured_inds] = fourier_indices_calculate(blured, sintetic, blured_fourier,sintetic_fourier);
   
   colormap(gray)
   set(gcf,'color','w')
   
   subplot(4,4,k)
   imagesc(sintetic)
   colorbar
   title('Synthetic');
   
   
   subplot(4,4,k+1)
   
   imagesc(blured)
   colorbar
   mse = MRSE(blured,sintetic);
   tit = strcat('Blurred (',mat2str(randI(i)),' Hz)');
   text = strcat('MSE.: ',mat2str(mse));
   text2 = strcat('FFTI.: ',mat2str(blured_inds));
   title({tit,text,text2});
   
   subplot(4,4,k+2)
   imagesc(cnn)
   colorbar
   mse = MRSE(cnn,sintetic);
   tit = 'CNN';
   text = strcat('MSE.: ',mat2str(mse));
   text2 = strcat('IFFT.: ',mat2str(cnn_inds));
   title({tit,text,text2});
   
   calcfrequencies(sintetic,blured,cnn,k+3);
   
   %savefig(fig,strcat(num2str(i),'.fig'))
end

