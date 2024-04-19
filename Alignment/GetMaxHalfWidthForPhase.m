function MaxHalfWidth = GetMaxHalfWidthForPhase( Spec, PeakIndex )
%  get the full width of half width
%  Input 
%         Spec: the real data of speactrum data
%         PeakIndex: peak index
%  Output
%         MaxHalfWidth: the full width of half width
% 
%  Programmer: qingjia bao, lichen

% % DA ELIMINARE -------
% Spec= real( PhaseDataAfterCon )-Baseline';  
%Spec= real( PhaseDataAfterCon ); 
% --------------------

PeakSize = length(PeakIndex);
HalfWidth = [];
if length(PeakSize)>1
    for i = 2:PeakSize-1
        temp  = Spec(PeakIndex(i));
        leftIndex = PeakIndex(i);
        rightIndex = PeakIndex(i);
        if(Spec(PeakIndex(i)) > 0)
            while(temp > Spec(PeakIndex(i))/2)
                leftIndex = leftIndex -1;
                if(i > 1 && leftIndex == PeakIndex(i-1))    % Neighbouring peaks are encountered before the point where Spec(PeakIndex(i))/2 is encountered
                    leftIndex = PeakIndex(i-1);
                    break;
                end
                if(Spec(leftIndex-1) > Spec(leftIndex))  % hit a turning point
                    leftIndex = leftIndex-1;
                    break;
                end
                if(leftIndex <= 1)
                    leftIndex = 1;
                    break;
                end
                temp = Spec(leftIndex);
            end
            temp  = Spec(PeakIndex(i));
            while(temp > Spec(PeakIndex(i))/2)
                rightIndex = rightIndex + 1;
                if(i < PeakSize-1 && rightIndex == PeakIndex(i+1))
                    rightIndex = PeakIndex(i+1);
                    break;
                end
                if(i < PeakSize-1 && Spec(rightIndex+1) > Spec(rightIndex))
                    rightIndex = rightIndex+1;
                    break;
                end
                if(rightIndex >= length(Spec))
                    rightIndex = length(Spec);
                    break;
                end
                temp = Spec(rightIndex);
            end
            HalfWidth = [HalfWidth rightIndex - leftIndex + 1];
        end
        if(Spec(PeakIndex(i)) < 0)
            while(temp < Spec(PeakIndex(i))/2)
                leftIndex = leftIndex -1;
                if(i > 1 && leftIndex == PeakIndex(i-1))
                    leftIndex = PeakIndex(i-1);
                    break;
                end
                if(leftIndex <= 1)
                    leftIndex = 1;
                    break;
                end
                temp = Spec(leftIndex);
            end
            temp  = Spec(PeakIndex(i));
            while(temp < Spec(PeakIndex(i))/2)
                rightIndex = rightIndex + 1;
                if(i < PeakSize && rightIndex == PeakIndex(i+1))
                    rightIndex = PeakIndex(i+1);
                    break;
                end
                if(rightIndex >= length(Spec))
                    rightIndex = length(Spec);
                    break;
                end
                temp = Spec(rightIndex);
            end
            HalfWidth = [HalfWidth rightIndex - leftIndex + 1];
        end
        i = i+ 1;
    end
else
i = 1; 
if isempty(PeakIndex)==0
temp  = Spec(PeakIndex(i));
leftIndex = PeakIndex(i);
rightIndex = PeakIndex(i);
    if(Spec(PeakIndex(i)) > 0)
        while(temp > Spec(PeakIndex(i))/2)
            leftIndex = leftIndex -1;
            if(i > 1 && leftIndex == PeakIndex(i-1))    % Neighbouring peaks are encountered before the point where Spec(PeakIndex(i))/2 is encountered
                leftIndex = PeakIndex(i-1);
                break;
            end
            if(Spec(leftIndex-1) > Spec(leftIndex))  % hit a turning point
                leftIndex = leftIndex-1;
                break;
            end
            if(leftIndex <= 1)
                leftIndex = 1;
                break;
            end
            temp = Spec(leftIndex);
        end
        temp  = Spec(PeakIndex(i));
        while(temp > Spec(PeakIndex(i))/2)
            rightIndex = rightIndex + 1;
            if(i < PeakSize-1 && rightIndex == PeakIndex(i+1))
                rightIndex = PeakIndex(i+1);
                break;
            end
            if(i < PeakSize-1 && Spec(rightIndex+1) > Spec(rightIndex))
                rightIndex = rightIndex+1;
                break;
            end
            if(rightIndex >= length(Spec))
                rightIndex = length(Spec);
                break;
            end
            temp = Spec(rightIndex);
        end
        HalfWidth = [HalfWidth rightIndex - leftIndex + 1];
    end
    if(Spec(PeakIndex(i)) < 0)
        while(temp < Spec(PeakIndex(i))/2)
            leftIndex = leftIndex -1;
            if(i > 1 && leftIndex == PeakIndex(i-1))
                leftIndex = PeakIndex(i-1);
                break;
            end
            if(leftIndex <= 1)
                leftIndex = 1;
                break;
            end
            temp = Spec(leftIndex);
        end
        temp  = Spec(PeakIndex(i));
        while(temp < Spec(PeakIndex(i))/2)
            rightIndex = rightIndex + 1;
            if(i < PeakSize && rightIndex == PeakIndex(i+1))
                rightIndex = PeakIndex(i+1);
                break;
            end
            if(rightIndex >= length(Spec))
                rightIndex = length(Spec);
                break;
            end
            temp = Spec(rightIndex);
        end
        HalfWidth = [HalfWidth rightIndex - leftIndex + 1];
    end
    i = i+ 1;
end
end

[ MaxHalfWidth, MaxIndex ] = max( HalfWidth );
% disp( MaxHalfWidth )
% disp( MaxIndex )
end

