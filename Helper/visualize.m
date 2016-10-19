function [X, Y, Z] = visualize(img, cover, msize, filled)
	[d1,d2,d3] = size(img);
	[x,y,z] = meshgrid(1:d2, 1:d1, 1:d3);
	m = double(img~=0);
	X = x.*m;
	Y = y.*m;
	Z = z.*m;
    Xn = X(:);
    Yn = Y(:);
    Zn = Z(:);
    imgn = img(:);
    if cover
        hold on;
    else
        figure;
    end
	colormap(jet);
    if filled
        scatter3(Xn(Xn~=0),Yn(Yn~=0),Z(Zn~=0),msize,imgn(imgn~=0), 'filled');
    else
        scatter3(Xn(Xn~=0),Yn(Yn~=0),Z(Zn~=0),msize,imgn(imgn~=0));
    end
	colorbar;
end