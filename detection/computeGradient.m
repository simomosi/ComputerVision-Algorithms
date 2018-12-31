% @param array img The input image to filter.
% @param array mask The mask's matrix.
% @param array gradient The output matrix with all gradients.
function [gradient] = computeGradient(img, mask)
    [n_row_img, n_col_img]=size(img);
    [n_row_mask, n_col_mask]=size(mask);
    img_out=img;
    % Compute half-width and half-height of the mask.
    a = ceil(n_row_mask/2);
    b = ceil(n_col_mask/2);
    for i=a:n_row_img-a
        for j=b:n_col_img-b
            % Submatrix extracted from img considering the mask
            sub_img=img(i-a+1:i+a-1, j-b+1:j+b-1);
            sub_img=double(sub_img);
            % Compute pixel i,j using the mask.
            img_out(i,j)=sum(sum(sub_img.*mask));
        end
    end
    gradient=double(img_out);
end