function [ W_, property, time, timeCalc, W ] = wellUpscaleMultipleLog(W, sRate, t0, seismic, betweenFlag)
% seismic - Traços sísmicos na estrutura de dados da biblioteca seismat (read_segy_file())
% sRate - Taxa de amsotragem em ms (normalmente 4ms)
% t0 - Primeiro tempo da amostra do dado sísmico (angola é 3000 e campo B é 0)
% W - Poço na estrutura de dados da biblioteca seismat (read_las_file())
% betweenFlag - Flag para determinar se os dados do poco serão pegos entre
% os multiplos de sRate (betweenFlag=1) ou entre [sRate-sRate/2 , sRate+sRate/2] (betweenFlag=0)
%
% examples:
% B17tied = read_las_file('D:\dados_reservatorios\JASON_2014\7EN0017_g.las');
% [stack_campoB] = read_segy_file('D:\dados_reservatorios\campoB_unesp\Leandro_ago2014CampoB\sismica_campoB');
% [ B17tied_] = wellUpscaleMultipleLog(B17tied, 4, 0, stack_campoB);
%
% Return: W_.... Estrutura de dados do Lelis, com W_.TRACE, W_.RC, W_.
% etc....
% IMPORTANTÍSSIMO !!!!
% DEFINIR AS VARIÁVEIS ABAIXO:
% Do arquivo LAS:
% WellColumnProperty = [12 15]; %angola ai phi
WellColumnProperty = [12]; %angola ai
WellColumnTime = 5; %angola
%WellColumnTime = 8;
% Do arquivo sgy:
SeismicXrow = 7;
SeismicYrow = 8 ;

if nargin < 5
    betweenFlag = 0;
end



sRatel2 = sRate/2;
windowTimeFull = false;
initTimeShift = (1-betweenFlag)*sRatel2;

for i = 1:length(WellColumnProperty)
    data(:,i) = W.curves(:,WellColumnProperty(i));
    WellColumnProperty(i) = i;
end

i=1;
for k=1:length(data(:,WellColumnProperty))-1
    
    isNaN = sum(isnan(data(k,:)));
    if (isNaN==0)&&(W.curves(k,WellColumnTime))>=(t0-sRatel2)                
        
        if (~windowTimeFull)            
            initialK = k;
            windowTimeFull = true;

            
            initialTime = round(((W.curves(k,WellColumnTime))/sRate))*sRate - initTimeShift;
            if i==1
                time(1) = initialTime + initTimeShift;
                if time(1) < W.curves(k,WellColumnTime) && betweenFlag==0
                    windowTimeFull = false;
                end;
                if time(1) > W.curves(k,WellColumnTime) && betweenFlag==1
                    windowTimeFull = false;
                end;
                
            end;
        end
        
        wellSampleRate = mean(diff(W.curves(initialK:k+1,WellColumnTime)));

        deltaT = W.curves(k,WellColumnTime) - (initialTime); 

        if (windowTimeFull)
            if deltaT > sRate - wellSampleRate/2                                
                for ii = 1:length(WellColumnProperty)
                    property(i,ii) = median(data(initialK:k,ii));
                end
                timeCalc(i) = mean(W.curves(initialK:k,WellColumnTime));                     
                time(i) = time(1) + (i-1)*sRate;
                windowTimeFull = false;

                i = i + 1;
            end
        end

    end
    
end

%W_.VS = property(:,1);
%W_.VP = property(:,2);
W_.AI = property(:,1);
% W_.RC = impedancia2refletividade(W_.AI);
%W_.RC = lowPassFilter2(impedancia2refletividade(W_.AI),sRate/1000,110,30);
% W_.PHI = property(:,1);
%W_.RHOB = property(:,4);
W_.TIME = time';


[~,chosenTrace] = min(dist([seismic(1).headers(SeismicXrow,:);seismic(1).headers(SeismicYrow,:)]',[W.xcrd;W.ycrd]));


nAngleStack = size(seismic,2);
time2=time(1:end-1); % Tira a primeira linha da sismica
for i  = 1:nAngleStack
     W_.TRACE(:,i) = seismic(i).traces((time2-t0)/sRate + 1,chosenTrace);
end

W_.traceNumber = chosenTrace;
W.traceNumber = chosenTrace;

% subplot(2,1,1)
% plot(W_.TIME(1:end-1),W_.TRACE,'r')
% subplot(2,1,2)
% plot(W_.TIME(1:end-1),W_.RC,'r')

