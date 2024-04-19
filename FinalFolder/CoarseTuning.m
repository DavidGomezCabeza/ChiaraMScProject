function [FinalPhase, PhaseDataAfterCon] = CoarseTuning(ReferenceSpectrum)

    DataBeforePhase =ReferenceSpectrum;
    % Spectrum corrrection using optimized phase
    % Get peak information from the spectrum
    PeakInfo  =  GetPeaks_Liquid( DataBeforePhase, 6, 0.0008 );
    
    % Inizialization variables for phase optimization
    Phase = zeros( 8,2 );
    BaseContinuty = zeros( 8,1 );
    options  =  optimset( 'TolFun', 1e-1, 'TolX', 0.01, 'MaxIter', 5000 );
    
    % Perform phase optimization with different inizialization
    for k = 1:2
        for i = 1:4
            % Set initial phase values for optimization
            InitiaPh0Test  =  0 +  k * 90;
            InitiaPh1Test = -180  +  ( i-1 ) * 90;
    
            % Perform optimization using fminsearch
            [Phase( i + ( k-1 ) * 4, : ), BaseContinuty( i + ( k-1 ) * 4 )]  =  ...
                 fminsearch( @( Phase )MinPeakContinuity_Liquid(  Phase, DataBeforePhase, PeakInfo ), [InitiaPh0Test ,InitiaPh1Test ], options );
        end
    end
    
    % Select the optimized phase with the minimum base continuity
    [MinBaseContinuty, Index]  =  sort( BaseContinuty );
    FinalPhase  =  Phase( Index( 1 ),: );
    
    % Check if the second phase value is too large and choose another if needed
    iCount  =  2;
    while abs(FinalPhase(2)) > 300  && iCount <= length(BaseContinuty)
       FinalPhase  =  Phase(Index(iCount), :);
       iCount  =  iCount + 1;
    end
    
    % If the optimal phase is not found, display a message and use the default
    if iCount > length(BaseContinuty) 
        msgbox( 'cannot find the best phase value！' );
        FinalPhase = Phase( Index(1), :);
    end
    
    % Correct the spectrum using the optimized phase
    PhaseDataAfterCon  =  zeros(1, length(DataBeforePhase));
    PhaseDataAfterCon = DataBeforePhase .* exp(sqrt(-1) * deg2rad(FinalPhase(1)) );
    
    % Adjust the sign of the spectrum based on the maximum peak
    [MaxPeakValue, MaxPeakIndex]  =  max(abs(real(PhaseDataAfterCon)));
    if real( PhaseDataAfterCon(MaxPeakIndex)) < 0 
        PhaseDataAfterCon  =  -PhaseDataAfterCon; 
    end

end