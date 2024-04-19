function [delay ] = Delay(FIDdelay, ReceiverPoints)
    points_rec= 2 * str2double(ReceiverPoints{2, 1}) * str2double(ReceiverPoints{3, 1}); % Receiver Points
    points_act = length(FIDdelay);
    delay = points_act-points_rec-1; 
end