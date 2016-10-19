clear all

addpath(genpath('../../BrainResearch'));
% load_outside_functions;

load data;
X = X';

params = struct;
params.h_num = 500;
params.step = 1e-2;
params.max_iter = 500;
params.k = 10;

[cutoff, ~] = size(X);
cutoff = floor(cutoff * 0.9);
train_data = X(1 : cutoff, :);
valid_data = X(cutoff + 1 : end, :);

td.X = train_data;
vd.X = valid_data;

model = rbm_learn(td, vd, params);