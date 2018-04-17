ai = load_geoms_cube('/home/isaac/Documents/Dados_Doutorado/Cubo_Stanford/acoustic_impedance.dat',[150 200 200]);
ai_cubo = reshape(ai,200, 200*150);
ai_cubo = 1000*ai_cubo;
refletividade = impedancia2refletividade([ai_cubo; zeros(30000,1)']);

[fid, ~] = fopen('/home/isaac/Documents/Dados_Doutorado/wavelets/rick4ms.wvlt');
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
wavelet4ms = textscan(fid,'%f');
wavelet4ms = wavelet4ms{1};


traces_sintetico = conv2(refletividade,wavelet4ms,'same');
imp_low = lowPassFilter2(ai_cubo,4, 100,4);
traces_sintetico_ruido = traces_sintetico;


[uzl2,uzl2_Merged,sySeismic] = MAP_inversion(imp_low,wavelet4ms,0.05,1.5,traces_sintetico_ruido,250);

figure; imagesc(ai_cubo(:,1:1200))
figure; imagesc(uzl(:,1:1200))
fft_analisys(uzl(:,1:200),ai_cubo(:,1:200));
figure; imagesc(uzl(:,1:1200))
figure; plot(ai_cubo(:,150))

%%%%Prepare data for CNN
y_train = reshape(ai_cubo,200,200,150);
x_train = reshape(uzl,200,200,150);
x_test = x_train(:,:,end-3:end);
y_test = y_train(:,:,end-3:end);
x_train = reshape(uzl,200,200,150);
x_train = x_train(:,:,1:end-4);
y_train = y_train(:,:,1:end-4);
[x_train, y_train] = norm_data(x_train,y_train);
[x_test, y_test] = norm_data(x_test,y_test);
[gray_lr, gray_hr] = format_data_to_cnn(x_train,y_train);

n=1; inv_imgs =[]; truth_imgs = [];
for indx=1:size(x_train,3)
imgshr = mat2tiles(y_train(:,:,indx),[40,40]);imgslr = mat2tiles(x_train(:,:,indx),[40,40]); [lc cc] = size(imgshr);
for i =1 : lc
for j=1 : cc
inv_imgs(:,:,n) = imgslr{i,j}; truth_imgs(:,:,n) = imgshr{i,j};
n= n+1;
end
end
end
