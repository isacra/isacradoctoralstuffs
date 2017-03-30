function [ fft_images_instances ] = fourier_transform(images)

    [~,~,p] = size(images);
  
    for i=1:p
        image = images(:,:,i);
        four_res = fft2(mat2gray(image));

        magnitudeY = log(abs(four_res)+1);
        phase = unwrap(angle(four_res));
        fft_instance = FFTclass;

        fft_instance.magnitude = magnitudeY;
        fft_instance.phase  = phase;
        fft_instance.frequence  = four_res;
        fft_images_instances(i) = fft_instance;
       
    end
end