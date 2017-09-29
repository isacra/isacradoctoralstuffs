function [layers] = resnets (layer, numfilt, filtro)
    
    layers =[
        layer
        convolution2dLayer(filtro,numfilt,'NumChannels',1)
        reluLayer()
        convolution2dLayer(filtro,numfilt,'NumChannels',1)
        
    ];
end