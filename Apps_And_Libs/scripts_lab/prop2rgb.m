function prop2rgb = convolve(image)
    
    C = colormap;
    L = size(C,1);
    Gs = round(interp1(linspace(min(image(:)),max(image(:)),L),1:L,image));
    H1 = reshape(C(Gs,:),[size(Gs) 3]);
    minRGB = min(min(H1));
    maxRGB = max(max(H1));
    imR = H1(:,:,1) - minRGB(1); imR = 256*imR/maxRGB(1);
    imG = H1(:,:,2) - minRGB(2); imG = 256*imG/maxRGB(2);
    imB = H1(:,:,3) - minRGB(3); imB = 256*imB/maxRGB(3);
    
    prop2rgb = uint8(cat(3,imR, imG, imB));
end