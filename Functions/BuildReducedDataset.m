function [NewDataset] = BuildReducedDataset(OldDataset,ClassIndexes)
for kk=1:length(ClassIndexes)
    NewDataset.Data{kk}=OldDataset.Data{ClassIndexes(kk)};
end
end

