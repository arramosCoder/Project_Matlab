clear all; close all;

% EMBEDDING WATERMARK

filename = 'peppers.png';
mother_wavelet = 'haar';
image = double(imread(filename));
figure(1)
imshow(image/255);

%rows = 21; cols = 34;
rows = 26; cols = 34;

% 1) Create Binary Mask for Waterowsark
% make a rectangle within the zero matrix
% 0's : black
% 1's : white
binaryMask = zeros(rows,cols);
%binaryMask(5:15,5:17) = 1;
for i = 1:rows
    for j = 1:cols
        if (mod(i/2, 2)== 1)% & (mod(j/2, 2)==1)
            binaryMask(i,j)=1;
        end
    end
end
figure(2),imshow(binaryMask)
save mask.dat binaryMask -ascii

% 2) Let's Waterowsark Christmas
% use RGB components of image
red = image(:,:,1);     
green = image(:,:,2);
blue = image(:,:,3); % We're only going to work with blue

% Get the fourth-level DWT for blue sub-band
[xab1, xhb1, xvb1, xdb1] = dwt2(blue, mother_wavelet);
[xab2, xhb2, xvb2, xdb2] = dwt2(xab1, mother_wavelet);
[xab3, xhb3, xvb3, xdb3] = dwt2(xab2, mother_wavelet);
[xab4, xhb4, xvb4, xdb4] = dwt2(xab3, mother_wavelet);

% Use Discrete Cosine Transforows on B component
% of fourth-level DWT
DCT_blue = dct2(xab4);
load mask.dat
alpha = 10;

figure,imshow(xab4);

% Add alpha*mask to the DCT of B
[rows,cols] = size(xab4);
DCT_blue_sum(1:rows,1:cols) = DCT_blue(1:rows,1:cols) + alpha * mask(1:rows,1:cols);

figure(20),title('DCT_blue_sum'),imshow(DCT_blue_sum)

% Inverse DCT
blue_INV = idct2(DCT_blue_sum);

%row1=40, col1=65;
%row2=77, col2=127;
%row3=151, col3=251;

row1=50, col1=66;
row2=98, col2=130;
row3=193, col3=257;


% Inverse DWT using the blue_INV
Level3 = idwt2(blue_INV, xhb4, xvb4, xdb4, mother_wavelet);
%Level2 = idwt2(Level3(1:row1,1:col1), xhb3, xvb3, xdb3, mother_wavelet);
%Level1 = idwt2(Level2(1:row2,1:col2), xhb2, xvb2, xdb2, mother_wavelet);
%Blue_Final = idwt2(Level1(1:row3,1:col3), xhb1, xvb1, xdb1, mother_wavelet);
Level2 = idwt2(Level3, xhb3, xvb3, xdb3, mother_wavelet);
Level1 = idwt2(Level2, xhb2, xvb2, xdb2, mother_wavelet);
Blue_Final = idwt2(Level1, xhb1, xvb1, xdb1, mother_wavelet);

% Put everything together
final(:,:,1)=red;
final(:,:,2)=green;
final(:,:,3)=Blue_Final;
figure,imshow(final/255)
figure, imshow(100 - abs(final-image)*100)

% EXTRACTION

% Get the fourth-level DWT for blue sub-band
[exab1, exhb1, exvb1, exdb1] = dwt2(final(:,:,3), mother_wavelet);
[exab2, exhb2, exvb2, exdb2] = dwt2(exab1, mother_wavelet);
[exab3, exhb3, exvb3, exdb3] = dwt2(exab2, mother_wavelet);
[exab4, exhb4, exvb4, exdb4] = dwt2(exab3, mother_wavelet);

DCT_final = dct2(exab4);
figure(21),title('DCT_final'),imshow(DCT_final)
%extracted_Mask(1:rows,1:cols) = (DCT_final(1:rows,1:cols) - DCT_blue(1:rows,1:cols))/alpha;
extracted_Mask = (DCT_final - DCT_blue)/alpha;
figure(101),imshow(extracted_Mask);
final_mask = round(extracted_Mask);


