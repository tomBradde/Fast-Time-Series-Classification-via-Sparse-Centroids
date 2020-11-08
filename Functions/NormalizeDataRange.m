clear all
close all
clc

load TestSubjectsDataset
% Dataset=DatasetTest;

TempMat=[];
for ii=1:length(Dataset.Data)
    TempMat=[TempMat,Dataset.Data{ii}];
    
    
end

minRow=min(TempMat,[],2);
maxRow=max(TempMat,[],2);

for ii=1:length(Dataset.Data)
    Dataset.Data{ii}=(Dataset.Data{ii}-minRow)./(maxRow-minRow);
end

Dataset.minRow=minRow;
Dataset.maxRow=maxRow;