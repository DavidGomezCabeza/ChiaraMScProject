function z  = AutoBaseCorr_Liquid( RealSpecData, Weight, m )
%  get the baseline of spectra
%  Input 
%         RealSpecData: the real data of speactrum data
%         Weight: the weight of peak and baseline, the weight of peak is 1,
%         the weight of baseline is 0
%  Output
%         z: the baseline of spectra
% 
%  Programmer: qingjia bao, lichen

% % DA ELIMINARE -------
% RealSpecData= real( PhaseDataAfterCon )';  
% m = length(RealSpecData); 
% --------------------

% m = DataSize; % data = y 
% D = diff(speye(m)); 
% W = spdiags( Weight, 0, m, m );
% B = W +1600*(D' * D);
% C = Weight.*RealSpecData; 
% z = inv(B).*C'; 


E = speye( m );
D = diff( E, 1 );
W = spdiags( Weight, 0, m, m );

C = chol( W + 1600 * D' * D );
z = C \ ( C' \ ( Weight .*  RealSpecData ) );
