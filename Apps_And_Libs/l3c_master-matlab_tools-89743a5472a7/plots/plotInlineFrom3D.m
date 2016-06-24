function plotInlineFrom3D(data, inl, ninlines)
%PLOTINLINE imagesc o inline desejado de uma matriz traces em $data$ carregada de
%um segy - recebe o $inl$ desejado e número de inlines do cubo


	if nargin < 3
        ninlines = 315;
    end
    figure
    imagesc(data(:,(inl-1)*ninlines+1:inl*ninlines))

end

