function [ ai,seis,correlation ] = geoms_ai_to_seis( ai, wavelet, seis_original,mask)

% converter impedancia acustica $ai$ para sismica convolvendo com $wavelet$
% e calcula correlacao com a simica original $seis_original$. Se qualquer
% coisa for passada em $cut$, calcula tudo somente onde $ai$>0
ai(isnan(ai))=0;

if isvector(ai)
    ai = reshape(ai,707,251)';
end

if nargin>3
       
    for i=1:size(mask,2)
        ini = find(mask(:,i),1,'first');
        fini = find(mask(:,i),1,'last');
        ai(1:ini,i) = ai(ini+1,i);
        ai(fini:end,i) = ai(fini-1,i);
    end
end

refl_geoms_tit = impedancia2refletividade(ai);
seis_geoms_tit = conv2(refl_geoms_tit,wavelet);
seis = seis_geoms_tit(13:262,:);
seis_original = seis_original(1:end-1,:);

if nargin>3
    mask = mask(1:end-1,:);
    seis2 = seis(mask);
    seis_original2 = seis_original(mask);
end;

correlation = corr(seis_original2(:),seis2(:));


end

