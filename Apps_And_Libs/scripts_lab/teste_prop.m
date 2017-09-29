    kant = 1;
    lant = 1;
    newima = zeros(32);
    for k = 2:2:32
       
       for l = 2:2:32
          shortim = image(kant:k,lant:l,1); 
          histo = histogram(shortim);
          value = histo.BinEdges(find(histo.Values==max(histo.Values)));
          newima(kant:k,lant:l) = value;
          lant = l;
       end
       lant=1;
       kant = k;
    end
