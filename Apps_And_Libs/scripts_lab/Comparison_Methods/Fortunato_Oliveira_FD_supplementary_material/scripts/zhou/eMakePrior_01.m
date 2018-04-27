function prior = eMakePrior_01(hei, wid);
%=====================================================================
% copy of the script 'eMakePrior.m' from Changyin Zhou @ Columbia U, 2009'
% http://www1.cs.columbia.edu/~changyin/SharedCode/ICCP2009/zDemo.html
% 3 lines modified on 27/09/2012 to avoid MATLAB warnings
%=====================================================================
%A simple code to compute averaged power spectrum
    %Input:  the prior size, and a set of images
    %Output:  the expected/averaged power spectrum

F02 = 0;
count = 0;

for ii = 1:7
%    strImg = ['.\images\', num2str(ii), '.jpg'];     % original 
    strImg = ['./zhou/images/', num2str(ii), '.jpg']; % modified  
    f0 = im2double(imread(strImg));
    [heiL, widL] = size(f0);
    
%   for ii = 1:hei/2:heiL-hei            % original 
    for ii = 1:floor(hei/2):heiL-hei     % modified  
%       for jj = 1:wid/2:widL-wid        % original 
        for jj = 1:floor(wid/2):widL-wid % modified  
            F0 = fft2(f0(ii:ii+hei-1, jj:jj+wid-1));
            F02 = F02+F0.*conj(F0);
            count = count+1;
        end;
    end;
end;
prior = F02/count;
