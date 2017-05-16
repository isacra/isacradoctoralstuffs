function [uzl,uzl_Merged,sySeismic] = MAP_inversion(uz,usl,noise_level,L,traces,Wells)

traces = traces(1:end-1,:);

t0=cputime;
uln = log(uz);

nLn = size(uln,1);
nSeismic = size(traces,1);
nTraces = size(traces,2);

ulnl = zeros(size(uln));
uzl_Merged = zeros(size(uln));
sySeismic_Merged = zeros(size(traces));
sySeismic = zeros(size(traces));

G = acoustic_forward_matrix(usl,nLn);

% Contrói a matriz de covariancia da prior do log da impedancia
if isstruct(Wells)
wellFields = fieldnames(Wells);
wellsData= [];
for k=1:length(wellFields)
    poco = getfield(Wells,char(wellFields(k)));
    wellsData = [wellsData ; log(poco.AI) - lowPassFilter2(log(poco.AI),0.004,100,3)];
end
    sgm2_m = var(wellsData)
else
    sgm2_m = (log((Wells+10000)/10000))^2;
end



[C_m] = covariance_matrix_exp(sqrt(sgm2_m)*ones(nLn,1),L,'2');
%C_ln = C_ln*0.0045;

% Contrói a matriz de covariancia da prior da likelihood
%C_d = sgm_d*eye(nSeismic,nSeismic);
C_d = ((noise_level*mean(std(traces)))^2)*eye(nSeismic);

%C_d = sgm_d*correlationMatrix(nSeismic,1,2.5,1);
%C_d = ((0.1*mean(mean(abs(traces))))^2)*C_0d;

OPERATOR = C_m*G'*inv(G*C_m*G' + C_d);
C_lnl = C_m - OPERATOR*G*C_m;
for k = 1:nTraces 
    ulnl(:,k) = uln(:,k) + OPERATOR*(traces(:,k) - G*uln(:,k));
    sySeismic(:,k) = G*ulnl(:,k);    
    uzl_Merged(:,k) = exp(ulnl(:,k) - lowPassFilter2(ulnl(:,k),0.004,110,8) + uln(:,k));
    sySeismic_Merged(:,k) = G*log(uzl_Merged(:,k));
end


uzl = exp(ulnl);
% 

tempo = cputime - t0


