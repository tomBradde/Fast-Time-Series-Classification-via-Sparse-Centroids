function [PowSplit] = ConvertPowerSetIndexes2Reference(PowSplit,Reference)

for kk=1:length(PowSplit.firstIndices)
    PowSplit.firstIndices(kk)=Reference(PowSplit.firstIndices(kk));
end

for kk=1:length(PowSplit.secondIndices)
    PowSplit.secondIndices(kk)=Reference(PowSplit.secondIndices(kk));
end

end

