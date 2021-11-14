function [Features,minCol,maxCol] = Map2FeaturesTrain_star(TRAIN)
classes=TRAIN(:,1);
TS=TRAIN(:,2:end);
Feat=[];
for ii = 1: size(TS,1)
    raw=TS(ii,:)';
    zci = find(raw(:).*circshift(raw(:), [-1 0]) <= 0);
    nZerosCross=length(zci);
    [ TDFeat] = ExtractTimeDomainFeatures_Train(raw);
    
    [ TDFeatDer] = ExtractTimeDomainFeatures_Train(diff(raw));
    [ FDFeat]=ExtractFrequencyDomainFeaturesSTD_Train(raw,1);
    autoCoeff=autocorr(raw);
    pcoeff = polyfit(raw',1:length(raw),5);
    wavname='haar';
    [c,l1] = wavedec(raw,3,wavname);
approx1 = appcoef(c,l1,wavname);
% [cd1,cd2,cd3] = detcoef(c,l1,[1 2 3]);
featWav1=skewness(approx1);
featWav2=var(approx1);
    
    Feat=[Feat;TDFeat,TDFeatDer,FDFeat,autoCoeff',pcoeff,featWav1,featWav2,nZerosCross];
%      Feat=[Feat;featWav1,featWav2];
end

minCol=min(Feat,[],1);
maxCol=max(Feat,[],1);
Feat=(Feat-minCol)./(maxCol-minCol);
IndNaN=find(maxCol==minCol);
Feat(:,IndNaN)=1;
Features=[classes,Feat];
end

