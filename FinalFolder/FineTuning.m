function [NegativePhase, FineTuningData] = FineTuning(PhaseDataAfterCon, a_num, FinalPhase)
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
    
    % % Adjust the CWT factor based on specific conditions
    % if MaxHalfWidth < 5 || MaxHalfWidth > DataSize / 16 || isempty(MaxHalfWidth)
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
    % Baseline= Baseline';
    
    % Identify positive peaks, negative peaks, and distorted peaks 
    % (-1 for negative peaks, 0 for distorted peaks, 1 for positive peaks)
    IdentifyResult = IdentifyPeak_Liquid(  PeakInfo, real( PhaseDataAfterCon ) - Baseline');
    
    % Get the optimized phase 
    options = optimset( 'TolFun', 1, 'TolX', 0.1, 'MaxIter', 1000 );
    
    % Perform optimization to find negative phase parameters
    [NegativePhase,NegativeArea,exitflag,output] = fminSearchTest_Liquid(...
        @(Phase) NewNegativePenlty_Liquid2(Phase, PhaseDataAfterCon, PeakInfo, IdentifyResult, Weight, DataSize, a_num ,FinalPhase), ...
        [0,0], options);
    
    % Apply negative phase correction to the data
    DataAfterNegative = PhaseDataAfterCon  .* exp( sqrt(-1) * ( FinalPhase( 1 )*0+ NegativePhase( 2 )*a_num  ) );
    
    % Calculate baseline using Cholesky decomposition
    Temp  = real( DataAfterNegative );
    L = length(Temp);
    E = speye( L );
    D = diff( E, 1 );
    W = spdiags( Weight, 0, L, L );
    C = chol( W + 1600 * D' * D );
    BaseLine = C\( C'\( Weight .* Temp' ) );
    
    % Baseline correction
    FineTuningData = Temp - BaseLine';
end