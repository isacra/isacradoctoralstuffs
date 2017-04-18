n_hor = 20;      %offset horizontal
n_ver = 20;      %offset vertical
J = 1;          %numero de templates

m_hor = (n_hor-1)/2;
m_ver = (n_ver-1)/2;

alpha_hor = [-m_hor:1:m_hor];
alpha_ver = [-m_ver:1:m_ver];

f_avg_hor = 1 - abs(alpha_hor)/m_hor;
f_avg_ver = 1 - abs(alpha_ver)/m_ver;
f_avg = [f_avg_hor', f_avg_ver'];

f_grad_hor = alpha_hor/m_hor;
f_grad_ver = alpha_ver/m_ver;
f_grad = [f_grad_hor', f_grad_ver'];

f_curv_hor = 2*abs(alpha_hor)/m_hor -1;
f_curv_ver = 2*abs(alpha_ver)/m_ver -1;
f_curv = [f_curv_hor',f_curv_ver'];


%%%%%%%%%%%%%%%%%%%Gera uma simulacao com algoritmo leandro%%%%%%%%%%%%%%
tamanho=32;
white_noise = randn(tamanho,tamanho);
randomInt = randi([0,255],tamanho,tamanho,tamanho);

[corr1] = construct_correlation_function_correct(2,10,randomInt);
%[corr2] = construct_correlation_function_correct(10,2,white_noise);

[ simulation ] = FFT_MA_3D( corr1, randomInt );
%[ simulation2 ] = FFT_MA_3D( corr1, randomInt);
 im_cube_class = ImageCubeClass;
for i=1:32
        im_cut = simulation(:,:,i);
        [img, im_cube_class] = prop2gray(im_cut,im_cube_class);
        
end



figure
imagesc(simulation)
title('Simula��o FFMA')
figure
%imagesc(simulation2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strt_x = 1;
strt_y = 1;
dlt_x = n_hor ;
dlt_y = n_ver ;
iml = simulation(strt_x:dlt_x,strt_y:dlt_y);
figure;imagesc(iml);
pattern_node = iml;

S1 = sum(f_curv' * pattern_node);
S2 = sum(f_avg' * pattern_node);
S3 = sum(f_grad' * pattern_node);

