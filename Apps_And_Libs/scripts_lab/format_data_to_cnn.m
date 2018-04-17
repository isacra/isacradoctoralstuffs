function[gray_lr, gray_hr] = format_data_to_cnn(x,y)
[l,c,p] = size(x);
for i = 1 : p
    gray_hr(i,:) = reshape(y(:,:,i),1,l*c);
    gray_lr(:,:,1,i) = x(:,:,i);
    
end
end