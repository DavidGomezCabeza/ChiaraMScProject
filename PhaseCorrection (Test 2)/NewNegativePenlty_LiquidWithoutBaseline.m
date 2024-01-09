function [ NegativeArea ] = NewNegativePenlty_LiquidWithoutBaseline( Phase,SpecData,PeakInfo,IdentifyResult ,Weight,L )
%NEWNEGATIVEPENLTY Summary of this function goes here
%   Detailed explanation goes here

% CAMBIATO IO --------------------------------------------
DataSize = size(SpecData);
distances = abs(DataSize- pivot);
a_num = zeros(1,DataSize);
a_num(distances < pivot) = -distances(distances < pivot);
a_num(distances > pivot) = distances(distances > pivot);
% --------------------------------------------------------


% a_num = -((1:L))/(L);
FinalData = SpecData .* exp(j*pi/180*(Phase(1)+ Phase(2)*a_num ));
%尝试进行基线校正
% BaseLine= AutoBaseCorr(real(FinalData),Weight,L);

FinalRealData = real(FinalData);

NegativeArea=0;

% for i=1:length(SpecData)
%     TempHeight=0;
%     if(TempHeight < 0)
%         TempHeight=abs(TempHeight)+200*(FinalRealData(i))^2;
%     end
%     NegativeArea=NegativeArea+TempHeight;
% end

for i=1:length(PeakInfo)
    if(IdentifyResult(i) == 1)
        FinalRealData(PeakInfo(i).Start:PeakInfo(i).End) = FinalRealData(PeakInfo(i).Start:PeakInfo(i).End)-(FinalRealData(PeakInfo(i).Start) + FinalRealData(PeakInfo(i).End))/2;
        UnWantedPoint=find(FinalRealData(PeakInfo(i).Start:PeakInfo(i).End)<-0);
        NegativeArea=NegativeArea+sum(FinalRealData(UnWantedPoint+PeakInfo(i).Start).^2);
        
    end
    if(IdentifyResult(i) == -1)
        FinalRealData(PeakInfo(i).Start:PeakInfo(i).End)=-FinalRealData(PeakInfo(i).Start:PeakInfo(i).End);
        FinalRealData(PeakInfo(i).Start:PeakInfo(i).End) = FinalRealData(PeakInfo(i).Start:PeakInfo(i).End)-(FinalRealData(PeakInfo(i).Start) + FinalRealData(PeakInfo(i).End))/2;
        UnWantedPoint=find(FinalRealData(PeakInfo(i).Start:PeakInfo(i).End)<-0);
        NegativeArea=NegativeArea+sum(FinalRealData(UnWantedPoint+PeakInfo(i).Start).^2);
    end
end




end

