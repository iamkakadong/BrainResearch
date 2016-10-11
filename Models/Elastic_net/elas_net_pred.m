function [pred] = elas_net_pred(X, b)
% function [pred] = elas_net_pred(X, model)
	pred = lin_reg_pred(X, b);
	% pred = cvglmnetPredict(model, X);
end