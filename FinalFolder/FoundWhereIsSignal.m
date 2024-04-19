function [IndPeaks,ValPeaks, ReferenceSpectrum] =FoundWhereIsSignal(DataBeforePhase,meanVal,stdVal, num,freq)

% reference spectrum  not considering the division between signal and noise 
% DataBeforePhase iis the absolute value 
% random initialisation percentage of noise 
DataBeforePhase = abs(real(DataProces.DataBeforePhase{41,1}))
np = 10;  % percentage noise
npSample = round((length(DataBeforePhase))*(np/100)); 

meanNoise = mean(abs(real(DataBeforePhase(1:npSample))));
stdNoise = std(real(DataBeforePhase(1:npSample)));
threshold_noise = meanNoise +  3*stdNoise; 

indOver = find(abs(DataBeforePhase)>threshold_noise); 
temp = diff(indOver);
temp2 = find(temp==1); 
Over = indOver(temp2); % range containing the signal
meanSgn =  mean(real(DataBeforePhase(Over(1):Over(end)))); 
stdSgn =  std(real(DataBeforePhase(Over(1):Over(end)))); 
threshold_sng = meanSgn + 3*stdSgn;

newMeanNoise = mean(real(DataBeforePhase(1:Over(1)-1)));
newStdNoise = std(real(DataBeforePhase(1:Over(1)-1))); 
new_threshold_noise = newMeanNoise +3*newStdNoise;

[IndPeaks{i,1}, ValPeaks{i,1}] = findpeaks(DataBeforePhase(Over(1):Over(end)), 'MinPeakHeight',threshold_sng, 'MinPeakDistance', 50, 'MinPeakWidth',5)

% if the signal number is lower then 4, find the index and peak value for each spectrum. Otherwise 
% check only the signal from the third to the end. 

% num = number of signal 

end