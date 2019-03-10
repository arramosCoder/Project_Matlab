clear all; close all;

Carissa = 10;
filename = 'greens.jpg';
image_orginal = imread(filename);
image = double(imread(filename));   % read builtin image as double
figure, imshow(image/255);  % /255 to make double to display image forowsat
title('Orginal Image');

% image size = row x col pixels 
[rowa, cols, numberOfColorChannels] = size(image_orginal);
%rows = 300; cols = 500;

% 2) Visually represent what DCT will affect
% Convert Image to greyscale
greyScaleImage = rgb2gray(image_orginal);
figure, imshow(greyScaleImage);
title('Greyscale Image');

% Apply DCT to greyscaled image
DCT_image = dct2(greyScaleImage);

figure
imshow(log(abs(DCT_image)),[])
title('Absolute Value of Image Frequencies')
colormap(gca,jet(64))
colorbar
ylabel('Lowest to Highest Frequency')
xlabel('Discrete cosine transform will remeove highest frequencies (red)')
