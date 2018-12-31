% @param array handles An gui's handler.
% @param array img The input image to compute.
% @param array img_out The output image.
function [img_computed] = computeImage(handles, img)
    if not(img)
        msgbox(sprintf('No image selected!'),'Error','Error');
        img_computed = false;
        return;
    end
    
    % We work on a copy of the original image.
    img_computed = img;
    
    % Negative
    if handles.gui_negative_btn.Value
       img_computed = negative(img_computed); 
    end

    % Noise
    img_computed = applyNoise(img_computed,handles);
    
    % Filter
    % It is possible apply the selected filter multiple times.
    repeat=handles.gui_repeat_filter.String;
    repeat=str2double(repeat);
    while (not(isnan(repeat)) && repeat>0) 
        img_computed = applyFilter(img_computed,handles);
        repeat=repeat-1;
    end
    
    % Detection
    img_computed = applyDetection(img_computed,handles);
    
    updateImageGUI(handles.gui_img_computed, img_computed);   
    computeHistogram(handles.gui_histogram_computed, img_computed);
end

function [img_out] = applyNoise(img_computed,handles)
    contents = get(handles.gui_popup_noise,'String');
    popupmenu4value = contents{get(handles.gui_popup_noise,'Value')};
    switch popupmenu4value
        case 'No noise'
            % No operation
            % img_computed = img_computed;
        case 'Impulse noise'
            % Density of 15%
            img_computed = saltAndPepperNoise(img_computed,15);
        case 'Gaussian noise'
            % Sigma 29
            img_computed = gaussianNoise(img_computed, 29);
        otherwise
    end
    img_out = img_computed;
end

function [img_out] = applyFilter(img_computed,handles)
    contents = get(handles.gui_popup_filter,'String');
    popupmenu4value = contents{get(handles.gui_popup_filter,'Value')};
    switch popupmenu4value
        case 'No filter'
            % No operation
            % img_computed = img_computed;
        case 'Mean filter'
            % Mask 3x3
            img_computed = meanFilter(img_computed, 3, 3);
        case 'Gaussian filter'
            % Mask 3x3
            img_computed = gaussianFilter(img_computed, 3);
        case 'Median filter'
            % Mask 3x3
            img_computed = medianFilter(img_computed, 3, 3);
        otherwise
    end
    img_out = img_computed;
end

function [img_out] = applyDetection(img_computed,handles)
    threshold = str2double(handles.gui_edge_threshold.String);
    contents = get(handles.gui_popup_detection,'String');
    popupmenu4value = contents{get(handles.gui_popup_detection,'Value')};
    switch popupmenu4value
        case 'No edge detection'
            % No operation
            % img_computed = img_computed;
        case "Robert's cross detection"
            img_computed = robertsCross(img_computed, threshold);
        case 'Sobel detection'
            img_computed = sobel(img_computed, threshold);
        otherwise
    end
    img_out = img_computed;
end
