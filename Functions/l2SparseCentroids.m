function [Centroids] = l2SparseCentroids(PlusClassMatrix, MinusClassMatrix,k)

%compute centroids for the two classes
plusCentroid=sum(PlusClassMatrix,2)/size(PlusClassMatrix,2);
minusCentroid=sum(MinusClassMatrix,2)/size(MinusClassMatrix,2);

midPoint=(plusCentroid+minusCentroid)/2;
difference=plusCentroid-minusCentroid;


% [val ind] = sort(abs(difference)./(VarMinusFeat+VarPlusFeat),'descend');
[val ind] = sort(abs(difference),'descend');
D=ind(1:k);
E=ind(k+1:end);

%set to zero all the indices different from D in the centroids
KplusCentroid=plusCentroid;
KminusCentroid=minusCentroid;

KplusCentroid(E)=0;
KminusCentroid(E)=0;

Centroids.plus=KplusCentroid;
Centroids.minus=KminusCentroid;

end

