% @param array handles Handler of the graph.
% @param array img The image to plot.
function updateImageGUI(handles, img)
cla(handles);
axes(handles);
imshow(img);    
end

