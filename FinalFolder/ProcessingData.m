function [freq, DataBeforePhase, spectrum,  meanVal, stdVal] = ProcessingData(fid_delay,delay, bnd)

    fid=fid_delay(delay:end); % signal FID without delay 
   
    n = length(fid); % number of rows 
    M = repmat((1:n)',1,1); 
    real_part=M(1:2:end,:); % odd matrix
    real_fid = fid(real_part); 
    img_part=M(2:2:end,:); % even matrix
    img_fid = fid(img_part); 
    
    new_fid = complex(real_fid, img_fid);
    
    freq = linspace(-bnd/2, bnd/2, length(new_fid)); % frequency 
    t = linspace(1, 1/(freq(2)-freq(1)), length(new_fid)); % time
    spectrum = fft(new_fid); % fft 

    % mean and standar deviation computing 
    meanVal = mean((real(spectrum))); % mean val 
    stdVal = std((real(spectrum))); % std val 

    % 
    % DataBeforePhase=fftshift(fid_spectrum');
    %  sensitivity
    % test using only the width of the higher peak 

    [~,~, W12] = findpeaks(abs(real(spectrum)), 'MinPeakHeight', max(abs(real(spectrum))-1)); 
    Rlb3 = (freq(end)-freq(end-round(W12))); % rate constant
    w = exp(-Rlb3*t); % weighting function 
    sum = 1-max(w);
    w2 = w+sum; 
    fid_enhan= new_fid.*w2'; 

    DataBeforePhase= fft(fid_enhan); % stat signal 
    DataBeforePhase = fftshift(DataBeforePhase');  % try to use the fft shifted 

end