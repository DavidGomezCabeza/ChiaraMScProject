function [RP, SF , O1 ,  Bounds] = ParameterSelection(DataParameters)

    desiredParameter = 'ReceiverPoints';
    ReceiverPoints= MatchingResults(DataParameters, desiredParameter);
    RP= 2 * str2double(ReceiverPoints{2, 1}) * str2double(ReceiverPoints{3, 1}); % Receiver Points
    
    % If working with the carbon, add a space after the word
    desiredParameter = 'SF ' ;
    BaseFrequency = MatchingResults(DataParameters, desiredParameter); 
    SF = str2double(BaseFrequency{2,1}); % X-Channel Base Frequency 
    
    % If working with the carbon, add a space after the word
    desiredParameter = 'O1 ';
    OffsetFrequency = MatchingResults(DataParameters, desiredParameter); 
    O1 = str2double(OffsetFrequency{2,1}); % X-Channel Frequency Offset [Hz]
    
    desiredParameter = 'Filter';
    Filter = MatchingResults(DataParameters, desiredParameter); 
    Bounds = str2double(Filter{2,1}); % X-Channel Frequency Offset [Hz]

end