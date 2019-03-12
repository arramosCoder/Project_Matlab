%apply attacks like salt/pepper, median filter, gaussian noise
close all;, clear all;

%set watermark intensity
alpha = 10;
% Read video
NAME = 'pizza_guy_Small';
IN_FILENAME = strcat(NAME, '.mp4');
Blue_FILENAME = strcat(NAME, '_blue');
SnP_FILENAME = strcat(NAME, '_s&p');
Gaussian_FILENAME = strcat(NAME, '_gauss');
Med_FILENAME = strcat(NAME, '_med');
MASK_NAME = ('saber.jpg');

video_Obj = VideoReader(IN_FILENAME);
% Get dimensions and FPS of video
fps = video_Obj.FrameRate;
dur = video_Obj.Duration;
vidWidth = video_Obj.Width;
vidHeight = video_Obj.Height;

totalFrames = ceil(fps*dur);
%get rows and columns for the mask
rows = vidHeight/16;
cols = vidWidth/16;

mask = imread(MASK_NAME);
mask = imbinarize(mask);
mask = imresize(mask(:,:,1), [rows,cols]);

% make an array to hold frames
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

% save data from file to mov array
frames = 1;
currFrame = zeros(vidHeight,vidWidth,3);
blueVideo = VideoWriter(Blue_FILENAME, 'MPEG-4');
finalVideo = VideoWriter(SnP_FILENAME,'MPEG-4');
finalVideo2 = VideoWriter(Gaussian_FILENAME, 'MPEG-4');
finalVideo3 = VideoWriter(Med_FILENAME, 'MPEG-4');
open(finalVideo);open(finalVideo2);open(finalVideo3);
open(blueVideo);

NC_blue = zeros(1,totalFrames);
NC_saltnpepper = zeros(1,totalFrames);
NC_gaussian = zeros(1,totalFrames);
NC_median = zeros(1,totalFrames);

while hasFrame(video_Obj)
    mov(frames).cdata = readFrame(video_Obj);
    currFrame = mov(frames).cdata;
    [embeddedFrame, DCT_blue]= embed(mov(frames).cdata, mask, alpha);
    %apply attacks to frames
    saltnpepper = imnoise(embeddedFrame(:,:,3),'salt & pepper');
    gaussian = imnoise(embeddedFrame(:,:,3),'gaussian');
    median= medfilt2(embeddedFrame(:,:,3), [4,4]);
   
    fprintf('Frame%d Saving to:\t%s\n', frames, SnP_FILENAME)

    writeVideo(blueVideo, embeddedFrame(:,:,3));
    writeVideo(finalVideo, saltnpepper);    
    writeVideo(finalVideo2, gaussian);    
    writeVideo(finalVideo3, median);
    
    blue_extract = extract(embeddedFrame(:,:,3), alpha, DCT_blue);
    saltnpepper_extract = extract(saltnpepper, alpha, DCT_blue);
    gaussian_extract = extract(gaussian, alpha, DCT_blue);
    median_extract = extract(median, alpha, DCT_blue);
    
    accumError = 0;
    accumAutoCorr = 0;
    for j = 1:rows
       for k = 1:cols
        accumError = accumError + mask(j,k)*blue_extract(j,k);
        accumAutoCorr = accumAutoCorr + blue_extract(j,k)*blue_extract(j,k);
       end 
    end
    NC_blue(frames) = accumError/accumAutoCorr;
    
    accumError = 0;
    accumAutoCorr = 0;
    for j = 1:rows
       for k = 1:cols
        accumError = accumError + mask(j,k)*saltnpepper_extract(j,k);
        accumAutoCorr = accumAutoCorr + saltnpepper_extract(j,k)*saltnpepper_extract(j,k);
       end 
    end
    NC_saltnpepper(frames) = accumError/accumAutoCorr;
    
        accumError = 0;
    accumAutoCorr = 0;
    for j = 1:rows
       for k = 1:cols
        accumError = accumError + mask(j,k)*gaussian_extract(j,k);
        accumAutoCorr = accumAutoCorr + gaussian_extract(j,k)*gaussian_extract(j,k);
       end 
    end
    NC_gaussian(frames) = accumError/accumAutoCorr;
    
        accumError = 0;
    accumAutoCorr = 0;
    for j = 1:rows
       for k = 1:cols
        accumError = accumError + mask(j,k)*median_extract(j,k);
        accumAutoCorr = accumAutoCorr + median_extract(j,k)*median_extract(j,k);
       end 
    end
    NC_median(frames) = accumError/accumAutoCorr;
    
    frames = frames+1;
end

close(finalVideo); close(finalVideo2); close(finalVideo3);
close(blueVideo);

hold on;
plot(NC_blue);plot(NC_saltnpepper);plot(NC_gaussian);plot(NC_median);
xlabel('Frame number');
ylabel('NC');
title('Similarity of extracted watermark vs frame number');
legend('Original', 'Salt & Pepper', 'Gaussian', 'Median Filter')
