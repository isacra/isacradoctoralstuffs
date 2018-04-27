wells_train_indxs = randperm(3000,100);
wells_test_indxs = randperm(3000,20);

ai_hr = ai_truth(:,wells_train_indxs);
ai_lr = ai_inversion(:,wells_train_indxs);

x_test_corte_x = ai_inversion(:,wells_test_indxs);
y_test_corte_x = ai_truth(:,wells_test_indxs);

seismic = traces_sintetico_ruido(:,wells_train_indxs);
seismic_test_corte_x = traces_sintetico_ruido(:,wells_test_indxs);

save images_treino.mat ai_hr ai_lr seismic
save images_test_corte_x.mat y_test_corte_x x_test_corte_x seismic_test_corte_x

%teste para o cubo inteiro
y_test_corte_x = ai_truth;
x_test_corte_x = ai_inversion;
seismic_test_corte_x = traces_sintetico_ruido;
save image_teste_corte_x.mat y_test_corte_x x_test_corte_x seismic_test_corte_x