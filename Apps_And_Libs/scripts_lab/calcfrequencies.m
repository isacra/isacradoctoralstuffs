function [] = calcfrequencies(sintetic,blured,cnn,pos)
    FS = 1/0.004;
    sintetic_fourier = fft(sintetic - mean(sintetic),[],1);
    bluer_fourier = fft(blured - mean(blured),[],1);
    cnn_fourier = fft(cnn - mean(cnn),[],1);

    sintetic_fourier = mean(abs(sintetic_fourier),2);
    bluer_fourier = mean(abs(bluer_fourier),2);
    cnn_fourier = mean(abs(cnn_fourier),2);
    
    sintetic_fourier = sintetic_fourier(1:32/2 +1);
    bluer_fourier = bluer_fourier(1:32/2 +1);
    cnn_fourier = cnn_fourier(1:32/2 +1);
    
    f = FS*(0:(32/2))/32;

    %figure;
    subplot(4,4,pos)
    hold on; plot(f,bluer_fourier,'b');
    hold on; plot(f,cnn_fourier,'c');
    plot(f, sintetic_fourier, 'r');
    xlabel('Hz')
    ylabel('Magnitude')
    legend('Blurred','CNN', 'Synthetic');
end