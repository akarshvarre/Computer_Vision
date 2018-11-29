function mask = maskImage(Img)
%% Enter Your Code Here

figure;
imshow(Img);    

h = imfreehand();
mask = createMask(h);
end

