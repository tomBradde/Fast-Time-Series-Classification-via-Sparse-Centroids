function [Tree,n1,n2] = BifurcateNode2(Tree,node,Dataset,MaxFeatures,K)

DatasetSplit=BuildReducedDataset(Dataset,Tree.get(node).split);
[split, featuresAccuracy,featuresAccuracyPlus,featuresAccuracyMinus,ResultingCentroids] = PowerSetDatasetDivision(DatasetSplit,MaxFeatures,K);

%%%%%% convert indices
referenceIndices=Tree.get(node).split;
[split] = ConvertPowerSetIndexes2Reference(split,referenceIndices);

ParentFields=Tree.get(node);
ParentFields.plusClassesOut=split.firstIndices;
ParentFields.minusClassesOut=split.secondIndices;
ParentFields.plusCentroid=ResultingCentroids.plus;
ParentFields.minusCentroid=ResultingCentroids.minus;

Tree = Tree.set(node, ParentFields);
[Tree,n1,n2] = AppendPowerDivision(Tree,node,split,featuresAccuracy);

if length(Tree.get(n1).split)~=1
    [Tree,n1,n2] = BifurcateNode2(Tree,n1,Dataset,MaxFeatures,K);
end
if length(Tree.get(n2).split)~=1
    [Tree,n1,n2] = BifurcateNode2(Tree,n1,Dataset,MaxFeatures,K);
end
end

