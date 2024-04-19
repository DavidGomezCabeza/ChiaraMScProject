function [shift, ppm] = ChemicalShift(spectrum, freq,offset, freqRef)
    % Convert from Hz to ppm
    % spectrum = DataProces.DataBeforePhase{47,1}; 
    % % freq =  DataProces.freq{47,1};
    % offset= O1; 
    % freqRef = SF;
    ppm = ((freq - offset) / freqRef);
    
    % Flip and shift the spectrum
    % y = flip((real(fftshift(spectrum))));
    [~, maxIndex] = max(spectrum);
    corresponding_ppm = ppm(maxIndex(1));
    shift = corresponding_ppm- 171;
end
