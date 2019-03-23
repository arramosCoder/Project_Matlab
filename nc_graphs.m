clear all; close all;

frame = 1:453
% data = 'workspace10.mat';
% data = 'workspace50.mat';
% data = 'workspace100.mat';

%% Graph 1: Alpha = 10
data = 'workspace10.mat';
load(data);

figure(1)
plot(frame,NC_saltnpepper,frame,NC_gaussian,frame,NC_median);
ylim([0 0.06]); % 1000
xlim([0 452]);
%frame,NC_saltnpepper, frame,NC_gaussian,frame,NC_median);
legend('Salt & Pepper','Gaussian','Median Filter');
xlabel('Frame');
ylabel('Normalized Correlation');
title('Similarity of Extracted Watermark vs Orginal Frame: Alpha = 10');

% SP_avg = mean(NC_saltnpepper)
% G_avg = mean(NC_gaussian)
% M_avg_= mean(NC_median)
%% Graph 2: Alpha = 50
data = 'workspace50.mat';
load(data);

figure(2)
plot(frame,NC_saltnpepper,frame,NC_gaussian,frame,NC_median);
ylim([0.2 0.6]); % 1000
xlim([0 452]);
%frame,NC_saltnpepper, frame,NC_gaussian,frame,NC_median);
legend('Salt & Pepper','Gaussian','Median Filter');
xlabel('Frame');
ylabel('Normalized Correlation');
title('Similarity of Extracted Watermark vs Orginal Frame: Alpha = 50');

SP_avg = mean(NC_saltnpepper)
G_avg = mean(NC_gaussian)
M_avg_= mean(NC_median)
%% Graph 3: Alpha = 100
data = 'workspace100.mat';
load(data);

figure(3)
plot(frame,NC_saltnpepper,frame,NC_gaussian,frame,NC_median);
ylim([0.5 0.90]); % 1000
xlim([0 452]);
%frame,NC_saltnpepper, frame,NC_gaussian,frame,NC_median);
legend('Salt & Pepper','Gaussian','Median Filter');
xlabel('Frame');
ylabel('Normalized Correlation');
title('Similarity of Extracted Watermark vs Orginal Frame: Alpha = 100');

% SP_avg = mean(NC_saltnpepper)
% G_avg = mean(NC_gaussian)
% M_avg_= mean(NC_median)
%% Graph 4: Alpha = 1000
data = 'workspace1000.mat';
load(data);
figure(4)
plot(frame,NC_saltnpepper,frame,NC_gaussian,frame,NC_median);
ylim([0.83 0.92]); % 1000
xlim([0 452]);
%frame,NC_saltnpepper, frame,NC_gaussian,frame,NC_median);
legend('Salt & Pepper','Gaussian','Median Filter');
xlabel('Frame');
ylabel('Normalized Correlation');
title('Similarity of Extracted Watermark vs Orginal Frame: Alpha = 1000');

SP_avg = mean(NC_saltnpepper)
G_avg = mean(NC_gaussian)
M_avg_= mean(NC_median)

