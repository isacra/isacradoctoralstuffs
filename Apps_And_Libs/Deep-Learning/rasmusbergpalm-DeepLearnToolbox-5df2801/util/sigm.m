function X = sigm(P)
    X = 1./(1+exp(-P));
    %X = tansig(P);
end