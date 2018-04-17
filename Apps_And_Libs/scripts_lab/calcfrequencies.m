function [] = calcfrequencies(sintetic,blured,cnn,pos)
    num_freqs = 200;
    FS = 1/0.004;
    sintetic_fourier = fft(sintetic - mean(sintetic),[],1);
    bluer_fourier = fft(blured - mean(blured),[],1);
    cnn_fourier = fft(cnn - mean(cnn),[],1);

    sintetic_fourier = mean(abs(sintetic_fourier),2);
    bluer_fourier = mean(abs(bluer_fourier),2);
    cnn_fourier = mean(abs(cnn_fourier),2);
    
    sintetic_fourier = sintetic_fourier(1:num_freqs/2 +1);
    bluer_fourier = bluer_fourier(1:num_freqs/2 +1);
    cnn_fourier = cnn_fourier(1:num_freqs/2 +1);
    
    f = FS*(0:(num_freqs/2))/num_freqs;

    figure;
    %subplot(4,4,pos)
    hold on; plot(f,bluer_fourier,'b');
    hold on; plot(f,cnn_fourier,'k');
    plot(f, sintetic_fourier, 'r');
    xlabel('Hz')
    ylabel('Magnitude')
    legend('Inversion','CNN', 'Synthetic');
    
    %Plot percentual de frequência recuperado
    figure;
    perc = cnn_fourier*100./(sintetic_fourier);
    plot(f(2:end),perc(2:end))
    xlabel('Frequency (Hz)')
    ylabel('Magnitude Recoverying Percentage (%)')
end