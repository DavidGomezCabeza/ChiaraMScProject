function IdentifyResult = IdentifyPeak_Liquid( Peak, RealSpectraData )
%  identify positive peak¡¢negative peak and distorted peak
%  Input 
%         Peak: the peak info
%         RealSpectraData: the real data of speactrum data
%  Output
%         IdentifyResult: the result of identification
% 
%  Programmer: qingjia bao, lichen

PeakNum = length( Peak );
IdentifyResult = zeros( PeakNum, 1 );

% get the noise level
SelectFactor = 0.9; 
L = length( RealSpectraData );
NoiseLevel = 4 * std( RealSpectraData( 1 : round(L/32) ) );

% identify positive peak¡¢negative peak and distorted peak
for i = 1:PeakNum
    AbsPeakArea = sum( abs( RealSpectraData( Peak( i ).Start:Peak( i ).End ) ) );
    PositiveArea = 0;
    NegativeArea = 0;
    DataSmallZero = find( RealSpectraData( Peak( i ).Start : Peak( i ).End ) < 0 );
    DataLargerZero = find( RealSpectraData( Peak( i ).Start : Peak( i ).End ) > 0 );
    MinSmallZeros = min( RealSpectraData( Peak( i ).Start + DataSmallZero ) );
    MaxLargeZeros = max( RealSpectraData( Peak( i ).Start + DataLargerZero ) );
    if( abs( MinSmallZeros ) > NoiseLevel & abs( MinSmallZeros ) < MaxLargeZeros )
        IdentifyResult( i ) = 0;
        continue;
    end
    if( ( MaxLargeZeros ) > NoiseLevel & abs( MinSmallZeros ) > MaxLargeZeros )
        IdentifyResult( i ) = 0;
        continue;
    end
        
    for j = Peak( i ).Start : Peak( i ).End
        if( RealSpectraData( j ) > 0 )
            PositiveArea = PositiveArea + RealSpectraData( j );
        end
        if( RealSpectraData( j ) < 0 )
            NegativeArea = NegativeArea + abs( RealSpectraData( j ) );
        end
    end
    if( PositiveArea > SelectFactor * AbsPeakArea )
        IdentifyResult( i ) = 1;
    end
    if( NegativeArea > SelectFactor * AbsPeakArea )
        IdentifyResult( i ) = -1;
    end
    [MaxHeight, Index] = max( abs( RealSpectraData( Peak( i ).Start : Peak( i ).End ) ) );
    PeakHeight = RealSpectraData( Index + Peak( i ).Start-1 );
    if( NegativeArea > PositiveArea )
        bPositive = false;
    else
        bPositive = true;
    end
    if( PeakHeight > 0 && bPositive == false )
        IdentifyResult( i ) = 0;
    end
    if( PeakHeight < 0 && bPositive ==true )
        IdentifyResult( i ) = 0;
    end
end