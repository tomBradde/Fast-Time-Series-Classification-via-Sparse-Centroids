
function [F,f]=MyFFT(dT,y)
                % Sampling Time(s)
Fs = 1/dT;                   % Sampling rate, Sampling Freq (Hz)


%Calculate time axis



L = length (y); % Window Length of FFT    
nfft = 2^nextpow2(L); % Transform length

y_HannWnd = y.*hanning(L);            
Ydft_HannWnd = fft(y_HannWnd,nfft)/L;

   % at all frequencies except zero and the Nyquist
   mYdft = abs(Ydft_HannWnd);
   mYdft = mYdft (1:nfft/2+1);
   mYdft (2:end-1) = 2* mYdft(2:end-1);

f = Fs/2*linspace(0,1,nfft/2+1); 

%   figure(1),
%   subplot(2,1,1)
%   plot(t,y)
%   title('Time Domain Input');
%   xlabel('Time (s)'); 
%   ylabel('Input Trend');
%   subplot(2,1,2)  
%   plot(f,2*mYdft); 
%    xlim ([0 2*largerPole]); %Zoom in 
%   title('Amplitude Spectrum of the first input with Hann Window');
%   xlabel('Frequency (Hz)'); 
%   ylabel('Abs(U(f))');
end