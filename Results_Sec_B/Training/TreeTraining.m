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
[T,~,~] = BifurcateNode(T,curNode,DatasetR,MaxFeatures,K);

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


