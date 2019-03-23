% Applying dissecting_videoframe.m and struct_dwt together
% 1) Computer will choose a random frame from the video
% 2) Apply DWT to frame

clear all; close all;

%% 1) SAVE VIDEO INTO ARRAY STRUCTURE
IN_FILENAME = 'pizza_guy_Small.mp4';
OUT_FILENAME = strcat('DCT_','pizza');

% a) Read video
video_Obj = VideoReader(IN_FILENAME);

% Get dimensions and FPS of video
fps = video_Obj.FrameRate;
vidWidth = video_Obj.Width;
vidHeight = video_Obj.Height;

% Make an array to hold frames
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

% Save data from file to mov array
frames = 1;
while hasFrame(video_Obj)
    mov(frames).cdata = readFrame(video_Obj);
    frames = frames+1;
end
fprintf('Number of Frames: %d\n', frames);
fprintf('FPS: %d\n', fps);
hf = figure;
set(hf,'position',[150 150 vidWidth vidHeight]);
movie(hf,mov,1,fps);
title('Orginal Video');

% movie only accepts 8-bit image frames
% it does not accept:
% 16-bit grayscale
% 24–bit truecolor image frames.
% Default figure size is 560-by-420, must be changed

%% 2) CHOOSE A FRAME FROM VIDEO
% hardcoded to choose frame 300 cause that's where he eats pizza
selectedFrame = mov(300).cdata;

figure, imshow(selectedFrame);
title('Selected Video Frame: 300 of 452');

% making a structure for DWT transform

%% 3) Perform DWT
% a) Read image
x = selectedFrame;
figure; imshow(x);
title('INPUT: Original Image');

% b) Choose mother wavelet type: Daubeech's or Haar (just pick one)
% NEVERMIND IT DOES MATTER, CHOOSE HAAR OR INVERSE IS DOOMED
% waveletType = 'db2';
waveletType = 'haar';

% c) Save Orginal RGB components 
% red and green are required to rebuild orginal image
% blue will be used to compare with DWT blue 
red_x = x(:,:,1);     
green_x = x(:,:,2);
blue_Original = x(:,:,3);

inputImage = blue_Original;
% d) 
% STRUCTURE OF DWT
% CONTAINS:    INPUT: OG Image (1st Loop), LL image from prev DWT           
%
%              Images Generated:    LL (average)  HL (horizontal)
%                                   LH (vertical) HH (diagonal)
%
%               BLUE COMPONENTS OF: LL, HL, LH, HH                   
%
%              OUTPUT:  X1[ LL HL;
%                           LH HH ]
%

countDWT = 2;   % perform DWT 4 times (paper says so)
for n = 1:countDWT
    % FIRST LOOP OF DWT CANNOT BE IN FOR LOOP 
    % CANNOT JUST TAKE OUT RED GREEN WITH MATLAB
    % Perfrom DWT on blue component
    %[xab,xhb,xvb,xdb] = dwt2(x(:,:,3),waveletType);
    % [xar,xhr,xvr,xdr] = dwt2(x(:,:,1),waveletType);
    % [xag,xhg,xvg,xdg] = dwt2(x(:,:,2),waveletType);
    [xa,xh,xv,xd] = dwt2(inputImage,waveletType);

    % Final Output with Additional Calculations 
    X1 = [ xa/255, xh ; xv xd ];
    figure, imshow(X1)
    title([num2str(n),': OUTPUT Blue Component of 4 Subbands:LL HL LH HH']);

    % This Matrix is for display purposes of 4 subbands
    display_sub = [ xa*0.003 log10(xv)*0.3 ; log10(xh)*0.3 log10(xd)*0.3 ];
    figure ; imshow(display_sub)
    title('2-Level DWT with 4 Subbands');

    % Save info from DWT caclulation into structure
    DWT_struct(n) = struct('IN_LL',x...
        ,'LL_ave',xa,'HL_hor',xh,'LH_ver',xv,'HH_dia',xd)

    % Save new IN_LL image for next DWT loop
    inputImage = xa;
end

% Take the fourth level LL subband and save the image for DCT
fourthLevelLL = DWT_struct(countDWT).LL_ave;
figure, imshow(fourthLevelLL);
title('2-Level DWT LL Subband')

