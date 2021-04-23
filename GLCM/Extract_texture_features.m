% Read the input image
clear;
close all
D = 'F:/Capstone/Improvements/result_crop/';
s1 ='.jpg';
var_glcm={}
ent_glcm={}
ctr_glcm={}
Hu1_11={}
Hu1_13={}
Hu1_15={}
Hu1_17={}
Hu2_11={}
Hu2_13={}
Hu2_15={}
Hu2_17={}
    img = imread('F:/Capstone/Improvements/ISIC_0000017.jpg');
    img=rgb2gray(img);
    imshow(img);

G = 8; % We just want to use G gray levels

% Make the histogram (approx.) uniform with G grey levels.
% See the curriculum for INF2310 if you do not know histogram equalization
img_std = histeq(img,G);
img_std = uint8(round(double(img_std) * (G-1) / double(max(img_std(:)))));

% Define GLCM-parameters.
windowSize = 15;
dx = 1;
dy = 1;

% Call the function to calculate the feature images with gliding GLCM
   [glcmVar,glcmCtr,glcmEnt,glcmHom,glcmEne,glcmCor] = glidingGLCM(img_std,G,dx,dy,windowSize);
   save('Glcmdata_test_512_norm.mat','var_glcm','ctr_glcm','ent_glcm','windowSize','G');
