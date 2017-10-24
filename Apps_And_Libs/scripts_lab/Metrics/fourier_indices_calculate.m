function [ ims_matchs, indices ] = fourier_indices_calculate(images, imagesOrig, cnn_fourier, original_fourier)
    [~,cImCnn]  = size(cnn_fourier);
    [~,cImOrig] = size(original_fourier);
    k = 32;
    for i=1:cImCnn
        imCnnFourier = cnn_fourier(i).frequence;
        imCnn = mat2gray(images(:,:,i));
        
        ims_matchs{i}.immatch = 0;
        ims_matchs{i}.fft_param = 0;
        
        imOrigFourier = original_fourier(i).frequence;
        imOrig = mat2gray(imagesOrig(:,:,i));
        
        mult1 = imCnn.*imOrig;
        
        numerator = (sum(mult1(:)) - k*mean2(imCnnFourier)*mean2(imOrigFourier))^2;
        
        abs1 = abs(imCnn);
        abs2 = abs(imOrig);
        
        T1 = sum(abs1(:).^2) - k*( mean2(imCnnFourier)^2);
        T2 = sum(abs2(:).^2) - k*( mean2(imOrigFourier)^2);
        
        indices(i) = numerator / (T1*T2);
        indices(i) = round(abs(indices(i)),4);
        if (ims_matchs{i}.fft_param < indices(i))
            ims_matchs{i}.fft_param = indices(i);
            %ims_matchs{i}.immatch = j;
        end
        
%         for j = 1 : cImOrig
%             imOrigFourier = original_fourier(j).frequence;
%             imOrig = mat2gray(imagesOrig(:,:,j));
%                         
%             mult1 = imCnn.*imOrig;
%             
%             numerator = (sum(mult1(:)) - k*mean2(imCnnFourier)*mean2(imOrigFourier))^2;
%             
%             abs1 = abs(imCnn);
%             abs2 = abs(imOrig);
%             
%             T1 = sum(abs1(:).^2) - k*( mean2(imCnnFourier)^2);
%             T2 = sum(abs2(:).^2) - k*( mean2(imOrigFourier)^2);
% 
%             indices(i,j) = numerator / (T1*T2);
%             if (ims_matchs{i}.fft_param < indices(i,j))
%                 ims_matchs{i}.fft_param = indices(i,j);
%                 ims_matchs{i}.immatch = j;
%             end
%         end
    end
end