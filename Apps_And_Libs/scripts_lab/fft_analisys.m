function fft_analisys(varargin)
%%%%OBS Esta função precisa ser generica o suficiente para    


    c =length(varargin);
    [l c num_images] = size(varargin{c});
    %Número de linhas da imagem
    num_freqs = size(varargin{1},2);
    
    for i = 1:num_images
        im1 = varargin{1};
        im1 = im1(:,:,i);
        
        im2 = varargin{2};
        im2 = im2(:,:,i);
                
        FS = 1/0.004;
        sintetic_fourier = fft(im1 - mean(im1),[],1);
        bluer_fourier = fft(im2 - mean(im2),[],1);
        

        sintetic_fourier = mean(abs(sintetic_fourier),2);
        bluer_fourier = mean(abs(bluer_fourier),2);
        
    
        sintetic_fourier = sintetic_fourier(1:num_freqs/2 +1);
        bluer_fourier = bluer_fourier(1:num_freqs/2 +1);
        
    
        f = FS*(0:(num_freqs/2))/num_freqs;

    %figure;
        figure;
        hold on; plot(f,bluer_fourier,'b');
    
        plot(f, sintetic_fourier, 'r');
        xlabel('Hz')
        ylabel('Magnitude')
        legend('Truth','Inversion');
        
    end
    
    
end