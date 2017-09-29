% Este arquivo carrega os dados a serem usados como referencia na otimizacao
function [ cube_high, cube_low, gray_hr, gray_lr] = gen_cunhas( num_cunhas )

    deslocamento_max = 32;
    profundidade_max = 32;
    cube_high =[];
    cube_low = [];
    gray_hr = [];
    gray_lr = [];

    idx = 1;

    in_val = rand(1,1);
    out_val = rand(1,1);
    
    %Valores de referencia para treinamento
    max_val = 3500;
    min_val = 2500;

    %Valores de referencia para teste
    %max_val = 7500;
    %min_val = 6500;
    
    for image=1:num_cunhas


    % if mod(image,2) == 0
    %     max_val = 2500;
    %     min_val = 1500;
    % else 
    %     max_val = 4500;
    %     min_val = 3500;
    % end

    espessura_cunha_max = 10 + rand*15;
    base_cunha = 15 + rand*15;
    tamanho_cunha = 0.5 + rand*0.40;

    modulo = randi(100,1);
    
    % Calcula a espessura da cunha ao longo do deslocamento
    for coluna = 1:deslocamento_max
        espessura = espessura_cunha_max - ( (espessura_cunha_max / (tamanho_cunha * deslocamento_max)) * (coluna - 1) );
        if espessura < 0
            espessura_cunha(coluna) = 0;
        else
            espessura_cunha(coluna) = espessura;
        end;
    end;



    for coluna = 1:deslocamento_max
          
        % Calcula tempo ate atingir determinada profundidade, baseado na velocidade do meio
        topo_cunha = base_cunha - espessura_cunha(coluna);
        if topo_cunha ~= base_cunha
            tempo_ate_topo_cunha(coluna) = 2 * (1000 * topo_cunha / max_val); % 1000 de milissegundos
            tempo_na_cunha(coluna) = tempo_ate_topo_cunha(coluna) + 2 * (1000 * (base_cunha - topo_cunha) / min_val);
            tempo_depois_cunha(coluna) = tempo_na_cunha(coluna) + 2 * (1000 * (profundidade_max - base_cunha) / max_val);
        else
            tempo_ate_topo_cunha(coluna) = 0;
            tempo_na_cunha(coluna) = 0;
            tempo_depois_cunha(coluna) = 2 * (1000 * profundidade_max / max_val);
        end;
        % Calcula valores de impedância em uma matriz Deslocamento x Tempo
        tempo_max = tempo_depois_cunha(1);
        for tempo = 1:tempo_max
            if tempo <= tempo_ate_topo_cunha(coluna)
                impedancia_tempo_deslocamento(tempo,coluna) = 2.6 * max_val;
            elseif tempo <= tempo_na_cunha(coluna)
                impedancia_tempo_deslocamento(tempo,coluna) = 2.4 * min_val;
            else
                impedancia_tempo_deslocamento(tempo,coluna) = 2.6 * max_val;
            end;
        end;
        for linha = 1:profundidade_max
       
        % Armazema matriz de impedância Deslocamento x Profundidade
            if modulo < 33
                if linha >= topo_cunha && linha < base_cunha
                    %
                    impedancia_profundidade_deslocamento(linha,coluna) = 2.4 * min_val;
                else

                    impedancia_profundidade_deslocamento(linha,coluna) = 2.6 * max_val;
                end;
            
            else if modulo >=33 && modulo < 66
                if linha >= topo_cunha && linha < base_cunha
                    impedancia_profundidade_deslocamento(linha,coluna) = 2.6 * max_val;
                    
                else

                    impedancia_profundidade_deslocamento(linha,coluna) = 2.4 * min_val;
                end;
                else if modulo>=66
                        if linha >= topo_cunha && linha < base_cunha
                            impedancia_profundidade_deslocamento(linha,coluna) = 0.3;
                            
                        else
                            
                            impedancia_profundidade_deslocamento(linha,coluna) = 0.7;
                        end;
                    end
                end
            end
        end;
    end;

        for i = 1 : 4
            
            if (length(find(impedancia_profundidade_deslocamento==0.7)) + length(find(impedancia_profundidade_deslocamento==0.3))) == 1024
                cube_high(:,:,idx) = imrotate(impedancia_profundidade_deslocamento, i*90);
                gray_hr(idx,:) = reshape(cube_high(:,:,idx),1,1024);
                
                cube_low(:,:,1,idx) = lowPassFilter2(cube_high(:,:,idx),4,100,20);
                gray_lr(:,:,1,idx) = cube_low(:,:,1,idx);
                idx = idx + 1;
            else
                cube_high(:,:,idx) = imrotate(impedancia_profundidade_deslocamento, i*90);
                gray_hr(idx,:) = reshape(mat2gray(cube_high(:,:,idx)),1,1024);
                
                cube_low(:,:,1,idx) = lowPassFilter2(cube_high(:,:,idx),4,100,20);
                gray_lr(:,:,1,idx) = mat2gray(cube_low(:,:,1,idx));
                idx = idx + 1;
            end
        end
    end
      
end