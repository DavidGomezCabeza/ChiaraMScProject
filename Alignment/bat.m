function [ output_args ] = Test( input_args )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for DeltaPhase =  1: 1 : 15
    AutoPhasecorrInterface( DeltaPhase );
end
end

