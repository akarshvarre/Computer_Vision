function [morphed_im] = morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%MORPH_TRI Image morphing via Triangulation
%	Input im1: source image
%	Input im2: target image
%	Input im1_pts: correspondences coordinates in the source image
%	Input im2_pts: correspondences coordinates in the target image
%	Input warp_frac: a vector contains warping parameters
%	Input dissolve_frac: a vector contains cross dissolve parameters
%
%	Output morphed_im: a set of morphed images obtained from different warp and dissolve parameters

% Helpful functions: delaunay, tsearchn

%read in Images and convert them into double
im1 = double(im1);
im2 = double(im2);


%Round the points for fine calculations. This may not be necessary.
% im1_pts = round(im1_pts);
% im2_pts = round(im2_pts);

%Check if the images are of same size and resize them if they are not
if(size(im1,1)~=size(im2,1))||(size(im1,2)~=size(im2,2))
    if(numel(im1)>numel(im2))
        im1 = imresize(im1, [size(im2,1),size(im2,2)], 'bicubic');
    else 
        im2 = imresize(im2, [size(im1,1),size(im1,2)], 'bicubic');
    end
end

%Mesh grid used in interpolation and tsearchn
[X,Y] = meshgrid(1:size(im1,2),1:size(im1,1));


nc = size(im1,2);
nr = size(im1,1);

%Used to pass in the tsearchn function and also all the points calculation
%including barrycentric coordinates
points_loop  = [repmat(1:nc, 1, nr); reshape(repmat(1:nr, nc, 1), [1 nr*nc]); ones(1, nr*nc)];
col(1,1,:) = points_loop(1,:)';
row(1,1,:) = points_loop(2,:)';
h(1,1,:) = ones(size(points_loop,2),1);


%Linear indices used in saving the pixel values and passing in interp2
%function
indices = sub2ind([nr,nc],Y,X);

%Initialization
source_x = zeros();
source_y = zeros();
target_x = zeros();
target_y = zeros(); 

%One loop through length of warp_frac
for i=1:length(warp_frac)
    
    %Caluculate the average shape by averageing the points using warp_frac
    interm_points = (1-warp_frac(i))*im1_pts + warp_frac(i)*im2_pts;
    
    %Applying delaunay triangulation on intermediate points
    traingles = delaunay(interm_points(:,1),interm_points(:,2));
    
    %A,B,C of all the triangles generated from intermediate points
    ax(1,1,:) = interm_points(traingles(:,1),1);
    ay(1,1,:) = interm_points(traingles(:,1),2);
    
    bx(1,1,:) = interm_points(traingles(:,2),1);
    by(1,1,:) = interm_points(traingles(:,2),2);
    
    cx(1,1,:) = interm_points(traingles(:,3),1);
    cy(1,1,:) = interm_points(traingles(:,3),2);
    
    %To pass ones in [x,y,1]
    one_mat(1,1,:) = ones(size(traingles,1),1);
    
    
    %A,B,C of source - im1
    axs(1,1,:) = im1_pts(traingles(:,1),1);
    ays(1,1,:) = im1_pts(traingles(:,1),2);
    
    bxs(1,1,:) = im1_pts(traingles(:,2),1);
    bys(1,1,:) = im1_pts(traingles(:,2),2);
    
    cxs(1,1,:) = im1_pts(traingles(:,3),1);
    cys(1,1,:) = im1_pts(traingles(:,3),2);
    
    
    %A,B,C of target - im2
    axt(1,1,:) = im2_pts(traingles(:,1),1);
    ayt(1,1,:) = im2_pts(traingles(:,1),2);
    
    bxt(1,1,:) = im2_pts(traingles(:,2),1);
    byt(1,1,:) = im2_pts(traingles(:,2),2);
    
    cxt(1,1,:) = im2_pts(traingles(:,3),1);
    cyt(1,1,:) = im2_pts(traingles(:,3),2);
    
    %Get the indexes of each point in the meshgrid. This index gives the location of triangle which the point belongs to  
    index=tsearchn(interm_points, traingles, [points_loop(2,:)', points_loop(1,:)']);
    
    
    %To compute barry centric coordinates--> mat_invert*[barry] = [x y 1]
    mat_invert = [ax,bx,cx;ay,by,cy;one_mat,one_mat,one_mat];
    
    %To compute the pixel locations in source and target
    %mat_source*[barry] = [x y 1],mat_target*[barry] = [x y 1]
    mat_source = [axs,bxs,cxs;ays,bys,cys;one_mat,one_mat,one_mat];
    mat_target = [axt,bxt,cxt;ayt,byt,cyt;one_mat,one_mat,one_mat];
    
    %invert each page of mat_invert using helper function
    mat_invert = helper(mat_invert(:,:,index));
    
    %Caluclate barrycentric coordinates
    barry=(sum(mat_invert.*[row,col,h;row,col,h;row,col,h],2));
    
    %Calucate [x y] of source and target and reassign them into image
    %cooridnates
    source_coord=squeeze(sum(mat_source(:,:,index) .*[permute(barry,[2,1,3]);permute(barry,[2,1,3]);permute(barry,[2,1,3])], 2));
    target_coord=squeeze(sum(mat_target(:,:,index) .*[permute(barry,[2,1,3]);permute(barry,[2,1,3]);permute(barry,[2,1,3])], 2));
    
    source_x(indices) = source_coord(1,:)./source_coord(3,:);
    source_y(indices) = source_coord(2,:)./source_coord(3,:);
    
    target_x(indices) = target_coord(1,:)./target_coord(3,:);
    target_y(indices) = target_coord(2,:)./target_coord(3,:);
    
    source_x = (reshape(source_x,[nr,nc]))';
    target_x = (reshape(target_x,[nr,nc]))';
    
    source_y = (reshape(source_y,[nr,nc]))';
    target_y = (reshape(target_y,[nr,nc]))';
    
    %Interpolate these [x y] of source and target and calculate the pixel
    %values and generate two new images
    Vq_source(:,:,1) = interp2(X,Y,im1(:,:,1),source_x',source_y');
    Vq_target(:,:,1) = interp2(X,Y,im2(:,:,1), target_x',target_y');
    
    Vq_source(:,:,2) = interp2(X,Y,im1(:,:,2),source_x',source_y');
    Vq_target(:,:,2) = interp2(X,Y,im2(:,:,2), target_x',target_y');
    
    Vq_source(:,:,3) = interp2(X,Y,im1(:,:,3),source_x',source_y');
    Vq_target(:,:,3) = interp2(X,Y,im2(:,:,3), target_x',target_y');  
    
    %Dissolve the two new images obtained above
    morphed_im{i} = uint8((1-dissolve_frac(i))*Vq_source + dissolve_frac(i)*Vq_target);
    
    %Just for visualization, might help in visula debugginf if anything
    %goes wrong
    imshow(morphed_im{i});
    
end

