function [Features] = ExtractTimeDomainFeatures_Train(raw)

Features(1)=mean(raw);

Features(2)=std(raw);

Features(3)=mad(raw);

Features(4)=max(raw);

Features(5)=min(raw);

% Features(6)=sma(raw);

Features(6)=sum(abs(raw).^2)/length(raw);

Features(7)=iqr(raw);

Features(8)=entropy(raw);

Features(9)=var(raw);

Features(10)=skewness(raw);

Features(11)=kurtosis(raw);




end

