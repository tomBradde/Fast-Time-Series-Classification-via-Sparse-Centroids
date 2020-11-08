function [D] = l2SparseCentroidsIndexes(PlusClassMatrix, MinusClassMatrix,k)

%compute centroids for the two classes
plusCentroid=sum(PlusClassMatrix,2)/size(PlusClassMatrix,2);
minusCentroid=sum(MinusClassMatrix,2)/size(MinusClassMatrix,2);

midPoint=(plusCentroid+minusCentroid)/2;
difference=plusCentroid-minusCentroid;

[val ind] = sort(abs(difference),'descend');
D=ind(1:k);


end

