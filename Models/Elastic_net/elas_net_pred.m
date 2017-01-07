function [pred] = elas_net_pred(X, b)
% function [pred] = elas_net_pred(X, model)
    intc = model.fitinfo.Intercept(model.fitinfo.IndexMinMSE);
	pred = lin_reg_pred(X, b) + intc;
	% pred = cvglmnetPredict(model, X);
end
