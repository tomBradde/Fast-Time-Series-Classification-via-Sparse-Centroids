clear all
close all
clc

load TempDataset
TempMat=[];
for ii=1:length(Dataset.Data)
    TempMat=[TempMat,Dataset.Data{ii}];
end

  [Z,MU,SIGMA] = zscore(TempMat') ;
  
for ii=1:length(Dataset.Data)
    Dataset.Data{ii}=diag(SIGMA)*(Dataset.Data{ii}-MU');
end

Dataset.MU=MU;
Dataset.SIGMA=SIGMA;