function img = model_vis(cv_result, mask)
    l = length(cv_result);
    p = length(cv_result{1}.model);
    m = zeros(p, 1);
    for i = 1 : l
        m = m + cv_result{i}.model;
    end
    m = m / l;
    m = m(2:end);
    img = reverse_mask(m, mask);
end