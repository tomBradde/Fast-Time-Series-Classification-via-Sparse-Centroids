function [ Features ] = ExtractFrequencyDomainFeatures( raw,dT )
[FFT,Real,Imag,f]=MyFFT(dT,raw);

Features(1)=mean(FFT);
Features(2)=std(FFT);
Features(3)=mad(FFT);
[maxF,indMax]=max(FFT);
Features(4)=maxF;
Features(5)=f(indMax);

index=find(f>=20);
%for not HAR time series
index=index(1);
[minF,indMin]=min(FFT(1:index));
Features(6)=minF;
Features(7)=f(indMin);
Features(8)=iqr(FFT);
Features(9)=entropy(FFT);
Features(10)=var(FFT);
Features(11)=skewness(FFT);
Features(12)=kurtosis(FFT);
Features(13)=sum(abs(FFT).^2);
Features=[Features];


end

