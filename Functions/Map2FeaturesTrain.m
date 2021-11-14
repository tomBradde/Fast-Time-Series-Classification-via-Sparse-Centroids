function [Features,minCol,maxCol] = Map2FeaturesTrain(TRAIN)
classes=TRAIN(:,1);
TS=TRAIN(:,2:end);
Feat=[];
for ii = 1: size(TS,1)
    raw=TS(ii,:)';
    [ TDFeat] = ExtractTimeDomainFeatures_Train(raw);
    
    [ TDFeatDer] = ExtractTimeDomainFeatures_Train(diff(raw));
    [ FDFeat]=ExtractFrequencyDomainFeaturesSTD_Train(raw,1);
    autoCoeff=autocorr(raw);
    pcoeff = polyfit(raw',1:length(raw),5);
    
    Feat=[Feat;TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff];
    
end

minCol=min(Feat,[],1)+1e-5;
maxCol=max(Feat,[],1);
Feat=(Feat-minCol)./(maxCol-minCol);
Features=[classes,Feat];
end

