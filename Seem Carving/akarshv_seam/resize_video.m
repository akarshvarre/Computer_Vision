function resize_video(video_frames)

h = figure(2); clf;
whitebg(h,[0 0 0]);


%% EVAL

fname = 'Project2B_carv.avi';


try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 6;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',10);
end



for i=1:length(video_frames)
    imagesc(video_frames{i});
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