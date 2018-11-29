%%TestScript

%Load in the image to be carved
I = imread('scenary.jpg');

%no.of rows and columns to removed
nr = 40;
nc = 10;


[Ic, T] = carv(I, nr, nc);

subplot(1,2,1);
imshow(I);
h = gca;
h.Visible = 'On';

subplot(1,2,2);
imshow(Ic);
g = gca;
g.Visible = 'On';
