% MATLAB EXAMPLES

%% Remove High Frequencies in Image using DCT
%% RGB image

RGB = imread('autumn.tif');
greyScale = rgb2gray(RGB);

DCT_greyScale = dct2(greyScale);

figure
imshow(log(abs(DCT_greyScale)),[])
colormap(gca,jet(64))
colorbar

%% Greyscale image
% 
% J(abs(J) < 10) = 0;
% K = idct2(J);
% figure
% imshowpair(I,K,'montage')
% title('Original Grayscale Image (Left) and Processed Image (Right)');