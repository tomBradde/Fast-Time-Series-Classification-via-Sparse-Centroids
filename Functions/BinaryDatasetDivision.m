function [split, featuresAccuracy,ResultingCentroids] = BinaryDatasetDivision(DatasetR,MaxFeatures,K)
if mod(length(DatasetR.Data),2)==0 
    
    
allCombs=nchoosek(1:length(DatasetR.Data),length(DatasetR.Data)/2);
allCombsPlus=allCombs(1:size(allCombs,1)/2,:);
allCombsMinus=flip(allCombs(size(allCombs,1)/2+1:end,:),1);

% for ii=1:size(allCombsPlus,1)
%     
%     DatasetSplit{ii}.Data{1}=[];
%     for zz=1:size(allCombsPlus,2)
%         DatasetSplit{ii}.Data{1}=[DatasetSplit{ii}.Data{1},DatasetR.Data{allCombsPlus(ii,zz)}];
%     end
%     
%     
%     DatasetSplit{ii}.Data{2}=[];
%     for zz=1:size(allCombsMinus,2)
%         DatasetSplit{ii}.Data{2}=[DatasetSplit{ii}.Data{2},DatasetR.Data{allCombsMinus(ii,zz)}];
%     end
% end

%perform Training and validation over all of the splits (K-fold
%crossvalidation
nClasses=2;

for ii=1:size(allCombsPlus,1)
    
    curDataset.Data{1}=[];
    for zz=1:size(allCombsPlus,2)
       curDataset.Data{1}=[curDataset.Data{1},DatasetR.Data{allCombsPlus(ii,zz)}];
    end
    
    
    curDataset.Data{2}=[];
    for zz=1:size(allCombsMinus,2)
        curDataset.Data{2}=[curDataset.Data{2},DatasetR.Data{allCombsMinus(ii,zz)}];
    end
    
%     curDataset=DatasetSplit{ii}
    [indices] = CreateKValidationIndices(curDataset,nClasses,K)
%     indices{1}=indices{1}(1:size(curDataset.Data{1},2));
%     indices{2}=indices{2}(1:size(curDataset.Data{2},2));
    plus=curDataset.Data{1};
    minus=curDataset.Data{2};
    
    
    for ff=1:MaxFeatures
        
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
            
            Centroids{kk} = l2SparseCentroids(TrainPlus,TrainMinus,ff);
            
            for aa = 1: size(TestPlus,2);
                
                a=norm(TestPlus(:,aa)-Centroids{kk}.minus)^2;
                b=norm(TestPlus(:,aa)-Centroids{kk}.plus)^2;
                CostPlus(aa)=sign(a-b);
                distplus(aa)=a-b;
            end
            
            
            for aa = 1: size(TestMinus,2);
                
                a=norm(TestMinus(:,aa)-Centroids{kk}.minus)^2;
                b=norm(TestMinus(:,aa)-Centroids{kk}.plus)^2;
                CostMinus(aa)=sign(a-b);
                distminus(aa)=a-b;
            end
            
            %compute accuracy of the current fold
            accuracy(kk)=(sum(CostPlus>=0)+sum(CostMinus<=0))/(length(CostMinus)+length(CostPlus));
            
              clear CostMinus
              clear CostPlus
            
            
            %define
            
            
            
        end
        
        
        Accuracy{ii}(1,ff)=mean(accuracy);
        clear accuracy
        clear Centroids
      
    end
    
    
end

for ii=1:size(allCombsMinus,1)
    splitAccuracy(ii)=max(Accuracy{ii});
end

[bestSplitAccuracy,bestSplitIndex]=max(splitAccuracy);

split=[allCombsPlus(bestSplitIndex,:)',allCombsMinus(bestSplitIndex,:)']

featuresAccuracy=Accuracy{bestSplitIndex};









 curDataset.Data{1}=[];
    for zz=1:size(allCombsPlus,2)
       curDataset.Data{1}=[curDataset.Data{1},DatasetR.Data{allCombsPlus(bestSplitIndex,zz)}];
    end
    
    
    curDataset.Data{2}=[];
    for zz=1:size(allCombsMinus,2)
        curDataset.Data{2}=[curDataset.Data{2},DatasetR.Data{allCombsMinus(bestSplitIndex,zz)}];
    end
    
%     curDataset=DatasetSplit{ii}
%     [indices] = CreateKValidationIndices(curDataset,nClasses,K)
% %     indices{1}=indices{1}(1:size(curDataset.Data{1},2));
% %     indices{2}=indices{2}(1:size(curDataset.Data{2},2));
    TrainPlus=curDataset.Data{1};
    TrainMinus=curDataset.Data{2};
    
    Features=20;
    ResultingCentroids = l2SparseCentroids(TrainPlus,TrainMinus,Features);


    
    
    
    
    
    
    
    
    
    
    
end

end

