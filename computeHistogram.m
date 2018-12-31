% @param array handles_axes Handler of the graph.
% @param array img The image to analyze.
function computeHistogram(handles_axes, img)
    cla(handles_axes);
    h=imhist(img);
    axes(handles_axes);
    plot((1:256),h)
end