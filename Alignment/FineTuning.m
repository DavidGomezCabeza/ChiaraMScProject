function [PeakInfo,  IdentifyResult, Weight] = FineTuning(PhaseDataAfterCon)
    % Calculate the continuous wavelet transform (CWT) factor based on the full
    % width at half height of the spectra
    DataSize = length( PhaseDataAfterCon );
    PeakInfo  =  GetPeaks( real( PhaseDataAfterCon ), 6, 0.001 );
    Weight  =  ones( length( PhaseDataAfterCon ), 1 );
    
    % Set weights to 0 for regions around identified peaks
    for i  =  1 : length( PeakInfo )
        Weight( PeakInfo( i ).Start : PeakInfo( i ).End )  =  0;
    end
    
    % Perform automatic baseline correction
    Baseline  =  AutoBaseCorr_Liquid( real( PhaseDataAfterCon )', Weight, DataSize ); 
    
    % Pick peaks for phase identification
    [PeakValue, PeakIndex] =  PickPeakForPhase( real( PhaseDataAfterCon )-Baseline', 8 );
    MaxHalfWidth  =  GetMaxHalfWidthForPhase(real( PhaseDataAfterCon )-Baseline', PeakIndex);
    
    % Calculate the CWT factor based on the maximum half-width
    cwtfactor =  MaxHalfWidth  /  DataSize;
    cwtfactor  =  0.0008; % Default value
    
    % Adjust the CWT factor based on specific conditions
    % if MaxHalfWidth < 5 || MaxHalfWidth > DataSize / 16 || isempty(MaxHalfWidth)==1
    %     cwtfactor = 0.0008;
    % end
    
    % Recalculate PeakInfo using the adjusted CWT factor
    PeakInfo  =  GetPeaks_Liquid( real( PhaseDataAfterCon ), 6, cwtfactor ); 
    
    % Initialize weights for peaks and baseline (0 for peaks, 1 for baseline)
    Weight = ones( length(PhaseDataAfterCon ),1 );
    for i = 1 : length( PeakInfo )
        Weight( PeakInfo( i ).Start:PeakInfo( i ).End ) = 0;
    end
    
    % Perform baseline correction using identified weights
    Baseline = AutoBaseCorr_Liquid( real( PhaseDataAfterCon )', Weight, DataSize );
    Baseline= Baseline';
    
    % Identify positive peaks, negative peaks, and distorted peaks 
    % (-1 for negative peaks, 0 for distorted peaks, 1 for positive peaks)
    IdentifyResult = IdentifyPeak_Liquid(  PeakInfo, real( PhaseDataAfterCon ) - Baseline');
end