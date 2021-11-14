function [split, featuresAccuracy,featuresAccuracyPlus,featuresAccuracyMinus,ResultingCentroids] = PowerSetDatasetDivision2(Dataset,MaxFeatures,K,seed)
for ii=1:length(Dataset.Data)
    S{ii}=ii;
end

P=PowerSet(S);

for ii=2:length(P)/2
    Combs{ii}.firstIndices=P{ii};
    Combs{ii}.secondIndices=P{end-ii+1};
    
end
nClasses=2;
for ii=2:length(Combs);
    
    %%%%%%%%%%%%%%%%%%%% balance the dataset %%%%%%%%%%%%%%%555
    dimPlus=0;
    dimMinus=0;
    
    for zz=1:length(Combs{ii}.firstIndices)
        dimPlus=dimPlus+size(Dataset.Data{Combs{ii}.firstIndices{zz}},2);
    end
    
    for zz=1:length(Combs{ii}.secondIndices)
        dimMinus=dimMinus+size(Dataset.Data{Combs{ii}.secondIndices{zz}},2);
    end
    
    minDim=min(dimMinus,dimPlus);
    maxDim=max(dimMinus,dimPlus);
    
    
    samplesPerClass=round(minDim/length(Combs{ii}.firstIndices));
    curDataset.Data{1}=[];
    for zz=1:length(Combs{ii}.firstIndices)
        curSize=size(Dataset.Data{Combs{ii}.firstIndices{zz}},2);
