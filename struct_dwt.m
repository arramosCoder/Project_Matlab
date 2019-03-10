% making a structure for DWT transform
clear all; close all;

% 1) INITIALIZE PARAMETERS FOR DWT
% a) Read image
FILENAME = 'football.jpg';
x = imread(FILENAME);
figure; imshow(x);
title('INPUT: Original Image');

% b) Choose mother wavelet type: Daubeech's or Haar (just pick one)
waveletType = 'db2';
% waveletType = 'haar';

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

countDWT = 4;


for n = 1:countDWT
    % FIRST LOOP OF DWT CANNOT BE IN FOR LOOP 
    % CANNOT JUST TAKE OUT RED GREEN WITH MATLAB
    % Perfrom DWT on blue component
    %[xab,xhb,xvb,xdb] = dwt2(x(:,:,3),waveletType);
    % [xar,xhr,xvr,xdr] = dwt2(x(:,:,1),waveletType);
    % [xag,xhg,xvg,xdg] = dwt2(x(:,:,2),waveletType);
    [xab,xhb,xvb,xdb] = dwt2(inputImage,waveletType);

    xa = xab;
    xh = xhb;
    xv = xvb;
    xd = xdb;

    % Final Output with Additional Calculations 
    X1 = [ xa/255, xh ; xv xd ];
    figure, imshow(X1)
    title('OUTPUT: RGB Image with 4 Subbands: LL HL LH HH');

    % This Matrix is for display purposes of 4 subbands
    display_sub = [ xa*0.003 log10(xv)*0.3 ; log10(xh)*0.3 log10(xd)*0.3 ];
    figure ; imshow(display_sub)
    title('Nice Display DWT and 4 Subands: LL HL LH HH');

    % Save info from DWT caclulation into structure
    waveletTran = struct('IN_LL',x...
        ,'LL_ave',xa,'HL_hor',xh,'LH_ver',xv,'HH_dia',xd...
        ,'LL_blue',xab,'HL_blue', xhb,'LH_blue',xvb,'HH_blue',xdb);

    % Save new IN_LL image for next DWT loop
    inputImage = xa;

end




