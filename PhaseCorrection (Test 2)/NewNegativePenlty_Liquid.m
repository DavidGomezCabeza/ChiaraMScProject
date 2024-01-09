function [ NegativeArea ] = NewNegativePenlty_Liquid( Phase, SpecData, PeakInfo, IdentifyResult, Weight, L , a_num, FinalPhase )
%  negative penlty function
%  Input 
%         Phase: the input of phase
%         SpecData: the real data of speactrum data
%         PeakInfo: the peak information
%         IdentifyResult: the mark array of aberrant peak 
%         Weight: the mark array of peak
%         L: the size of data
%
%  Output
%         NegativeArea: the area of the negative part
% 
%  Programmer: qingjia bao, lichen

% a_num = -( ( 1 : L ) ) / ( L );

% phi = (FinalPhase*0 + deg2rad(Phase(2)) * a_num);  % (pi/180) 
% R = real(SpecData).*cos(phi) - imag(SpecData).*sin(phi); 
% I = real(SpecData).*sin(phi) + real(SpecData).*sin(phi); 
% FinalData = complex(R, I);

% if Phase(2) > 100 || Phase(2)<-100
%     Phase(2) = Inf;
% end
FinalData = SpecData .* exp( sqrt(-1) * ( FinalPhase( 1 )*0+ Phase(2)*a_num  ) ); % non applico la correzione ph0 perché se no implicherebbe che avrei di nuovo picchi negativi e questo inciderebbe sul risultato 

% calculate baseline
Temp  = real( FinalData );
E = speye( L );
D = diff( E, 1 );
W = spdiags( Weight, 0, L, L );
C = chol( W + 1600 * D' * D );
BaseLine = C\( C'\( Weight .* Temp' ) );

% baseline correction
FinalRealData = Temp - BaseLine'; % temporary spectrum 
FinalRealData2 = Temp - BaseLine';

% calculate the area of the negative part
for i = 1 : length( PeakInfo )
    if( IdentifyResult( i ) == 0 ) % distorted
        FinalRealData( PeakInfo( i ).Start:PeakInfo( i ).End ) = zeros( 1,length( PeakInfo( i ).Start:PeakInfo( i ).End ) ); % TempR(i) = 0
    end
    if( IdentifyResult( i ) == -1 ) %negative
        FinalRealData( PeakInfo( i ).Start:PeakInfo( i ).End ) = FinalRealData( PeakInfo( i ).Start:PeakInfo( i ).End ); % TempR(i)=-R(i)  % capire se lasciare il - o no 
    end
end

% neg_FinalRealData = abs( FinalRealData ) - FinalRealData;
neg_FinalRealData = FinalRealData - abs( FinalRealData );
% take the total area of the negative part after quadratic transformation
NegativeArea = sum( neg_FinalRealData.^2 );

% NegativeArea = sum( FinalRealData.^2 );
% 
% if max(real(FinalRealData))~=max(abs(real(FinalRealData)))
%     NegativeArea = NegativeArea*10^10;
% end

end

