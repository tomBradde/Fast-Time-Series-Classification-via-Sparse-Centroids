function [ Features,time] = ExtractFrequencyDomainFeaturesSTD( raw,dT )
tic
[FFT,Real,Imag,f]=MyFFT(dT,raw);
timeFFT=toc;

tic
Features(1)=mean(FFT);
time(1)=toc;
tic
Features(2)=std(FFT);
time(2)=toc;
tic
Features(3)=mad(FFT);
time(3)=toc;
tic
[maxF,indMax]=max(FFT);

Features(4)=maxF;
time(4)=toc;
tic
Features(5)=f(indMax);
time(5)=toc;

% index=1;
tic
[minF,indMin]=min(FFT(1:end));


Features(6)=minF;
time(6)=toc;
tic
Features(7)=f(indMin);
time(7)=toc;
tic
Features(8)=iqr(FFT);
time(8)=toc;
tic
Features(9)=entropy(FFT);
time(9)=toc;
tic
Features(10)=var(FFT);
time(10)=toc;
tic
Features(11)=skewness(FFT);
time(11)=toc;
tic
Features(12)=kurtosis(FFT);
time(12)=toc;
tic
Features(13)=sum(abs(FFT).^2);
time(13)=toc;
time=time+timeFFT;
time=[time,timeFFT*ones(1,length(Real)*2)];
Features=[Features,Real',Imag'];

end

