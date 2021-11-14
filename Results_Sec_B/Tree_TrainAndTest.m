clear all
close all
clc

fprintf('Loading Data...')
load('HAR_TrainData')

DatasetR=DatasetTrain;




MaxFeatures=20;
K=10;
fprintf('\n Tree Generation...')
tic
%%%%%%%%%%%%%%BUILD THE TREEEE %%%%%%%%%%%%%%%%
init.split=1:length(DatasetR.Data);
init.accuracy=0;

T=tree(init);

%%%%%%%%%% FIRST SPLIT %%%%%%%%%%%%%%

TreeCompleted=0;
curNode=1;
while ~TreeCompleted
    %Bifurcate
[T,~,~] = BifurcateNode(T,curNode,DatasetR,MaxFeatures,K,8);

%check which node must be bifurcate
for ii=1:length(T.Node)
    curNode= T.Node(ii);
    if isfield(curNode{1},'plusClassesOut')
    else
    curSplit=curNode{1}.split;
    if length(curSplit)~=1
        curNode=ii;
        break
    end
    end
    
    if ii==length(T.Node)
    TreeCompleted=1;
    end
end
end
fprintf(' Tree Generated')    
time=toc;
fprintf('\n Training time: %d seconds', time)







% load HAR_Tree
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


