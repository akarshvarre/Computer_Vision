% function show =  video(filename)

nr = 2;
nc = 80;
param = 1;

Vptr = VideoReader('funny.mp4');
%Create a temporary working folder to store the image sequence
workingDir = tempname;
mkdir(workingDir);
mkdir(workingDir,'images');

ii = 1;
while hasFrame(Vptr)
    %Read from video file
    img = readFrame(Vptr);
    %Apply canny edge detection to each image
    [Ic, ~] = carv(img, nr, nc);
    filename = [sprintf('%03d',ii) '.jpg'];
    fullname = fullfile(workingDir,'images',filename);
    imwrite(Ic,fullname);
    ii = ii+1;

end

imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

%VideoWriter object
outputVideo = VideoWriter(fullfile(workingDir,'output.avi'));
outputVideo.FrameRate = Vptr.FrameRate;
open(outputVideo);

%loop through all the images
for ii = 1:length(imageNames)
    img = imread(fullfile(workingDir,'images',imageNames{ii}));
    writeVideo(outputVideo,img)
end
close(outputVideo);
outputAvi = VideoReader(fullfile(workingDir,'output.avi'));
ii = 1;
while hasFrame(outputAvi)
    mov(ii) = im2frame(readFrame(outputAvi));
    ii = ii+1;
end
figure;
imshow(mov(1).cdata, 'Border', 'tight');
movie(mov,1,outputAvi.FrameRate);
% show = eye(2);
% end
