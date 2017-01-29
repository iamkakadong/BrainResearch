function [model, fitinfo] = cae(d_train, d_valid, hidden_size, batch_size, learning_rate, lambda, max_iter)
    % Implementation of contractive autoencoder with squared error loss
    % Optimization method: Gradient descent with minibatch

    %% Initialization
    [n, p] = size(d_train);
    encoder = rand(p, hidden_size) - 0.5;
    b_encoder = 0;
    decoder = rand(hidden_size, p) - 0.5;
    b_decoder = 0;

    iter = 1;
    l_train = zeros(max_iter);
    l_valid = zeros(max_iter);
    fprintf('Iter\tl_train\t\tl_valid\t\tnorm_g_encoder\tnorm_g_decoder\n');

    while (iter <= max_iter)
        % Training
        d_train = d_train(randperm(n), :);    % randomly permute the training dataset 
        cur_loss = 0;
        i = 1;
        while i <= n
            % Build minibatch
            idx = i:min(i + batch_size, n);
            d = d_train(idx, :);

            % Call oracle
            [loss_mb, grad] = cae_oracle(d, encoder, decoder, b_encoder, b_decoder, lambda);

            % Update loss for current minibatch
            cur_loss = cur_loss + loss_mb;

            % Perform gradient descent
            b_encoder = b_encoder - learning_rate * grad.b_encoder;
            encoder = encoder - learning_rate * grad.encoder;
            b_decoder = b_decoder - learning_rate * grad.b_decoder;
            decoder = decoder - learning_rate * grad.decoder;

            i = idx(end) + 1;
        end

        l_train(iter) = cur_loss / n;

        % Validating
        [l_valid(iter), ~] = cae_oracle(d_valid, encoder, decoder, b_encoder, b_decoder, lambda);
        l_valid(iter) = l_valid(iter) / size(d_valid, 1);
            
        % Reporting iteration info
        fprintf('%d\t%0.5f\t%0.5f\t%0.5f\t\t%0.5f\n', iter, l_train(iter), l_valid(iter), norm(grad.encoder), norm(grad.decoder));
%         if (iter ~= 1 && l_train(iter - 1) - l_train(iter) < epsilon)
%             break;
%         end
        iter = iter + 1;
    end
    model.encoder = encoder;
    model.b_encoder = b_encoder;
    model.decoder = decoder;
    model.b_decoder = b_decoder;
    fitinfo.l_train = l_train(1: iter - 1);
    fitinfo.l_valid = l_valid(1: iter - 1);
    fitinfo.lambda = lambda;
end
