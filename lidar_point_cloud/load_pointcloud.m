%% load point cloud data and visualize
%========================================
clc
clear
close all

addpath('devkit')
base_dir  = './data/2011_09_26/2011_09_26_drive_0005_sync';
frame = 137; % 0-based index

% load velodyne points
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');	%read binary file
velo = fread(fid,[4 inf],'single')';	%将文件读取为single格式，维度为(n,4)
velo = velo(1:5:end,:); % remove every 5th point for display speed	
fclose(fid);

% remove all points behind image plane (approximation
idx = velo(:,1)<5;	%找到x坐标小于5的雷达点的索引
velo(idx,:) = [];	%将这些点去掉

% plot ponint cloud
ptCloud = pointCloud(velo(:,1:3)); % only plot the first 3 collom, the 4th collum is reflect rate
figure(3)
pcshow(ptCloud);