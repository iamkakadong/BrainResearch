function [res] = reverse_mask(vec, mask)
	tmp = mask(:);
	tmp2 = zeros(1, length(tmp));
	tmp2(tmp~=0) = vec;
	res = reshape(tmp2, size(mask));
end