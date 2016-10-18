function [ s ] = sigmoid( x )
%SIGMOID Summary of this function goes here
%   Detailed explanation goes here

s = 1 ./ (1 + exp(-x));

end

