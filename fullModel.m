clear; close all; clc;

%Dependent variables
chirpLength = 500e-6;
LOdist = 50e-3;
LOSdist = 50e-3;
MPdist1 = 2;
MPdist2 = 2.25;
%MPdist3 = 3;
v = 2.6e+8;

%Set variables
bandwidth = 150e+6;
fs = bandwidth*2;
t = linspace(0,chirpLength,fs);
c = 3e+8;

%figure(1);
oscillatorOut = chirp(t, 0, chirpLength, bandwidth);
%spectrogram(oscillatorOut,1024,1000,1024,fs,'yaxis');

%figure(2);
filterOut = 10^((30-3)/10)*oscillatorOut;
clear oscillatorOut
%spectrogram(filterOut,1024,1000,1024,fs,'yaxis');

LOtime = LOdist / v;
LOStime = LOSdist / c;
MP1time = MPdist1 / c; 
MP2time = MPdist2 / c; 
%MP3time = MPdist3 / c; 

secondsPerSample = chirpLength / c;  

LOindex = floor(LOtime / secondsPerSample) + 1;
LOSindex = floor(LOStime / secondsPerSample) + 1;
MP1index = floor(MP1time / secondsPerSample) + 1;
MP2index = floor(MP2time / secondsPerSample) + 1;
%MP3index = floor(MP3time / secondsPerSample) + 1;

LO = [filterOut(LOindex:length(filterOut)) filterOut(1:LOindex-1)];
LOS = [filterOut(LOSindex:length(filterOut)) filterOut(1:LOSindex-1)];
MP1 = [filterOut(MP1index:length(filterOut)) filterOut(1:MP1index-1)];
MP2 = [filterOut(MP2index:length(filterOut)) filterOut(1:MP2index-1)];
clear filterOut
%MP3 = [filterOut(MP3index:length(filterOut)) filterOut(1:MP3index-1)];

HPAgain = 10^(3);
LOSloss = 1;%10^(-2);
MP1loss = 1;%10^(-3);
MP2loss = 1;%10^(-3.5);
%MP3loss = 1;%10^(-5);
signal = HPAgain * ((LOSloss * LOS) + (MP1loss * MP1) + ...
          (MP2loss * MP2));% + (MP3loss * MP3));
clear LOS MP1 MP2 %MP3

%figure(3);
%spectrogram(signal,1024,1000,1024,fs,'yaxis');

figure(1);
mixOut = LO .* signal;
clear signal LO
fsMix = 1e+6;
spectrogram(mixOut,1024,1000,1024,fsMix,'yaxis');
%plot(f, abs(fftshift(fft(mixOut))));