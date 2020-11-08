function [indices] = CreateKValidationIndices(Dataset,nClasses,K)
for ii=1:nClasses
    curClass=Dataset.Data{ii};
    curNumberOfSamples=size(curClass,2);
    fraction=round(curNumberOfSamples/K);
    indices{ii}=[];
    for zz=1:K
        indices{ii}=[indices{ii};ones(fraction,1)*zz];
        if zz==K
            diffL=curNumberOfSamples-length(indices{ii});
            indices{ii}=[indices{ii};ones(diffL,1)*zz];
        end
    end
    
    if (length(indices{ii})-curNumberOfSamples)>=0
        indices{ii}=indices{ii}(1:curNumberOfSamples);
    else
        indices{ii}=[indices{ii};K*ones(length(indices{ii})-curNumberOfSamples,1)];
    end
        
    indices{ii}=indices{ii}(randperm(length(indices{ii})));
end
end

