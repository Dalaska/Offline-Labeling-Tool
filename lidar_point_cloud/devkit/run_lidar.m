%function run_demoVelodyne (base_dir,calib_dir)

% clear and close everything
close all; dbstop error; clc;
disp('======= KITTI DevKit Demo =======');

% ���ݺ�����������Ĳ�ͬ���趨
%if nargin<1
  base_dir  = './data/2011_09_26/2011_09_26_drive_0005_sync';
%end
%if nargin<2
  calib_dir = './data/2011_09_26';
%end
cam       = 2; % 0-based index
frame     = 137; % 0-based index

%���ر궨�ļ���fullfile��·�����ļ�����
%calib����������Ľṹ����
calib = loadCalibrationCamToCam(fullfile(calib_dir,'calib_cam_to_cam.txt'));
%Tr_velo_to_cam��һ����������
Tr_velo_to_cam = loadCalibrationRigid(fullfile(calib_dir,'calib_velo_to_cam.txt')); 

%������״��3d���ݵ������ͼƬ��ͶӰ����
R_cam_to_rect = eye(4);
R_cam_to_rect(1:3,1:3) = calib.R_rect{1};
P_velo_to_img = calib.P_rect{cam+1}*R_cam_to_rect*Tr_velo_to_cam;

% load and display image
img = imread(sprintf('%s/image_%02d/data/%010d.png',base_dir,cam,frame));
fig = figure('Position',[20 100 size(img,2) size(img,1)]);
axes('Position',[0 0 1 1]);
imshow(img); hold on;

% load velodyne points
fid=fopen(sprintf('%s/velodyne_points/data/%010d.bin',base_dir,frame),'rb');%���Զ����Ʒ�ʽ��
%velo = fread(fid,[inf 4],'single');%���ļ���ȡΪsingle��ʽ��ά��Ϊ(n,4)
velo = fread(fid,[10000 4],'single');%���ļ���ȡΪsingle��ʽ��ά��Ϊ(n,4)
%velo = fread(fid,inf,'single');
b = velo(:,1:3)

velo = velo(1:5:end,:);%ÿ�����ֻȡһ���㣬Ϊ�˷�����ʾ
fclose(fid);


% remove all points behind image plane (approximation
idx = velo(:,1)<5;  %�ҵ�x����С��5���״�������
velo(idx,:) = [];   %����Щ��ȥ��

% project to image plane (exclude luminance)
%velo_img = project(velo(:,1:3),P_velo_to_img);
velo_img = project(velo(:,1),P_velo_to_img);

% plot points����ɫ

cols = jet;
for i=1:size(velo_img,1)
  col_idx = round(64*5/velo(i,1));
  plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
end

% point cloud

ptCloud = pointCloud(b)
pcshow(ptCloud)
% plot points���Ҷ�ͼ

% cols = 1-[0:1/63:1]'*ones(1,3);
% for i=1:size(velo_img,1)
%   col_idx = round(64*5/velo(i,1));
%   plot(velo_img(i,1),velo_img(i,2),'o','LineWidth',4,'MarkerSize',1,'Color',cols(col_idx,:));
% end