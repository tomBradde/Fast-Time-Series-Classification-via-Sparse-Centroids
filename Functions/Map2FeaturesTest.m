function [Features,featuresTime] = Map2FeaturesTest(TRAIN,minCol,maxCol)
classes=TRAIN(:,1);
TS=TRAIN(:,2:end);
Feat=[];
for ii = 1: size(TS,1)
    raw=TS(ii,:)';
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
    
    Feat=[Feat;TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff];
    featuresTime{ii}=[timeTD,timeDerTD,timeFD,timeAutocorr,timepoly];    
    
end

Feat=(Feat-minCol)./(maxCol-minCol);
Features=[classes,Feat];
end

