function [stratigraphic_grid,real_grid_grid,stratigraphic_grid_indexes] = stratigraphic_interpolation(inline,horizontes)
%interpolacao de horizontes stratigraficos - horizontalizacao
% $inline$ a ser horizontalizado
% $horizontes$ a ser interpolados


nHorizons = size(horizontes,1);
nTraces = size(horizontes,2);
nSeismic = size(inline,1);

dTs = diff((horizontes));
stratigraphic_grid_indexes = zeros(sum(round(max(dTs')))+1,nTraces);
for trace=1:nTraces
    first=1;
    for region=1:nHorizons-1    
        dT = round(max(dTs(region,:))); 
        stratigraphic_grid_indexes(first:first+dT-1,trace) = horizontes(region,trace) + (dTs(region,trace)/dT)*(0:dT-1);
        first = first + dT;
    end
end
stratigraphic_grid_indexes(first,:) = horizontes(end,:);




[x,y] = meshgrid([1:size(inline,1)],[1:size(inline,2)]);
data = inline';

xq = stratigraphic_grid_indexes';
[~,yq] = meshgrid(1:size(stratigraphic_grid_indexes,1),1:size(stratigraphic_grid_indexes,2));

stratigraphic_grid = interp2(x,y,data,xq,yq,'nearest');
stratigraphic_grid = stratigraphic_grid';


% VOLTAR PARA O REAL

y = 1:size(stratigraphic_grid_indexes,1);
xq=1:size(inline,1);
for trace=1:nTraces
    if trace==304
        para=1;
    end
    x = stratigraphic_grid_indexes(:,trace);    
    real_grid_indexes(:,trace) = interp1(x,y',xq');
end

[x,y] = meshgrid([1:size(stratigraphic_grid,1)],[1:size(stratigraphic_grid,2)]);
data = stratigraphic_grid';

xq = real_grid_indexes';
[~,yq] = meshgrid(1:size(inline,1),1:size(inline,2));
real_grid_grid = interp2(x,y,data,xq,yq,'nearest');
real_grid_grid = real_grid_grid';






