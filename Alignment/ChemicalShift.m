function [shift, ppm] = ChemicalShift(spectrum, freq,offset, freqRef)
    % Convert from Hz to ppm
    ppm = ((freq - offset) / freqRef);
    
    % Flip and shift the spectrum
    y = flip((real(fftshift(spectrum))));
    [~, maxIndex] = max(y);
    corresponding_ppm = ppm(maxIndex(1));
    shift = corresponding_ppm- 171;
end