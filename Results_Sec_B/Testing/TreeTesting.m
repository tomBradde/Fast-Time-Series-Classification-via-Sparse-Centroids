clear all
close all
clc


load HAR_Tree
load('HAR_TestData')
DatasetR=DatasetTest;

fprintf(' Testing...')    

%%% TEST
for ii=1:length(T.Node)
    if length(T.Node{ii}.split)~=1
    [IndNonZeroElements{ii},~]=find(T.Node{ii}.minusCentroid~=0);
    else
    IndNonZeroElements{ii}=[];
    end
end

ClassificationTime=0;

conf=zeros(6,6);

for kk=1:6
curclass=kk;
counter=0;
total=size(DatasetR.Data{curclass},2);
for ii=1:total
dataIn=DatasetR.Data{curclass}(:,ii);

flag=0;
curNode=1;
while flag==0

tic
a=norm(dataIn(IndNonZeroElements{curNode})-T.Node{curNode}.minusCentroid(IndNonZeroElements{curNode}))^2;
b=norm(dataIn(IndNonZeroElements{curNode})-T.Node{curNode}.plusCentroid(IndNonZeroElements{curNode}))^2;
CostPlus=sign(a-b);

if CostPlus>=0
    class2find=T.Node{curNode}.plusClassesOut;
else
    class2find=T.Node{curNode}.minusClassesOut;
end
    


for tt=curNode+1:length(T.Node)
   if (T.Node{tt}.father==curNode)&& isequal(T.Node{tt}.split,class2find)
       curNode=tt;
       if ~isfield(T.Node{tt},'plusClassesOut')
           flag=1;
       end
       break
   end
       
end
end
ClassificationTime=ClassificationTime+toc;
class=T.Node{curNode}.split;
% if ~isempty(find(curclass==class2find))
if class==curclass
    counter=counter+1;
end

conf(curclass,class)=conf(curclass,class)+1;
end

accuracy(kk)=counter/total;
end

meanAccuracy=sum(diag(conf)/sum(sum(conf)));
meanTime=ClassificationTime/(sum(sum(conf)));

fprintf('\n Mean testing time: %d seconds', meanTime)
fprintf('\n Mean accuracy: %d seconds', meanAccuracy)