%% 4) APPLY DCT AND WATERMARK to Fourth Level Subband LL
% a) create the binary mask for watermark
%       0's : black
%       1's : white
[rows, cols, numberOfColorChannels] = size(fourthLevelLL);

MASK_NAME = 'saber.jpg';
mask = imread(MASK_NAME);
% mask = imbinarize(mask);
mask = im2bw(mask,0.7);
figure, imshow(mask);
title('Binary Mask')
mask = imresize(mask(:,:,1), [rows,cols]);

% binaryMask = zeros(rows,cols);
%binaryMask(5:15,5:17) = 1;
% for i = 1:rows
%     for j = 1:cols
%         if (mod(i/2, 2)== 1)% & (mod(j/2, 2)==1)
%             binaryMask(i,j)=1;
%         end
%     end
% end
figure,imshow(mask);
title('Binary Mask');
%save mask.dat binaryMask -ascii

% b) appy DCT to fourth level subband from DWT
DCT_blue = dct2(fourthLevelLL);
% load mask.dat
alpha = 500;     % watermark coeffienct stregth

% c) add the watermark to the DCT
DCT_blue_sum(1:rows,1:cols) = DCT_blue(1:rows,1:cols) + alpha * mask(1:rows,1:cols);
figure,imshow(DCT_blue_sum);
title('DCT Blue Sum');

%% 5) Inverse DCT
blue_INV = idct2(DCT_blue_sum);

%% 6) Inverse DWT
% Do the inverse DWT in for loop
INV_inputImage = blue_INV;
for n = countDWT:-1:1
    Level = idwt2(INV_inputImage, DWT_struct(n).HL_hor, DWT_struct(n).LH_ver...
        ,DWT_struct(n).HH_dia, waveletType);
    
    INV_inputImage = Level;
end

%% 7) Reconstruct Image 
final(:,:,1) = red_x;
final(:,:,2)= green_x;
final(:,:,3)= Level;

figure, imshow(final);
title('Frame Recontructed with Watermark')

%% 8) Extract the Watermark
% Perform DWT
inputImage = final(:,:,3);
for n = 1:countDWT
    % FIRST LOOP OF DWT CANNOT BE IN FOR LOOP 
    % CANNOT JUST TAKE OUT RED GREEN WITH MATLAB
    % Perfrom DWT on blue component
    %[xab,xhb,xvb,xdb] = dwt2(x(:,:,3),waveletType);
    % [xar,xhr,xvr,xdr] = dwt2(x(:,:,1),waveletType);
    % [xag,xhg,xvg,xdg] = dwt2(x(:,:,2),waveletType);
    [xa,xh,xv,xd] = dwt2(inputImage,waveletType);

    % Final Output with Additional Calculations 
    X1 = [ xa/255, xh ; xv xd ];
    figure, imshow(X1)
    title([num2str(n),': OUTPUT Blue Component of 4 Subbands:LL HL LH HH']);

    % This Matrix is for display purposes of 4 subbands
    display_sub = [ xa*0.003 log10(xv)*0.3 ; log10(xh)*0.3 log10(xd)*0.3 ];
    figure ; imshow(display_sub)
    title('2-Level DWT with 4 Subbands');

    % Save info from DWT caclulation into structure
    DWT_reconstruct(n) = struct('IN_LL',x...
        ,'LL_ave',xa,'HL_hor',xh,'LH_ver',xv,'HH_dia',xd)

    % Save new IN_LL image for next DWT loop
    inputImage = xa;
end

% Apply DCT
DCT_final = dct2(DWT_reconstruct(countDWT).LL_ave);
figure,imshow(DCT_final)
title('2-Level DWT and DCT of Reconstructed Image')

% Calculate the extracted mask
extracted_Mask = (DCT_final - DCT_blue)/alpha;
figure,imshow(extracted_Mask);
title('Extracted Mask')
% final_mask = round(extracted_Mask);
% figure,imshow(final_mask);
% title('FINAL ROUNDED Extracted Mask')

% 2) Visually represent what DCT will affect
Convert Image to greyscale
greyScaleImage = rgb2gray(selectedFrame);
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

