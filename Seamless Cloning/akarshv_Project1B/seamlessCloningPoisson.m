function resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY)
%% Enter Your Code Here

%Get the height and width of target image
targetH = size(targetImg,1);
targetW = size(targetImg,2);

%get the indexes matrix where the binary mask is named with
%1,2,3,4,5.....replaced in the pixels where the value is 1
indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY);

%Get the Coeffcient A matrix
coeffA = getCoefficientMatrix(indexes);

%Split the source image into three channels
sourceR = sourceImg(:,:,1);
sourceG = sourceImg(:,:,2);
sourceB = sourceImg(:,:,3);

%Split the target image into three channels
targetR = targetImg(:,:,1);
targetG = targetImg(:,:,2);
targetB = targetImg(:,:,3);


%calculate the b vector for each channel. This b vector comprises of the
%laplacian of the source image plus the boundary pixels of the target
%image(if any)
solVectorbR = getSolutionVect(indexes, sourceR, targetR, offsetX, offsetY);
solVectorbG = getSolutionVect(indexes, sourceG, targetG, offsetX, offsetY);
solVectorbB = getSolutionVect(indexes, sourceB, targetB, offsetX, offsetY);


%compute the solution pixels which needs to be replaced in the target image
%to get the result image
red = mldivide(coeffA,solVectorbR');
green = mldivide(coeffA,solVectorbG');
blue = mldivide(coeffA,solVectorbB');

%pass the above solutions to the reconstructImg to get the resultImg
resultImg = reconstructImg(indexes, red', green', blue', targetImg);



end