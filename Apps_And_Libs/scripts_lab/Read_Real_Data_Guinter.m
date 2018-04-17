function[x_low, x_truth] = Read_Real_Data_Guinter()

cube_width = 550;
cube_hight = 630;
cube_depth = 173250/550;

%%%Read data for synthetic truth impedance%%%%%%%%%%%%%%
imp_hr_dir = '/home/isaac/isaac_dados_reais/Timpedance_sintetica.sgy';
segy_structure = read_segy_file(imp_hr_dir);
imp_truth_resampled = resample(segy_structure.traces,1,8);
cube_truth =  reshape(imp_truth_resampled , 251,315,550);

%%%Read data for synthetic inverted impedance%%%%%%%%%%%%%%
imp_lr_dir = '/home/isaac/isaac_dados_reais/inverted_impedance_sintetico.sgy';
segy_structure_low =  read_segy_file(imp_lr_dir);
imp_low_resampled = resample(segy_structure_low.traces,1,8);
cube_low =  reshape(imp_low_resampled, 251,315,550);

%%%Read data for real inverted impedance%%%%%%%%%%%%%%

% imp_lr_real_dir = '/home/isaac/isaac_dados_reais/Ip_TM_invertida_real.sgy';
% 
% segy_structure_low_real = read_segy_file(imp_lr_real_dir);
% imp_low_real_resampled = resample(segy_structure_low_real.traces,1,8); 
% cube_low_real =  reshape(imp_low_resampled, 251,315,550);

%%%Read data for seismic impedance%%%%%%%%%%%%%%
% imp_synt_sism_dir = '/home/isaac/isaac_dados_reais/Timpedance_Filt-10-60_seis_sintetica.sgy';
% segy_structure_seis = read_segy_file(imp_synt_sism_dir);
% imp_seism_resampled = resample(segy_structure_seis.traces,1,8); 
% cube_seism_synt =  reshape(imp_seism_resampled, 251,315,550);

%%%Read data low frequency%%%%%%%%%%%%%%
% imp_lowfreq_dir = '/home/isaac/isaac_dados_reais/Timpedance_HC-6_low_freq.sgy';
% segy_structure_lowfreq = read_segy_file(imp_lowfreq_dir);
% imp_lowfreq_resampled = resample(segy_structure_lowfreq.traces,1,8); 
% cube_lowfreq =  reshape(imp_lowfreq_resampled, 251,315,550);


x_truth = cube_truth;%(155:200,1:170,:);
x_low = cube_low;%(155:200,1:170,:);

%x_low_test = cube_low_real(155:200,1:170,:);


figure; imagesc(cube_truth(:,:,100))
figure; imagesc(cube_low(:,:,100))
%figure; imagesc(cube_low_real(:,:,100))
%figure; imagesc(cube_seism_synt(:,:,100))
%figure; imagesc(cube_lowfreq(:,:,100))

end