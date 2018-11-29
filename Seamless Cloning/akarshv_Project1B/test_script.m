
%Read the source adn the target images
sourceImg = imread('SourceImage.png');
targetImg = imread('TargetImage.png');

%split the source image into three channels
sourceImgR = sourceImg(:,:,1);
sourceImgG = sourceImg(:,:,2);
sourceImgB = sourceImg(:,:,3);

%declare the offset here
offsetY = 50;
offsetX = 300;

%Generate the mask
mask = maskImage(sourceImg);

%Find the result Image and show
resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY);

imshow(resultImg);