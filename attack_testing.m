%apply attacks like salt/pepper, median filter, gaussian noise
close all;, clear all;

%load original watermark image from directory
load mask.dat;

% Read video
NAME = 'DCT_xylo';
IN_FILENAME = strcat(NAME, '.mp4');
Blue_FILENAME = strcat(NAME, '_blue');
SnP_FILENAME = strcat(NAME, '_s&p');
Gaussian_FILENAME = strcat(NAME, '_gauss');
Med_FILENAME = strcat(NAME, '_med');

video_Obj = VideoReader(IN_FILENAME);
% Get dimensions and FPS of video
fps = video_Obj.FrameRate;
vidWidth = video_Obj.Width;
vidHeight = video_Obj.Height;

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

while hasFrame(video_Obj)
    mov(frames).cdata = readFrame(video_Obj);
    
    %apply attacks to frames
    saltnpepper = imnoise(mov(frames).cdata(:,:,3),'salt & pepper');
    gaussian = imnoise(mov(frames).cdata(:,:,3),'gaussian');
    median = medfilt2(mov(frames).cdata(:,:,3), [4,4]);
   
    fprintf('Saving to:\t%s\n', SnP_FILENAME)

    writeVideo(blueVideo, mov(frames).cdata(:,:,3));
    writeVideo(finalVideo, saltnpepper);    
    writeVideo(finalVideo2, gaussian);    
    writeVideo(finalVideo3, median);
    
    blue_extract = extract(mov(frames).cdata(:,:,3));
    saltnpepper_extract = extract(saltnpepper);
    gaussian_extract = extract(gaussian);
    median_extract = extract(median);
    
    accumError = 0;
    accumAutoCorr = 0;
    for j = 1:vidWidth
       for k = 1:vidHeight
        accumError = accumError + mask(j,k)*blue_extract(j,k);
        accumAutoCorr = accumAutoCorr + blue_extract(j,k)*blue_extract(j,k);
       end 
    end
    NC(frames) = accumError/accumAutoCorr;
    
    frames = frames+1;
end

close(finalVideo); close(finalVideo2); close(finalVideo3);
close(blueVideo);
