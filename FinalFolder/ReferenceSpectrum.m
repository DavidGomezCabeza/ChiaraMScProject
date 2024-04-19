function [IndPeaks,ValPeaks, ReferenceSpectrum] = ReferenceSpectrum (DataBeforePhase,meanVal,stdVal, num,freq)

% reference spectrum  not considering the division between signal and noise 


% if the signal number is lower then 4, find the index and peak value for each spectrum. Otherwise 
% check only the signal from the third to the end. 

% num = number of signal 

% initialization vectors
IndPeaks = {};
ValPeaks = {};
    
    for i=1:num  
        % envelope extraction 
        R2= (real(DataBeforePhase{i,1})).^2;
        I2= (imag(DataBeforePhase{i,1})).^2;
        new_sgn = real(sqrt(R2+I2));
        
        % new_sgn = abs(real(DataBeforePhase(i))); 
        
        % Initialisation of low-pass filter parameters
        fc = freq{end}/4; 
        Wn=fc/freq{end}; % cutoff frequency 
        [b_low,a_low] = butter(4,Wn, 'low');
        % freqz(b_low,a_low)
        
        sgn_filt = filtfilt(b_low,a_low, new_sgn); 
        threshold = meanVal{i,1}+3*stdVal{i,1}; 

        data = abs(real(DataBeforePhase{i,1})); 

        % find where there is the signal 
        np = 10;  % percentage nois
        npSample = round(data*(np/100)); 
        
        meanNoise = mean(data(1:npSample));
        stdNoise = std(data(1:npSample));
        threshold_noise = meanNoise +  3*stdNoise; 
        
        indOver = find(data>threshold_noise); 
        temp = diff(indOver);
        temp2 = find(temp==1); 
        Over = indOver(temp2); % range containing the signal

        % search peaks 
        [~, IndPeaks{i,1}] = findpeaks(sgn_filt,'MinPeakHeight', threshold, 'MinPeakDistance', 50);
        
        numP = length(IndPeaks{i,1}); 
        for j = 1:numP
            if IndPeaks{i,1}(j)<Over(1) || IndPeaks{i,1}(j)>Over(end)
                IndPeaks{i,1}(j) = 0; 
            end
        end
        IndPeaks{i,1}( IndPeaks{i,1}==0)=[];
        NumPeaks{i,1} = length(IndPeaks{i,1});
    end

    [~, ReferenceSpectrum] = max(cell2mat(NumPeaks)); 
end