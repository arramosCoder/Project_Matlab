clear all; close all;

% read image
FILENAME = 'football.jpg';
x = imread(FILENAME);
figure; imshow(x);

info_image = imfinfo(FILENAME)

% Apply DWT to RGB components of image
% [ average horiz vertical dia ] details of RGB components

% Choose mother wavelet type: daubeech's or haar
% dont give a shit, just pick one

% waveletType = 'db2';
waveletType = 'haar';

[xar,xhr,xvr,xdr] = dwt2(x(:,:,1),waveletType);
[xag,xhg,xvg,xdg] = dwt2(x(:,:,2),waveletType);
[xab,xhb,xvb,xdb] = dwt2(x(:,:,3),waveletType);

% Save the 3 RGB components back into 
% [ xa xh xv xd ] aka [ ave hor vert diag]
xa(:,:,1) = xar; xa(:,:,2) = xag ; xa(:,:,3) = xab;
xh(:,:,1) = xhr; xh(:,:,2) = xhg ; xh(:,:,3) = xhb;
xv(:,:,1) = xvr; xv(:,:,2) = xvg ; xv(:,:,3) = xvb;
xd(:,:,1) = xdr; xd(:,:,2) = xdg ; xd(:,:,3) = xdb;

figure, imshow(xa/255); % xa tpye double divide by 255 same thing as xa?
figure, imshow(xh);
figure, imshow(xv);
figure, imshow(xd);

X1 = [ xa*0.003 log10(xv)*0.3 ; log10(xh)*0.3 log10(xd)*0.3 ];
figure ; imshow(X1)
title('DWT applied to the 4 frequencies xa, xv, xh, xd');

% Apply the dwt again to get smaller blocks
[ xaar, xhhr, xvvr, xddr ] = dwt2(xa(:,:,1),waveletType);
[ xaag, xhhg, xvvg, xddg ] = dwt2(xa(:,:,2),waveletType);
[ xaab, xhhb, xvvb, xddb ] = dwt2(xa(:,:,3),waveletType);

xaa(:,:,1) = xaar; xaa(:,:,2) = xaag ; xaa(:,:,3) = xaab;
xhh(:,:,1) = xhhr; xhh(:,:,2) = xhhg ; xhh(:,:,3) = xhhb;
xvv(:,:,1) = xvvr; xvv(:,:,2) = xvvg ; xvv(:,:,3) = xvvb;
xdd(:,:,1) = xddr; xdd(:,:,2) = xddg ; xdd(:,:,3) = xddb;

figure, imshow(xaa/255); % xa tpye double divide by 255 same thing as xa?
figure, imshow(xhh);
figure, imshow(xvv);
figure, imshow(xdd);

X11 = [ xaa*0.001 log10(xvv)*0.3 ; log10(xhh)*0.3 log10(xdd)*0.3 ];
figure ; imshow(X11);
title('DWT applied again');

% lets try putting this shit back together ...
