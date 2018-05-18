function[x_low, x_truth] = norm_data(x,y,max_imp,min_imp)
    


%     [l,c,p] = size(x);
%     x_reshaped = reshape(x,[l,c*p]);
%     [x_normed] = mat2gray(x_reshaped,[max_imp min_imp]);
%     x_normed = reshape(x_normed,[l,c,p]);
%     
%     
%     [l,c,p] = size(y);
%     y_reshaped = reshape(y,[l,c*p]);
%     y_normed = mat2gray(y_reshaped,[max_imp min_imp]);
%     y_normed = reshape(y_normed,[l,c,p]);
%     
%     x_low = x_normed;
%     x_truth = y_normed;
    
    max_imp = max(x, y);
    max_imp = max(max_imp(:));
    min_imp = min(x, y);
    min_imp = min(min_imp(:));
    x_truth = (y - min_imp)/(max_imp - min_imp);
    x_low = (x - min_imp)/(max_imp - min_imp);
    
    
end