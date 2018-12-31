% @param array img The input image to filter.
% @param integer dim_mask The mask's size. We prefer a odd size.
% @param array img_out The output image with the resultant curves detection.
% The algorithm is similar to Harris Detection.
function [img_out] = tomasiKanade(img, dim_mask)
    [n_row, n_col]=size(img);
    img_out=double(img);
    % Matrix n_row*n_col initialization.
    Dx=zeros(n_row,n_col);
    Dy=Dx;
    A=Dx;
    B=Dx;
    C=Dx;
    marker=255; %White color
    threshold=10^6.5;
    
    % Computes derivatives
    a = ceil(dim_mask/2);
    b = ceil(dim_mask/2);
    
% Old part
%     for i=a:n_row-a
%         Dx(i,:)=img_out(i+1,:)-img_out(i-1,:);
%     end
%     for j=b:n_col-b
%         Dy(:,j)=img_out(:,j+1)-img_out(:,j-1);
%     end
    
    for i=a:n_row-a
        for j=b:n_col-b
            Dx(i,j)=img_out(i,j+1)-img_out(i,j-1);
            Dy(i,j)=img_out(i+1,j)-img_out(i-1,j);
        end
    end
    
    % Compute A(x,y) and B(x,y) of Harris.
    A=computeMatrix(A, Dx, dim_mask);
    B=computeMatrix(B, Dy, dim_mask);   
    % Compute C(x,y) 
    C=A.*B;
    
    for i=1:n_row
        for j=1:n_col
            % Harris Matrix
            M=[A(i,j), C(i,j); C(i,j), B(i,j)];
            % Eighvalues            
            lambda=eig(M);
            % Min value of all POSITIVE eigenvalues
            lambda_min=min(lambda(lambda>0)); 
            if isempty(lambda_min)
                lambda_min = 0;
            end
            if lambda_min>=threshold
                img_out(i,j)=marker;
            end
        end
    end
end

% @param array M The input matrix.
% @param array M The input matrix.
% @param integer dim_mask The mask's size.
% @param array matrix The output matrix.
function [matrix] = computeMatrix(M, D, dim_mask)
    [n_row, n_col]=size(M);
    % Compute half-width and half-height of the mask.
    a = ceil(dim_mask/2);
    b = ceil(dim_mask/2);
    for i=a:n_row-a
        for j=b:n_col-b
            for ii=(i-a+1):(i+a-1)
                for jj=(j-b+1):(j+b-1)
                    % Sum the previous value with the square correspondent 
                    % derivatives.
                    M(i,j)=M(i,j)+D(ii,jj)^2;
                end
            end
        end
    end
    matrix=M;
end
