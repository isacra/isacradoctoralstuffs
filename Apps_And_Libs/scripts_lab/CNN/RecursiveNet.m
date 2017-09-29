layer = [imageInputLayer([32 32 1])];
for i =1 : 2
    for j = 1 : 6
       inputs = resnets(layer,32,[3,3])
        
    end
end