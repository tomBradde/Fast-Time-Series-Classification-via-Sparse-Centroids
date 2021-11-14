function [ Features,time ] = ExtractTimeDomainFeatures(raw)
tic
Features(1)=mean(raw);
time(1)=toc;
tic
Features(2)=std(raw);
time(2)=toc;
tic
Features(3)=mad(raw);
time(3)=toc;
tic;
Features(4)=max(raw);
time(4)=toc;
tic
Features(5)=min(raw);
time(5)=toc;
% Features(6)=sma(raw);
tic
Features(6)=sum(abs(raw).^2)/length(raw);
time(6)=toc;
tic
Features(7)=iqr(raw);
time(7)=toc;
tic
Features(8)=entropy(raw);
time(8)=toc;
tic
Features(9)=var(raw);
time(9)=toc;
tic
Features(10)=skewness(raw);
time(10)=toc;
tic
Features(11)=kurtosis(raw);
time(11)=toc;
% tic
% %For USCHAD
% Features(12)= ZeroCrossings(raw);  
% %otherwise
% Features(12)= ZeroCrossings(raw-mean(raw));
% time(12)=toc;



end

