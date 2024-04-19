function [ DataAfterNegative ] = AutoPhasecorrInterface( Num )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
% close all;
fname = '';
bVarianOrBruker = 1;
% Num =2;
switch(Num)
      case 1
           fname = 'varian_1H_D_5_23.fid'; %
      case 2
           fname = 'Varian_47.c.fid';%
      case 3
           fname = 'Varian_48.c.fid';
      case 4
           fname = 'Varian_A2-F1-1H.fid';%
      case 5
           fname = 'Varian_A2-F3-1H.fid';  
      case 6
           fname = 'Varian_c16_H1.fid'; %           
      case 7
           fname = 'Varian_fid1d.fid'; %        
      case 8
           fname = 'Varian_I-F2.fid';       
      case 9
           fname = 'Varian_K-F2.fid';    %   
      case 10
           fname = 'TopSpinData_exam1d_1H_1';%
           bVarianOrBruker = 2;
      case 11
           fname = 'TopSpinData_exam1d_1_H2';
           bVarianOrBruker = 2;
      case 12
           fname = 'TopSpinData_exam1d_13C_1';%
           bVarianOrBruker = 2;
      case 13
           fname = 'TopSpinData_exam1d_13C_2';
           bVarianOrBruker = 2;
      case 14
           fname = 'TopSpinData_exam1d_13C_3';
           bVarianOrBruker = 2;
      case 15
           fname = 'TopSpinData_exam1d_13C_4';
           bVarianOrBruker = 2;      
end

% get spectra data
resouceData=PhaseBeforeData(fname, bVarianOrBruker, Num);
DataSize=length(resouceData);
a_num = -((1:DataSize))/(DataSize);

% set swppm 
swppm = 10.9861;
offsetppm=9.39032;
ppmAxis=offsetppm:-swppm/(DataSize-1):(offsetppm-swppm);

figure( 2 * Num );
plot( ppmAxis, real(resouceData) );

% Automatic phase correction 
DataAfterPhase  = AutoPhaseCorr( resouceData );

figure(2 * Num + 1 );
plot(ppmAxis, real(DataAfterPhase));

display('over')
