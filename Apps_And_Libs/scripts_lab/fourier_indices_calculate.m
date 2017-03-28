function [ indices ] = fourier_indices_calculate(cnn_fourier, original_fourier)
    [~,cImCnn]  = size(cnn_fourier);
    [~,cImOrig] = size(original_fourier);
    for i=1:cImCnn
        imCnn = cnn_fourier(i).frequence;
        for j = 1 : cImOrig
            imOrig = original_fourier(j).frequence;
            mult1 = imCnn.*imOrig;
            numerator = (sum(mult1(:))) - (32*mean2(imCnn)*mean2(imOrig));
            
            abs1 = abs(imCnn);
            abs2 = abs(imOrig);
            
            T1 = sum(abs1(:))^2 - 32*( mean2(imCnn)^2);
            T2 = sum(abs2(:))^2 - 32*( mean2(imOrig)^2);

            res(i,j) = numerator / (T1*T2);
        end
    end
end