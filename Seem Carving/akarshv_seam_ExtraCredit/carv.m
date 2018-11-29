% File Name: carv.m
% Author:
% Date:

function [Ic, T] = carv(I, nr, nc)
% Input:
%   I is the image being resized
%   [nr, nc] is the numbers of rows and columns to remove.
%
% Output:
% Ic is the resized image
% T is the transport map

% Write Your Code Here

r = size(I,1);
c = size(I,2);

%create a cell array for storing the images
img = cell(nr+1,nc+1);

%Initialize the transport map
T=zeros(nr+1,nc+1);

img{1,1} = I;
T(1,1) = 0;

%create a matrix to remember what should the order be while playing the
%video
remember = zeros(nr+1,nc+1);
remember(:,1) = 1;
remember(1,:) = 2;

temp1 = I;

%remove all hor.seams
for i=2:nr+1
    e = genEngMap(temp1);
    [My, Tby] = cumMinEngHor(e);
    [Iy, E] = rmHorSeam(temp1, My, Tby);
    temp1 = Iy;
    img{i,1} = Iy;
    
    T(i,1) = T(i-1,1)+E;
    
end

%remove all vertical seams
Ix = I;
for j=2:nc+1
    e = genEngMap(Ix);
    [Mx, Tbx] = cumMinEngVer(e);
    [Ix, E] = rmVerSeam(Ix, Mx, Tbx);
    
    img{1,j} = Ix;
    T(1,j)=T(1,j-1)+E;
end


%remove hor. and vert. seams by decision making
for i=2:nr+1
    for j=2:nc+1
        e1 = genEngMap(img{i,j-1});
        [Mx, Tbx] = cumMinEngVer(e1);
        [Ix, E1] = rmVerSeam(img{i,j-1}, Mx, Tbx);
        
        e2 = genEngMap(img{i-1,j});
        [My, Tby] = cumMinEngHor(e2);
        [Iy, E2] = rmHorSeam(img{i-1,j}, My, Tby);
        
        [val,index] = min([T(i-1,j)+E2,T(i,j-1)+E1]);
        T(i,j) = val;
        remember(i,j) = index;
        if index==1
            img{i,j} = Iy;
            
        else
            img{i,j} = Ix;
        end
    end
end

    %video generation
    a=nr+1;
    b=nc+1;
    for k=(nr+nc):-1:1
        removed = remember(a,b);
        if removed==1
            temp = img{a-1,b};
            a = a-1;
            pad_temp(:,:,1)=padarray(temp(:,:,1),[r-size(temp,1),c-size(temp,2)],0,'post');
            pad_temp(:,:,2)=padarray(temp(:,:,2),[r-size(temp,1),c-size(temp,2)],0,'post');
            pad_temp(:,:,3)=padarray(temp(:,:,3),[r-size(temp,1),c-size(temp,2)],0,'post');
            video_frames{k,1}=pad_temp;
        else
            temp = img{a,b-1};
            b = b-1;
            pad_temp(:,:,1)=padarray(temp(:,:,1),[r-size(temp,1),c-size(temp,2)],0,'post');
            pad_temp(:,:,2)=padarray(temp(:,:,2),[r-size(temp,1),c-size(temp,2)],0,'post');
            pad_temp(:,:,3)=padarray(temp(:,:,3),[r-size(temp,1),c-size(temp,2)],0,'post');
            video_frames{k}=pad_temp;
        end
    end
    Ic = img{end,end};
%     resize_video(video_frames);
end
