% @param array img The input image to filter.
% @param integer m The horizontal mask's size. We prefer a odd size.
% @param integer n The vertical mask's size. We prefer a odd size.
% @param array img_out The output image filtered.
function [img_out] = meanFilter(img,m,n)
    [n_row, n_col]=size(img);
    img_out = img;
    % If dimensions aren't odd, then force to odd.
    if mod(m,2) == 0 
        m=m+1;
    end
    if mod(n,2) == 0 
        n=n+1;
    end
    % Mask m*n
    a = ceil(m/2);
    b = ceil(n/2);
    for i=a:n_row-a
        for j=b:n_col-b
            % Submatrix extracted from img considering the mask.
            sub_img=img(i-a+1:i+a-1, j-b+1:j+b-1);
            % Mean of all values in sub_img.
            img_out(i,j) = sum(sum(sub_img))/(m*n);
        end
    end
end

