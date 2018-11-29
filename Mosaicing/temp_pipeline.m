max_pts = 500;

imgL = imread('1L.jpg');
img = rgb2gray(imgL);
[cimg] = corner_detector(img);
[y, x, rmax] = anms(cimg, max_pts);
y1 = y;
x1 = x;
rmax1 = rmax;
[descs] = feat_desc(img, x, y);
descs1 = descs;

imgM = imread('1M.jpg');
img = rgb2gray(imgM);
[cimg] = corner_detector(img);
[y, x, rmax] = anms(cimg, max_pts);
y21 = y;
x21 = x;
rmax2 = rmax;
[descs] = feat_desc(img, x, y);
descs2 = descs;

imgR = imread('1R.jpg');
img = rgb2gray(imgR);
[cimg] = corner_detector(img);
[y, x, rmax] = anms(cimg, max_pts);
y3 = y;
x3 = x;
rmax3 = rmax;
[descs] = feat_desc(img, x, y);
descs3 = descs;

[match] = feat_match(descs1, descs2);
match1 = match;
x1 = x1(match(match>0));
y1 = y1(match(match>0));
x21 = x21(match(match>0));
y21 = y21(match(match>0));

[match] = feat_match(descs3, descs2);
match2 = match;
x1 = x1(match(match>0));
y1 = y1(match(match>0));
x22 = x22(match(match>0));
y22 = y22(match(match>0));

thresh = 7;

[H, inlier_ind] = ransac_est_homography(x1, y1, x21, y21, thresh);
H1 = H;
inlier_ind1 = inlier_ind;

[H, inlier_ind] = ransac_est_homography(x22, y22, x3, y3, thresh);
H2 = H;
inlier_ind2 = inlier_ind;








