% @param array img The input image to inverte.
% @param array img_out The output image inverted.
function [img_out] = negative(img)
    % We use 255 because the range is [0, 255]
    img_out=255 - img ;
end

