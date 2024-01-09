function PeakContinutity = MinPeakContinuity_Liquid(  Phase, DataBeforePhase,PeakInfo )
%  get the height difference between starts and ends of the peak
%  Input 
%         Phase: the input of phase
%         DataBeforePhase: the real data of speactrum data
%         PeakInfo: the peak information
%
%  Output
%         PeakContinutity: the height difference between starts and ends of the peak
% 
%  Programmer: qingjia bao, lichen

L = length( DataBeforePhase);
PeakContinutity = 0;
for i = 1 : length(  PeakInfo )
    TempPeakStart = PeakInfo( i ).Start;
    TempPeakEnd =  PeakInfo( i ).End;
    if( TempPeakStart < L/30 && TempPeakEnd <  L/30 )
        continue;
    end
    if( TempPeakStart > L - L/30 && TempPeakEnd  > L - L/30 )
        continue;
    end
    for k=1:1
        TempStartIndex =  TempPeakStart - k;
        TempEndIndex =  TempPeakEnd - k;
        TempSart = -TempStartIndex / L;
        TempEnd = -TempPeakEnd / L;
        TempPhaseDataStart = DataBeforePhase( TempStartIndex ) * exp( j * pi/180 * ( Phase( 1 )+Phase( 2 ) * TempSart ) );
        TempPhaseDataEnd = DataBeforePhase( TempEndIndex ) *  exp( j * pi/180 * ( Phase( 1 )+Phase( 2 ) * TempEnd ) );
        PeakContinutity = PeakContinutity + abs( real( TempPhaseDataStart ) - real( TempPhaseDataEnd ) );
    end
end
end

