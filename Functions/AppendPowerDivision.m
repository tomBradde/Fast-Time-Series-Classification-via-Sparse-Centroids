function [Tree,n1,n2] = AppendPowerDivision(Tree,node,PowSplit,featuresAccuracy)

n.split=PowSplit.firstIndices;
n.featuresAccuracy=featuresAccuracy;
n.father=node;
[Tree,n1]=Tree.addnode(node,n);

n.split=PowSplit.secondIndices;
n.father=node;
n.featuresAccuracy=featuresAccuracy;
[Tree,n2]=Tree.addnode(node,n);


end

