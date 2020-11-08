function [Tree,n1,n2] = AppendBinaryDivision(Tree,node,split,featuresAccuracy,Centroids)
n.split=split(:,1);
n.featuresAccuracy=featuresAccuracy;
n.father=node
[Tree,n1]=Tree.addnode(node,n);

n.split=split(:,2);
n.featuresAccuracy=featuresAccuracy;
n.father=node;

[Tree,n2]=Tree.addnode(node,n);

ParentFields=Tree.get(node);
ParentFields.plusClassesOut=split(:,1);
ParentFields.minusClassesOut=split(:,2);
ParentFields.plusCentroid=Centroids.plus;
ParentFields.minusCentroid=Centroids.minus;

Tree=Tree.set(node, ParentFields);
end

