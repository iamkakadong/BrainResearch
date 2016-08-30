clear all

addpath(genpath('../../Toolbox'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...\n')
[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
X = [event_types; X]';
y = y';
fprintf('finished loading data\n')

% validate that y has different mean and variance
ym = zeros(length(subject_range), 1);
ys = zeros(length(subject_range), 1);
ym(1) = mean(y(1 : subject_range(1)));
ys(1 = std(y(1 : subject_range(1)));
for i = 2 : length(subject_range)
	ym(i) = mean(y(subject_range(i - 1) + 1 : subject_range(i)));
	ys(i) = std(y(subject_range(i - 1) + 1 : subject_range(i)));
end

% validate that features have similar distribution across subjects
xm = zeros(length(X), length(subject_range));
xs = zeros(length(X), length(subject_range));
xm(:, 1) = mean(X(1 : subject_range(1), :), 2)';
xs(:, 1) = std(X(1 : subject_range(1), :), 2)';
for i = 2 : length(subject_range)
	xm(:, i) = mean(X(subject_range(i - 1) + 1 : subject_range(i), :), 2)';
	xs(:, 1) = std(X(subject_range(i - 1) + 1 : subject_range(i), :), 2)';
end