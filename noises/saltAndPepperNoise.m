% @param array img The input image to corrupt with the noise.
% @param integer probability It represents the generated noise density.
% @param array img_out The output image with the generated noise.
% A probability at 0 generate an img_out equals a the input img.
% A probability at 100 generate an img_out full corrupted, so an image with
% only noise.
function [img_out] = saltAndPepperNoise(img,probability)
    [n_row, n_col]=size(img);
    img_out = img;
    salt=0;
    pepper=255;
    for i=1:n_row
        for j=1:n_col
            s=randi(100);
            if s<=probability
                if randi(2)==1
                    img_out(i,j)=salt;
                else
                    img_out(i,j)=pepper;
                end
            end
        end
    end
end

