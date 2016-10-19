clear all

addpath(genpath('../../BrainResearch'));
load_outside_functions;

fprintf('load data\n');
load data;
X = X';

params = struct;
params.h_num = 500;
params.step = 1e-2;
params.max_iter = 100;
params.k = 2;

[cutoff, ~] = size(X);
cutoff = floor(cutoff * 0.9);
train_data = X(1 : cutoff, :);
valid_data = X(cutoff + 1 : end, :);

td.X = train_data >= 0;
vd.X = valid_data >= 0;

fprintf('training rbf\n');
model = rbm_learn(td, vd, params);
save('../Results/rbm_model.mat', 'model');
