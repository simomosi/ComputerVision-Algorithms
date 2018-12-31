% @param array img The input image to corrupt with the noise.
% @param integer sigma Sigma is the width of Gauss's Curve, the standard deviation.
% @param array img_out The output image with the generated noise.
% A sigma greater implies a width greater of the curve and so greater
% noise.
function [img_out] = gaussianNoise(img,sigma)
    if ~sigma
       sigma=20; 
    end
    img_out = img;
    [n_row, n_col]=size(img);
    for i=1:n_row
        for j=1:n_col
            % A classical way to generate random gaussian noise is:
            % sigma * random(from 0 to 1)
            % where with sigma we change the standard deviation.
            img_out(i,j)=img(i,j)+floor(sigma*randn(1));
        end
    end
end

