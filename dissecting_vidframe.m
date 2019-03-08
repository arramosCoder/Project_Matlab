clear all; close all;

IN_FILENAME = 'xylophone.mp4';
OUT_FILENAME = strcat('DCT_','xylo');

%% Read video frame
% v = VideoReader(IN_FILENAME);
% 
% while hasFrame(v)
%     video = readFrame(v);
% end
% whos video

%% Read and play back movie
% Read video
video_Obj = VideoReader(IN_FILENAME);

% Get dimensions and FPS of video
fps = video_Obj.FrameRate;
vidWidth = video_Obj.Width;
vidHeight = video_Obj.Height;

% make an array to hold frames
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

% save data from file to mov array
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


% Save video to output file
finalVideo = VideoWriter(OUT_FILENAME,'MPEG-4');
open(finalVideo)

fprintf('Saving to:\t%s\n', OUT_FILENAME)
for k = 1:(frames - 1)
    image = mov(k).cdata;
    writeVideo(finalVideo, image);
end

close(finalVideo)


