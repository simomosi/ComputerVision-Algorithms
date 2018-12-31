% @param array img The input image to filter.
% @param integer m The horizontal mask's size. We prefer a odd size.
% @param integer n The vertical mask's size. We prefer a odd size.
% @param array img_out The output image filtered.
function [img_out] = medianFilter(img,m,n)
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
            % Submatrix extracted from img considering the mask m*n
            sub_img=img(i-a+1:i+a-1, j-b+1:j+b-1);
            % Orders the submatrix and extracts the median value (odd)
            sub_img_ord=sort(sub_img(:));
            index_median=round((m*n)/2);
            % index_median=round(length(sub_img_ord)/2);
            median=sub_img_ord(index_median);
            img_out(i,j)=median;
        end
    end
end

