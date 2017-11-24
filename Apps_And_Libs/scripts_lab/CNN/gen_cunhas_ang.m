function [gray_hr, gray_lr] = gen_cunhas_ang( num_cunhas )
for i =1 : num_cunhas
    xp1 =randi(10);
    yp1 =randi(10);
    
    xp2 = (xp1^(randi(2)-1)+rand*15);
    yp2 =  yp1+rand*10;
    
    xp3 = xp1^(randi(2)-1)+rand*15;
    yp3 = yp1+rand*5;
    
    
    v = [xp1 yp1; xp2 yp2; xp3 yp3 ];
    f = [1 2 3];
    fi = figure;
    p =patch('Faces',f,'Vertices',v,'FaceVertexCData',[0],'FaceColor','flat');
    
    F = getframe(gca);
 
    im = image(F.cdata);
 
    im = getimage(gca);
    im = rgb2gray(im);
    im = imresize(im,[32 32]);
    imm = zeros(32);
    
    imm(find(im>150)) = 3500*2.6;
    imm(find(im<=150)) = 2500*2.4;
    gray_hr(i,:) = reshape(mat2gray(imm),1,1024);
    gray_lr(:,:,1,i) = mat2gray(lowPassFilter2(im,4,100,20));
    
    %imm(find(im>150)) = 0.7;
    %imm(find(im<=150)) = 0.3;
    %imm_blur =lowPassFilter2(imm,4,100,20);
    %imagesc(imm)
    %gray_hr(i,:) = reshape(imm,1,1024);
    %gray_lr(:,:,1,i) = imm_blur;
    
end
end