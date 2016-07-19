function [ refletividade ] = impedancia2refletividadeMelhor( impedancia )
%   Deve ser matriz ou vetor coluna, caso matriz é executado em cada coluna    

    refletividade = (impedancia(2:end,:)-impedancia(1:end-1,:))./(impedancia(1:end-1,:)+impedancia(2:end,:));
    refletividade(isinf(refletividade)) = 0;
    refletividade(isnan(refletividade)) = 0;
    refletividade(refletividade==-1) = 0;