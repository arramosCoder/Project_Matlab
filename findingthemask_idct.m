clear all; close all;

% Orginal CODE FOR DCTWATERMARKING, SO IT CAN BE INVERSED LATER
filename = 'greens.jpg';
image = (imread(filename));   % read builtin image as double
figure(1)
imshow(image);  % /255 to make double to display image forowsat

% image size = row x col pixels 
[rows, cols, numberOfColorChannels] = size(image);

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

% Use Discrete Cosine Transforows on BLUE components of image%
% DCT_red = dct2(red);
% DCT_green = dct2(green);
DCT_blue = dct2(blue);
load mask.dat
alpha = 10; % watermark strength aka coeffeicent

% NOTE: if mask isnt same size as image
% use [rows,cols] = size(mask)

% Add alpha*mask to the DCT of RGB
SumDCT_blue(1:rows,1:cols) = DCT_blue(1:rows,1:cols) + alpha * mask;

% display individual DCT RGB components 
figure(5), imshow(SumDCT_blue);

% Mask make image look ugly, cant reconize the picture
% So lets inverse DCT components RGB to make it look normal
% .. but hides the actual watermark
blue_INV = idct2(SumDCT_blue);

imageWatermarked(:,:,1) = red;
imageWatermarked(:,:,2) = green;
imageWatermarked(:,:,3) = blue_INV;

figure(8), imshow(blue_INV);
figure(9),imshow(imageWatermarked);

% NOW FIND THE BINARY MASK IN THE watermarked image
% LETS RECONIZE THE WATERMARK
watermark_Detected = zeros(rows,cols);

blue_WM = imageWatermarked(:,:,3);
DCT_blue_WM = dct2(blue_WM);

result(1:rows,1:cols) = SumDCT_blue(1:rows,1:cols) - DCT_blue_WM(1:rows,1:cols)

for m = 1:rows
    for n = 1:cols
            if result(m,n) == alpha*mask
                watermark_Detected(m,n) = 1;
            end 
    end
end

figure,
imshow(watermark_Detected);
title('final')




