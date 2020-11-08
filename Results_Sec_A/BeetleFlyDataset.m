clear all
close all
clc


%Load the dataset
DatasetName='BeetleFly';
fprintf('Loading Data...')
TRAIN = load(strcat(DatasetName,'_TRAIN.tsv'));

%Start Time Measurement
tic
isFeature=1;
fprintf('\n Tree Generation...')
%Map The Train Dataset To Features
[TRAIN,minCol,maxCol]=Map2FeaturesTrain(TRAIN);

%Check for the number of classes
classes=unique(TRAIN(:,1));
Nclasses=length(classes);

%Organize Data According to Algorithm Input Structure
for ii=1:Nclasses
    [ind,val]=find(TRAIN(:,1)==classes(ii));
     DatasetR.Data{ii}=TRAIN(ind,2:end)';
end

%Choose The Number of the Features and Crossvalidations Folds
MaxFeatures=10;
K=10;

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
%Store the computation time of the training
CompTime=toc;


%Start The test phase

%%% TEST

%For each node, check which features are to be retained during
%classification
for ii=1:length(T.Node)
    if length(T.Node{ii}.split)~=1
    [IndNonZeroElements{ii},~]=find(T.Node{ii}.minusCentroid~=0);
    else
    IndNonZeroElements{ii}=[];
    end
end


%Load test dataset
TEST= load(strcat(DatasetName,'_TEST.tsv'));


%Compute the features vector and store the time required to compute each
%feature. Only retained features will be used to compute the test time
%requirements.
[TEST,featuresTime]=Map2FeaturesTest(TEST,minCol,maxCol);


%Put the Test Data in Algorithm-compliant structure
for ii=1:Nclasses
    [ind,val]=find(TEST(:,1)==classes(ii));
     DatasetR.Data{ii}=TEST(ind,2:end)';
     if exist('isFeature','var')
         for kk=1:length(ind)
         DatasetR.featTime{ii,kk}=featuresTime{ind(kk)};
         end
     end
end
fprintf('\n Tree Testing...')
%Initialize confusion matrix
conf=zeros(Nclasses,Nclasses);

%Classify all of the test data
for kk=1:Nclasses
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

%Add feature computation time using the stored Time requirements data.
if exist('isFeature','var')
CompTime=CompTime+sum(DatasetR.featTime{kk,ii}(IndNonZeroElements{curNode}));
end

if CostPlus>=0
    class2find=T.Node{curNode}.plusClassesOut;
else
    class2find=T.Node{curNode}.minusClassesOut;
end

    
% flag=1;

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
CompTime=CompTime+toc;
class=T.Node{curNode}.split;

if class==curclass
    counter=counter+1;
end

conf(curclass,class)=conf(curclass,class)+1;
end

%Estimate mean accuracy for the current class
accuracy(kk)=counter/total;
end


MeanAccuracy=mean(accuracy);
fprintf('\n Training and Test time: %d seconds', CompTime)
fprintf('\n Mean Accuracy: %f', MeanAccuracy)
