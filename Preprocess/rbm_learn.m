function [ model ] = rbm_learn( train, valid, param )
%RBM Summary of this function goes here
%   Detailed explanation goes here

h_num = param.h_num;
step = param.step;
max_iter = param.max_iter;
[n, p] = size(train.X);
[vn, ~] = size(valid.X);

W = (rand(p, h_num) - 0.5) * sqrt(6) / sqrt(p + h_num);    % Initialize weight matrix p * h
b = zeros(p, 1);    % p * 1
a = zeros(h_num, 1);    % h * 1

err_t = zeros(max_iter);
err_v = zeros(max_iter);

for iter = 1 : max_iter
%     w_grad = zeros(size(W));
%     a_grad = zeros(size(a));
%     b_grad = zeros(size(b));
    for i = 1 : n
        v0 = train.X(i, :)'; % p * 1
        v = v0;
        for k = 1 : param.k
            h = sample_h(v, W, a);  % h * 1
            v = sample_v(h, W, b);  % p * 1
        end
        p0 = ph_v(W, v0, a);
        pk = ph_v(W, v, a);
%         w_grad = w_grad + (p0 * v0' - pk * v')';
%         a_grad = a_grad + (p0 - pk);
%         b_grad = b_grad + (v0 - v);
%         err = err + ce(v0, W, h, b);
        W = W + step * (p0 * v0' - pk * v')';
        a = a + step * (p0 - pk);
        b = b + step * (v0 - v);
%         err = err + ce(v0, W, h, b);
    end
%     W = W + step * w_grad;
%     a = a + step * a_grad;
%     b = b + step * b_grad;
    err = 0;
    for i = 1 : n
        vt = train.X(i, :)';
        h = sample_h(vt, W, a);
        err = err + ce(vt, W, h, b);
    end
    err_t(iter) = err / n;

    err = 0;
    for i = 1 : vn
        vv = valid.X(i, :)';
        h = sample_h(vv, W, a);
        err = err + ce(vv, W, h, b);
    end
    err_v(iter) = err / vn;
    fprintf('current iteration %d, train error %0.5f, valid error %0.5f \n', iter, err_t(iter), err_v(iter));
end

model = struct;
model.W = W;
model.b = b;
model.c = a;
model.err_t = err_t;
model.err_v = err_v;

end

function s = sample_h(v, W, a)
    p = ph_v(W, v, a);
    s = rand(length(p), 1);
    s = (s < p) * 1;
end

function s = sample_v(h, W, b)
    p = ph_v(W', h, b);
    s = rand(length(p), 1);
    s = (s < p) * 1;
end

function p = ph_v(W, v, a)  % h * 1
    m = W' * v + a;
    p = sigmoid(m);
end

function l = ce(v, W, h, b)
    p = ph_v(W', h, b);
    l = v' * log(p) + (1 - v)' * log(1 - p);
    l = -l;
end