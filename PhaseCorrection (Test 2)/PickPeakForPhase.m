function [PeakValue PeakIndex]= PickPeak( Spec , NoiseFactor)
%  get the peak value and index
%  Input 
%         Spec: the real data of speactrum data
%         NoiseFactor : noise factor
%  Output
%         PeakValue: peak value
%         PeakIndex: peak index
% 
%  Programmer: qingjia bao, lichen

% % DA ELIMINARE -------
% Spec= real( PhaseDataAfterCon )-Baseline';  
% NoiseFactor= 8; 
% --------------------

StartOfNoise = 1;
DiffData = real(Spec);
DiffDataSize = length(DiffData);

% calculate noise level
NoisePoint = round(DiffDataSize / 32);
tempNoise = zeros(1,32);
for i = 1:32
    tempNoise(i) = max(DiffData(StartOfNoise + (i-1) * NoisePoint : StartOfNoise + (i) * NoisePoint - 1))-min(DiffData(StartOfNoise + (i-1) * NoisePoint : StartOfNoise + (i) * NoisePoint - 1));
end
Noise = min(tempNoise);
Noise = Noise * NoiseFactor;

L = length( Spec );
PeakIndex = [];
PeakValue = [];
for i = 20: L-20
    if( Spec(i-1) > Noise && Spec(i+1) > Noise...
        &&Spec(i-2) > Noise && Spec(i+2) > Noise...
        &&Spec(i-3) > Noise && Spec(i+3) > Noise...
        &&Spec(i-4) > Noise && Spec(i+4) > Noise...
            && Spec(i) > Spec(i-1) && Spec(i) > Spec(i-2) && Spec(i) > Spec(i-3)&& Spec(i) > Spec(i-4) ...
            && Spec(i) > Spec(i+1) && Spec(i) > Spec(i+2)&& Spec(i) > Spec(i+3)&& Spec(i) > Spec(i+4))
        PeakIndex = [PeakIndex i];
        PeakValue = [PeakValue Spec(i)];
    end
    if( -Spec(i-1) > Noise && -Spec(i+1) > Noise...
        &&-Spec(i-2) > Noise && -Spec(i+2) > Noise...
        &&-Spec(i-3) > Noise && -Spec(i+3) > Noise...
        &&-Spec(i-4) > Noise && -Spec(i+4) > Noise......
            &&-Spec(i) > -Spec(i-1) && -Spec(i) > -Spec(i-2) && -Spec(i) > -Spec(i-3)&& -Spec(i) > -Spec(i-4)...
            && -Spec(i) > -Spec(i+1) && -Spec(i) > -Spec(i+2)&& -Spec(i) > -Spec(i+3)&& -Spec(i) > -Spec(i+4))
        PeakIndex = [PeakIndex i];
        PeakValue = [PeakValue Spec(i)];        
    end
    i = i + 1;
end
end