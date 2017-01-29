function [loss, grad] = cae_oracle(d, encoder, decoder, b_encoder, b_decoder, lambda)
    f = sigmoid(bsxfun(@plus, d * encoder, b_encoder));
    g = bsxfun(@plus, f * decoder, b_decoder);
    [n, p] = size(d);
    [~, hs] = size(f);

    % Compute loss
    loss = 0;
    grad = struct;
    loss = loss + sum(sum((g - d).^2)); % squared-error loss
    tmp = zeros(hs, 1);
    for j = 1:hs
        tmp(j) = norm(encoder(:, j))^2;
    end
    loss = loss + lambda * sum((f .* (1 - f)).^2 * tmp);

    % Compute gradients
    grad.b_decoder = 2 * ones(1, n) * (g - d) / n;
    grad.decoder = 2 * f' * (g - d) / n;
    grad.f = 2 * (g - d) * decoder' + lambda * 2 * bsxfun(@times, 1 - 2 * f, tmp');
    grad.b_encoder = ones(1, n) * (grad.f .* f .* (1 - f)) / n;
    grad.encoder = d' * (grad.f .* f .* (1 - f)) / n;
end
