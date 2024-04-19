function [ DataAfterNegative ] = AutoPhaseCorr( DataBeforePhase, PeakInfoOut )
%  auto phase correction
%  Input 
%         DataBeforePhase: the real data of speactrum data
%  Output
%         DataAfterNegative: the spectrum after phase correction
% 
%  Programmer: qingjia bao, lichen

DataSize = length( DataBeforePhase );
a_num  =  -( ( 1:DataSize ) )  /  ( DataSize );

%% first step: coarse tuning

%  search peak
PeakInfo  =  GetPeaks_Liquid( DataBeforePhase, 6, 0.0008 );

% get a group of the optimized phase from different initialization
Phase = zeros( 8,2 );
BaseContinuty = zeros( 8,1 );
options  =  optimset( 'TolFun', 1e-1, 'TolX', 0.01, 'MaxIter', 5000 );
for k = 1:2
    for i = 1:4
        InitiaPh0Test  =  0 +  k * 90;
        InitiaPh1Test = -180  +  ( i-1 ) * 90;
        [Phase( i + ( k-1 ) * 4, : ), BaseContinuty( i + ( k-1 ) * 4 )]  =  fminsearch( @( Phase )MinPeakContinuity_Liquid(  Phase, DataBeforePhase, PeakInfo ), [InitiaPh0Test, InitiaPh1Test], options );
    end
end

% select the optimized phase from the group
[MinBaseContinuty, Index]  =  sort( BaseContinuty );
FinalPhase  =  Phase( Index( 1 ),: );
PhaseDataAfterCon  =  zeros( 1, length( DataBeforePhase ) );
iCount  =  2;
while( abs( FinalPhase( 2 ) ) > 300  && iCount <=  length( BaseContinuty ) );
%    msgbox( '最优一阶相位值超过300' );
   FinalPhase  =  Phase( Index( iCount ),: );
   iCount  =  iCount  +  1;
end
if ( iCount > length( BaseContinuty ) ) 
    msgbox( 'cannot find the best phase value！' );
    FinalPhase  =  Phase( Index( 1 ), : );
end
% correct the spectra by coarse tuning result
PhaseDataAfterCon  =  DataBeforePhase .*  exp( j * pi / 180 * ( FinalPhase( 1 )  + FinalPhase( 2 ) * a_num ) );

[ MaxPeakValue, MaxPeakIndex ]  =  max( abs( real( PhaseDataAfterCon ) ) );
if( real( PhaseDataAfterCon( MaxPeakIndex ) ) < 0 )
    PhaseDataAfterCon  =  -PhaseDataAfterCon;
end 

 %% second step: fine tuning

 % calculate the cwt factor according to the full width of half height of spectra
PeakInfo  =  GetPeaks( real( PhaseDataAfterCon ), 6, 0.001 );
Weight  =  ones( length( DataBeforePhase ), 1 );
for i  =  1 : length( PeakInfo )
    Weight( PeakInfo( i ).Start : PeakInfo( i ).End )  =  0;
end
Baseline  =  AutoBaseCorr_Liquid( real( PhaseDataAfterCon ), Weight, DataSize );
[PeakValue, PeakIndex] =  PickPeakForPhase( real( PhaseDataAfterCon )-Baseline', 8 );
MaxHalfWidth  =  GetMaxHalfWidthForPhase( real( PhaseDataAfterCon )-Baseline', PeakIndex );
cwtfactor =  MaxHalfWidth  /  DataSize;
    cwtfactor  =  0.0008;
if( MaxHalfWidth < 5  )
    cwtfactor  =  0.0008;
end
if( MaxHalfWidth > DataSize / 16 )
    cwtfactor  =  0.0008;
end
if( length( MaxHalfWidth )  ==  0 )
    cwtfactor  =  0.0008;
end
PeakInfo  =  GetPeaks_Liquid( real( PhaseDataAfterCon ), 6, cwtfactor ); 

% initialize the weight of peak and baseline by prak information, 0 is
% peak; 1 is baseline
Weight = ones( length( DataBeforePhase ),1 );
for i = 1 : length( PeakInfo )
    Weight( PeakInfo( i ).Start:PeakInfo( i ).End ) = 0;
end

% get the baseline
Baseline = AutoBaseCorr_Liquid( real( PhaseDataAfterCon ), Weight, DataSize );

% identify the positive peak，negative peak and distorted peak
IdentifyResult = IdentifyPeak_Liquid(  PeakInfo, real( PhaseDataAfterCon ) - Baseline' );

% get the optimized phase 
options = optimset( 'TolFun', 1, 'TolX', 0.1, 'MaxIter', 100 );
[NegativePhase,NegativeArea,exitflag,output] = fminSearchTest_Liquid( @( Phase )NewNegativePenlty_Liquid( Phase, PhaseDataAfterCon, PeakInfo, IdentifyResult, Weight, DataSize ),[0,0],options );

DataAfterNegative = PhaseDataAfterCon .*  exp( j * pi / 180 * ( NegativePhase( 1 ) + ( NegativePhase( 2 ) ) * a_num ) );
pahse0 = FinalPhase( 1 )  +  NegativePhase( 1 );
phase1 = FinalPhase( 2 )  +  NegativePhase( 2 );
phase = [pahse0 phase1];

disp( 'over' )


