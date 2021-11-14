function [Features,featuresTime] = Map2FeaturesTest_star(TRAIN,minCol,maxCol)
classes=TRAIN(:,1);
TS=TRAIN(:,2:end);
Feat=[];
% Feat=zeros(size(TRAIN,1),576);
% Feat=zeros(size(TRAIN,1),2);
for ii = 0: size(TS,1)
    if ii==0
        raw=TS(1,:)';
        
        indNan=isnan(raw);
        raw(indNan)=0;
        
        zci = find(raw(:).*circshift(raw(:), [-1 0]) <= 0);
        nZerosCross=length(zci);
        
        
        [ TDFeat,timeTD] = ExtractTimeDomainFeatures(raw);
        
        [ TDFeatDer,timeDerTD] = ExtractTimeDomainFeatures(diff(raw));
        [ FDFeat,timeFD]=ExtractFrequencyDomainFeaturesSTD(raw,1);
        tic
        autoCoeff=autocorr(raw);
        timeAutocorr=toc;
        timeAutocorr=(timeAutocorr/length(autoCoeff))*ones(1,length(autoCoeff));
        tic
        pcoeff = polyfit(raw',1:length(raw),5);
        timepoly=toc;
        timepoly=(timepoly/6)*ones(1,6);
        tic
        wavname='haar';
        [c,l1] = wavedec(raw,3,wavname);
        approx1 = appcoef(c,l1,wavname);
        % [cd1,cd2,cd3] = detcoef(c,l1,[1 2 3]);
        featWav1=skewness(approx1);
        featWav2=var(approx1);
        timeWav=toc;
        %     Feat=[Feat;TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff,featWav1,featWav2];
        Features=[TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff,featWav1,featWav2,nZerosCross];
        Feat=zeros(size(TRAIN,1),length(Features));
        
        
        
        
        
        
    else
        raw=TS(ii,:)';
        
        indNan=isnan(raw);
        raw(indNan)=0;
        tic
        zci = find(raw(:).*circshift(raw(:), [-1 0]) <= 0);
        nZerosCross=length(zci);
        timeZeros=toc;
        [ TDFeat,timeTD] = ExtractTimeDomainFeatures(raw);
        
        [ TDFeatDer,timeDerTD] = ExtractTimeDomainFeatures(diff(raw));
        [ FDFeat,timeFD]=ExtractFrequencyDomainFeaturesSTD(raw,1);
        tic
        autoCoeff=autocorr(raw);
        timeAutocorr=toc;
        timeAutocorr=(timeAutocorr/length(autoCoeff))*ones(1,length(autoCoeff));
        tic
        pcoeff = polyfit(raw',1:length(raw),5);
        timepoly=toc;
        timepoly=(timepoly/6)*ones(1,6);
        tic
        wavname='haar';
        [c,l1] = wavedec(raw,3,wavname);
        approx1 = appcoef(c,l1,wavname);
        % [cd1,cd2,cd3] = detcoef(c,l1,[1 2 3]);
        featWav1=skewness(approx1);
        featWav2=var(approx1);
        timeWav=toc;
        %     Feat=[Feat;TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff,featWav1,featWav2];
        Feat(ii,:)=[TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff,featWav1,featWav2,nZerosCross];
        %  Feat(ii,:)=[featWav1,featWav2];
        featuresTime{ii}=[timeTD,timeDerTD,timeFD,timeAutocorr,timepoly,ones(1,2)*timeWav,timeZeros];
        %      featuresTime{ii}=[timeTD,timeDerTD,timeFD,timeAutocorr,timepoly,ones(1,2)*timeWav];
    end
end

Feat=(Feat-minCol)./(maxCol-minCol);

%checkthis
IndNaN=find(maxCol==minCol);
Feat(:,IndNaN)=1;

Features=[classes,Feat];
end

