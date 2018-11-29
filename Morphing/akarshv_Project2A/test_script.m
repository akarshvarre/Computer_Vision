%% Image Morphing
im1 = imread('akarsh.jpg');
im1 = imresize(im1,[600,600]);
im2 = imread('kit.jpg');
im2 = imresize(im2,[600,600]);
% [im1_pts, im2_pts] = click_correspondences(im1, im2);
load('im1_pts.mat');
load('im2_pts.mat');

h = figure(2); clf;
whitebg(h,[0 0 0]);


%% EVAL

fname = 'Project2_eval_trig.avi';


try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 10;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',10);
end

w = 0:0.02:1;
morphed_ims = morph_tri(im1, im2, im1_pts, im2_pts, w,w);

for i=1:length(w)
    imagesc(morphed_ims{i});
    axis image; axis off;drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end
try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end
clear h_avi;



