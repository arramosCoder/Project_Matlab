function [imageWaterMarked, DCT_blue] = embed(image,mask,alpha)
%embed mask into image after 4 level haar dwt and dct
red = image(:,:,1);     
green = image(:,:,2);
blue = image(:,:,3); % We're only going to work with blue
mother_wavelet = 'haar';
% Get the fourth-level DWT for blue sub-band
[xab1, xhb1, xvb1, xdb1] = dwt2(blue, mother_wavelet);
[xab2, xhb2, xvb2, xdb2] = dwt2(xab1, mother_wavelet);
[xab3, xhb3, xvb3, xdb3] = dwt2(xab2, mother_wavelet);
[xab4, xhb4, xvb4, xdb4] = dwt2(xab3, mother_wavelet);

% Use Discrete Cosine Transforows on B component
% of fourth-level DWT
DCT_blue = dct2(xab4);

% Add alpha*mask to the DCT of B
[rows, cols] = size(DCT_blue);
DCT_blue_sum(1:rows,1:cols) = DCT_blue(1:rows,1:cols) + alpha * mask(1:rows,1:cols);

% Inverse DCT
blue_INV = idct2(DCT_blue_sum);

[rows2, cols2] = size(xhb3);
[rows1, cols1] = size(xhb2);
[rows0, cols0] = size(xhb1);

% Inverse DWT using the blue_INV
Level3 = idwt2(blue_INV(1:rows,1:cols), xhb4, xvb4, xdb4, mother_wavelet);
Level2 = idwt2(Level3(1:rows2,1:cols2), xhb3, xvb3, xdb3, mother_wavelet);
Level1 = idwt2(Level2(1:rows1,1:cols1), xhb2, xvb2, xdb2, mother_wavelet);
Blue_Final = idwt2(Level1(1:rows0, 1:cols0), xhb1, xvb1, xdb1, mother_wavelet);

% Put everything together
final(:,:,1)=red;
final(:,:,2)=green;
final(:,:,3)=Blue_Final;

imageWaterMarked = final;
end

