function [Tree,n1,n2] = BifurcateNode(Tree,node,Dataset,MaxFeatures,K,seed)

DatasetSplit=BuildReducedDataset(Dataset,Tree.get(node).split);
[split, featuresAccuracy,featuresAccuracyPlus,featuresAccuracyMinus,ResultingCentroids] = PowerSetDatasetDivision2(DatasetSplit,MaxFeatures,K,seed);

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
end

