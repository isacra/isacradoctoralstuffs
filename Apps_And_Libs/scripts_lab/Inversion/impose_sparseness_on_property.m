function [inline_sparse] = impose_sparseness_on_property(inline)

inline_sparse = zeros(size(inline,1),size(inline,2));

sparse = diff(inline);
sparse = impose_sparseness2(sparse);

inline_sparse(2:end,:) = sparse;
inline_sparse(1,:) = inline_sparse(1,:) +  inline(1,:);
inline_sparse = cumsum(inline_sparse);

% merge:
%inline_sparse = inline_sparse - lowPassFilter2(inline_sparse,4,110,8) + lowPassFilter2(inline,4,110,8);

end


function [sparse] = impose_sparseness2(refl)
% impose_sparseness_3peak_CM é o mais parecido com o Jason    
    sparse = zeros(size(refl));

    for j=1:size(refl,2)
        [sparse(:,j)] = impose_sparseness_2peak_CM(refl(:,j));
        %sparse(:,j) = sum(refl(:,j))*sparse(:,j)/sum(sparse(:,j));
    end

end


function [sparse] = impose_sparseness_2peak_CM(refl)
% o melhor esquema até 19/08/14 , este tem o cond_inflexao, mas nao esta
% dentro do if, portanto o blean eh ignorado!
minimum_reflectivity = 0;% 5.5e-3;
minumum_inflection = 1e-4;
sparse = zeros(size(refl));

% corrige por causa das dimensoes menores do diff
drefl = diff(refl);
drefl(2:end+1) = drefl;
drefl(1) = drefl(2);
d2refl = diff(drefl);
d2refl(2:end+1) = d2refl;
d2refl(1)=-1;
d2refl(end+1)=1;

drefl_ = diff((refl));
drefl_(2:end+1) = drefl_;
drefl_(1) = drefl_(2);
d2refl_aux = diff(drefl_);
d2refl_aux(2:end+1) = d2refl_aux;
d2refl_aux(1)=-1;
d2refl_aux(end+1)=1;

drefl_ = diff(abs(refl));
drefl_(2:end+1) = drefl_;
drefl_(1) = drefl_(2);
d2refl_ = diff(drefl_);
d2refl_(2:end+1) = d2refl_;
d2refl_(1)=-1;
d2refl_(end+1)=1;

d3refl_ = diff((d2refl_));
d3refl_(2:end+1) = d3refl_;
d3refl_(1) = d3refl_(2);

energy=abs(refl(1));
max=0; 
t_max=1;
t0 = 1;
t_last=1;
for t=2:length(refl)
    cond_end = t==length(refl);
    cond_0 = sign(refl(t)) ~= sign(refl(t-1)); % f(t)=0
    cond_min = (sign(drefl(t)) ~= sign(drefl(t-1))) && d2refl_(t) > 0; % f'(t)=0 e f''(t)>0 
    if  t>length(refl) -3 || t<3 ;
        cond_inflexao = 0;
    else
        cond_inflexao = (abs(d2refl_(t))> minumum_inflection) && (sign(drefl_(t)) == sign(drefl_(t+1))) && (sign(drefl_(t)) == sign(drefl_(t-1))) &&(sign(refl(t)) == sign(refl(t+2))) && (sign(refl(t)) == sign(refl(t-2))) && (d3refl_(t)>0) && (d3refl_(t)>0) && (sign(d2refl_(t)) ~= sign(d2refl_(t-1)) && ~cond_0); % f''(t)==0  e f'''(t) > 0
    end
    
    if cond_0 || (cond_min && (t-1 ~= t_max)) || (cond_end)% || cond_inflexao% condicao de acabar reflexao
        if (max>minimum_reflectivity  && t_last~=t-1 ) || cond_end  
            %if (cond_end && ~(cond_0 || (cond_min && (t-1 ~= t_max))) ), energy = energy + abs(refl(t)); t = t+1; end
            if (cond_end && (cond_0 || (cond_min && (t-1 ~= t_max))) ), sparse(t) = refl(t); end
            if t_max > 1 && t_max < length(refl)
                refl_mod = (abs(refl(t0:t-1)));
                t_cm = sum([t0:t-1]'.*refl_mod)/sum(refl_mod);
                if ~isnan(t_cm)
                t_inf = int64(t_cm-0.5);
                t_sup = int64(t_cm+0.5);
                sparse(t_sup) = sign(refl(t_inf))*energy*(t_cm - double(t_inf) );
                sparse(t_inf) = sign(refl(t_inf))*energy - sparse(t_sup);
                end
            end
            t_max=t-1;            
        end        
        if t_last==t-1 
            sparse(t-1) = refl(t-1);
        end
        max=0;
        t0 = t;
        if cond_end~=1
        energy=abs(refl(t));
        end
        t_last = t;
     %   if sum(refl(1:t-1)) - sum(sparse(1:t-1)) > 1e-6
     %       t
     %       para1=1;           
     %   end        
    else % condicao esta na reflexao
        energy = energy + abs(refl(t));
        if abs(refl(t))>max 
            max = abs(refl(t));
            t_max = t;
        end
    end
    if t==139
        para = 1;
    end
    
    % Só para incluir o ultimo ponto...
  %  if t==length(refl)
  %      sparse(t) = refl(t);
  %  end
    
end

end