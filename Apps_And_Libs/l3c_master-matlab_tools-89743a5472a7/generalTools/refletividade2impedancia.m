function imp = refletividade2impedanciaMelhor(refl, firstImp)
% refl - refletividade
%   Deve ser matriz ou vetor coluna, caso matriz � executado em cada coluna
% firstImp - primeiro valor de imped�ncia (normalmente de 6000 a 12000)

    imp = [firstImp ; repmat(firstImp,250,1).*exp(2*cumsum(refl))];

   
end