%         rng('default')
        %old rng=10;
        rng(seed)
        R=randi([1,curSize],samplesPerClass,1);
        if curSize<=samplesPerClass
            curDataset.Data{1}=[curDataset.Data{1},Dataset.Data{Combs{ii}.firstIndices{zz}}];
        else
            curDataset.Data{1}=[curDataset.Data{1},Dataset.Data{Combs{ii}.firstIndices{zz}}(:,R)];
        end
    end
    
    samplesPerClass=round(minDim/length(Combs{ii}.secondIndices));
    curDataset.Data{2}=[];
    for zz=1:length(Combs{ii}.secondIndices)
        curSize=size(Dataset.Data{Combs{ii}.secondIndices{zz}},2);
        R=randi([1,curSize],samplesPerClass,1);
        if curSize<=samplesPerClass
            curDataset.Data{2}=[curDataset.Data{2},Dataset.Data{Combs{ii}.secondIndices{zz}}];
        else
            curDataset.Data{2}=[curDataset.Data{2},Dataset.Data{Combs{ii}.secondIndices{zz}}(:,R)];
        end
    end
    
    %     R=randi([1,maxDim],minDim,1);
    %     if size(curDataset.Data{1},2)==maxDim
    %         curDataset.Data{1}= curDataset.Data{1}(:,R);
    %     else
    %         curDataset.Data{2}= curDataset.Data{2}(:,R);
    %     end
    %
    %     curDataset=DatasetSplit{ii}
    [indices] = CreateKValidationIndices(curDataset,nClasses,K);
    %     indices{1}=indices{1}(1:size(curDataset.Data{1},2));
    %     indices{2}=indices{2}(1:size(curDataset.Data{2},2));
    plus=curDataset.Data{1};
    minus=curDataset.Data{2};
    
    
    
    for kk=1:K
        %  define training and test set for class 1
        testIndexPlus = (indices{1} == kk);
        trainIndexPlus = ~testIndexPlus;
        
        TrainPlus=plus(:,trainIndexPlus );
        TestPlus=plus(:,testIndexPlus );
        
        testIndexMinus = (indices{2} == kk);
        trainIndexMinus = ~testIndexMinus;
        
        TrainMinus=minus(:,trainIndexMinus );
        TestMinus=minus(:,testIndexMinus );
        
        %         TrainPlus=zscore(TrainPlus);
        %         TestPlus=zscore(TestPlus);
        %
        %         TrainMinus=zscore(TrainMinus);
        %         TestMinus=zscore(TestMinus);
        
        %         mu=mean([TrainPlus,TrainMinus],2);
        %         deviation=std([TrainPlus,TrainMinus]');
        %
        %         TrainPlus=(TrainPlus-mu)./deviation';
        
        [val,ind,plusCentroid,minusCentroid] = l2SparseCentroids2(plus(:,trainIndexPlus ),minus(:,trainIndexMinus ));
        
        
        
        
        for ff=1:MaxFeatures
            E=ind(ff+1:end);
            %set to zero all the indices different from D in the centroids
            KplusCentroid=plusCentroid;
            KminusCentroid=minusCentroid;
            
            KplusCentroid(E)=0;
            KminusCentroid(E)=0;
            
            Centroids.plus=KplusCentroid;
            Centroids.minus=KminusCentroid;
            
            for aa = 1: size(TestPlus,2);
                
                a=norm(TestPlus(:,aa)-Centroids.minus)^2;
                b=norm(TestPlus(:,aa)-Centroids.plus)^2;
                CostPlus(aa)=sign(a-b);
                distplus(aa)=a-b;
            end
            
            
            for aa = 1: size(TestMinus,2);
                
                a=norm(TestMinus(:,aa)-Centroids.minus)^2;
                b=norm(TestMinus(:,aa)-Centroids.plus)^2;
                CostMinus(aa)=sign(a-b);
                distminus(aa)=a-b;
            end
            
            %compute accuracy of the current fold
            if ~exist('CostPlus','var')
                keyboard
            end
            accuracy(kk,ff)=(sum(CostPlus>=0)+sum(CostMinus<=0))/(length(CostMinus)+length(CostPlus));
            accuracyPlus(kk,ff)=sum(CostPlus>=0)/length(CostPlus);
            accuracyMinus(kk,ff)=sum(CostMinus<=0)/length(CostMinus);
            clear CostMinus
            clear CostPlus
            
            
            %define
            
            
            
        end
        
        
    end
    
        Accuracy{ii}=mean(accuracy,1);
        AccuracyPlus{ii}=mean(accuracyPlus,1);
        AccuracyMinus{ii}=mean(accuracyMinus,1);
        
        clear accuracy
        clear accuracyPlus
        clear accuracyMinus
        clear Centroids
    
end

for ii=2:length(Combs)
    splitAccuracy(ii)=max(Accuracy{ii});
end

[bestSplitAccuracy,bestSplitIndex]=max(splitAccuracy);

split=Combs{bestSplitIndex};
split.firstIndices=cell2mat(split.firstIndices);
split.secondIndices=cell2mat(split.secondIndices);

featuresAccuracy=Accuracy{bestSplitIndex};
featuresAccuracyPlus=AccuracyPlus{bestSplitIndex};
featuresAccuracyMinus=AccuracyMinus{bestSplitIndex};


curDataset.Data{1}=[];
for zz=1:length(Combs{bestSplitIndex}.firstIndices)
    curDataset.Data{1}=[curDataset.Data{1},Dataset.Data{Combs{bestSplitIndex}.firstIndices{zz}}];
end


curDataset.Data{2}=[];
for zz=1:length(Combs{bestSplitIndex}.secondIndices)
    curDataset.Data{2}=[curDataset.Data{2},Dataset.Data{Combs{bestSplitIndex}.secondIndices{zz}}];
end

TrainPlus=curDataset.Data{1};
TrainMinus=curDataset.Data{2};


%Select a number of features
TargetAccuracy=max(featuresAccuracy);
for xx=1:length(featuresAccuracy)
    if xx==1
        if featuresAccuracy(xx)==TargetAccuracy
            NumberOfFeatures=xx;
            break
        else
        end
    else
        curAccuracy=featuresAccuracy(xx);
        if curAccuracy==TargetAccuracy
            NumberOfFeatures=xx;
            break
        end
        
        curImprovement=featuresAccuracy(xx)-featuresAccuracy(xx-1);
        
        %check if we have to stop
        if curImprovement<=0.01
            %Maybe we have to stop. Check if we are near enough to the maximum possible accuracy
            if abs(featuresAccuracy(xx-1)-TargetAccuracy)<=0.005;
                NumberOfFeatures=xx-1;
                break
            end
        end
    end
end

% figure
% plot(featuresAccuracy);
% hold on
% scatter(NumberOfFeatures, featuresAccuracy(NumberOfFeatures),'k');
ResultingCentroids = l2SparseCentroids(TrainPlus,TrainMinus,NumberOfFeatures);


end