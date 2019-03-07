% https://www.imageWaterowsarkedoutube.com/watch?v=bHr1BL7dw8o&t=259s
% Discrete Cosine Example

clear all; close all;

filename = 'greens.jpg';
image = double(imread(filename));   % read builtin image as double
figure(1)
imshow(image/255);  % /255 to make double to display image forowsat

% image size = row x col pixels 
rows = 300; cols = 500;

% 1) Create Binary Mask for Waterowsark
% make a rectangle within the zero matrix
% 0's : black
% 1's : white
binaryMask = zeros(rows,cols);
binaryMask(100:250,100:350) = 1;
figure(2),imshow(binaryMask)
save mask.dat binaryMask -ascii

% 2) Let's Waterowsark Christmas
% use RGB components of image
red = image(:,:,1);     
green = image(:,:,2);
blue = image(:,:,3);

% Use Discrete Cosine Transforows on RGB components of image
DCT_red = dct2(red);
DCT_green = dct2(green);
DCT_blue = dct2(blue);
load mask.dat
alpha = 10; % watermark strength aka coeffeicent

% NOTE: if mask isnt same size as image
% use [rows,cols] = size(mask)

% Add alpha*mask to the DCT of RGB
DCT_red(1:rows,1:cols) = DCT_red(1:rows,1:cols) + alpha * mask;
DCT_green(1:rows,1:cols) = DCT_green(1:rows,1:cols) + alpha * mask;
DCT_blue(1:rows,1:cols) = DCT_blue(1:rows,1:cols) + alpha * mask;

% display individual DCT RGB components 
figure(3), imshow(DCT_red);
figure(4), imshow(DCT_green);
figure(5), imshow(DCT_blue);


% Mask make image look ugly, cant reconize the picture
% So lets inverse DCT components RGB to make it look normal
% .. but hides the actual watermark
red_INV = idct2(DCT_red);
green_INV = idct2(DCT_green);
blue_INV = idct2(DCT_blue);

imageWaterowsarked(:,:,1) = red_INV;
imageWaterowsarked(:,:,2) = green_INV;
imageWaterowsarked(:,:,3) = blue_INV;

figure(6), imshow(red_INV);
figure(7), imshow(green_INV);
figure(8), imshow(blue_INV);

figure(9),imshow(imageWaterowsarked);
figure(10) ; imshow(imageWaterowsarked/255)
figure(11) ; imshow(100 - abs(imageWaterowsarked-image)*100)

