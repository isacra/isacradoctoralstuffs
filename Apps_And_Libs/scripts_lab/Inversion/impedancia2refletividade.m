function [ refletividade ] = impedancia2refletividade( impedancia )
%   Deve ser matriz ou vetor coluna, caso matriz é executado em cada coluna    
    refletividade  = zeros(size(impedancia,1)-1,size(impedancia,2));
    for j=1:size(impedancia,2)
        [refletividade(:,j)] = impedancia2refletividade1(impedancia(:,j));
    end
    
end


function [ refletividade ] = impedancia2refletividade1( impedancia )
% Recebe os valores de impedancia de um poco, valores em funcao do tempo.
% Retorna a refletividade desses valores em funcao do tempo.
tempo_max = length(impedancia) - 1;
for tempo = 1:tempo_max
    divisor = impedancia(tempo+1) + impedancia(tempo);
	if divisor == 0
        refletividade(tempo) = 0;
    else
		refletividade(tempo) = (impedancia(tempo+1) - impedancia(tempo)) / divisor;
	end;
	if refletividade(tempo) == -1
		refletividade(tempo) = 0;
	end;
end;
end