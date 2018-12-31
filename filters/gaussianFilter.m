% @param array img The input image to filter.
% @param integer dim_mask The mask's size. We prefer a odd size.
% @param array img_out The output image filtered.
function [img_out] = gaussianFilter(img, dim_mask)
    [n_row, n_col]=size(img);
    img_out=img;
    % The relation between the mask size and sigma is:
    % 2*a + 1 = 5*sigma
    % Where "a" is equal to:
    a=round(dim_mask/2)-1;
    sigma=round((2*a+1)/5);
    % Compute the floating point kernel.
    H=gaussianKernel(a,sigma);
    % Each value is less than 1, so we need to casting each floating point 
    % values to integer.
    % The minimum value h_min is brought to 1.
    h_min=min(H(:));
    H=round(H/h_min);
    % Normalization
    sum_weights=sum(H(:));
    H=H/sum_weights;
    % Compute half-width and half-height of the mask.
    a = ceil(dim_mask/2);
    b = ceil(dim_mask/2);
    for i=a:n_row-a
        for j=b:n_col-b
            % Submatrix extracted from img considering the mask.
            sub_img=img(i-a+1:i+a-1, j-b+1:j+b-1);
            sub_img=double(sub_img);
            % conv2(H,sub_img,'valid') returns a subsection of the 
            % convolution according to shape 'valid'. 
            % With 'valid' returns only parts of the convolution that are 
            % computed without zero-padded edges.
            img_out(i-a+1:i+a-1, j-b+1:j+b-1)=conv2(H,sub_img,'valid');
        end
    end
end

% @param integer dim_mask The mask's size. We prefer a odd size.
% @param integer sigma Sigma is the width of Gauss's Curve, the standard deviation.
% @param array H The output gaussian kernel.
function H = gaussianKernel(dim_mask,sigma)
    dim = dim_mask;
    % Generate the matrix mask.
    % [X,Y] = meshgrid(-dim:dim,-dim:dim) returns 2-D grid coordinates 
    % based on the coordinates contained in vectors [-dim:dim] and 
    % [-dim:dim]. X is a matrix where each row is a copy of [-dim:dim], and
    % Y is a matrix where each column is a copy of [-dim:dim].
    [x,y] = meshgrid(-dim:dim,-dim:dim);
    % Generate the gaussian noise in each matrix cell.
    arg = -(x.*x + y.*y)/(2*sigma^2);
    H = exp(arg);
    H=double(H);
end