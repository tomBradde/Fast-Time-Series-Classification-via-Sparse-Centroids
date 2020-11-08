function [val,ind,plusCentroid,minusCentroid] = l2SparseCentroids2(PlusClassMatrix, MinusClassMatrix)

%compute centroids for the two classes
plusCentroid=sum(PlusClassMatrix,2)/size(PlusClassMatrix,2);
minusCentroid=sum(MinusClassMatrix,2)/size(MinusClassMatrix,2);

midPoint=(plusCentroid+minusCentroid)/2;
difference=plusCentroid-minusCentroid;

[val ind] = sort(abs(difference),'descend');
end


