% @param array img The input image to filter.
% @param integer threshold The acceptance threshold of edges.
% @param array img_out The output image with the resultant detections.
function [img_out] = robertsCross(img, threshold)
    img_out=img;
    % Smoothing with a size's mask 3x3
    img_out=gaussianFilter(img_out, 3);
    % Mask padded with zero values
    mask_x=[1 0 0; 0 0 0; 0 0 -1];
    mask_y=[0 0 1; 0 0 0; -1 0 0];
    Ix=computeGradient(img_out, mask_x);
    Iy=computeGradient(img_out, mask_y);
    % Estimate the gradient magnitude and then make all pixels greater than
    % threshold as edges (255 value). If a pixel is smaller than threashold
    % than is set to 0.
    magnitude=sqrt(Ix.^2 + Iy.^2);
    img_out=(magnitude>=threshold) .* 255;
end
