%% product pointcloud to image plane
%========================================
clc
clear
close all

addpath('devkit')
% load calibration directionary
base_dir  = './data/2011_09_26/2011_09_26_drive_0005_sync';
calib_dir = './data/2011_09_26';

cam = 2; % 0-based index
frame = 137; % 0-based index

% load calibration
calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt'));	

% compute projection matrix velodyne->image plane
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;

% load and display image
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
fig = figure('Position',[20 100 size(img,2) size(img,1)]);
axes('Position',[0 0 1 1]);
imshow(img);
hold on;

% load velodyne points
fid = fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');	%先以二进制方式打开
velo = fread(fid,[4 inf],'single')';	%将文件读取为single格式，维度为(n,4)
velo = velo(1:5:end,:); % remove every 5th point for display speed	%每五个点只取一个点，为了方便显示
fclose(fid);

% remove all points behind image plane (approximation
idx = velo(:,1)<5;	%找到x坐标小于5的雷达点的索引
velo(idx,:) = [];	%将这些点去掉

% project to image plane (exclude luminance)
velo_img = project(velo(:,1:3),P_velo_to_img);

% plot points
col_idx = round(64*5/velo(:,1));
plot(velo_img(:,1),velo_img(:,2),'o');