clear all;
clc;
close all;
warning('off', 'images:initSize:adjustingMag')

% Open Channel Logo
a=imread('Logo/Football.png');
img=imresize(a,[256,256]);
w = imtranslate(img,[1000, 1000],'OutputView','full');
w=imresize(w,[256,256]);
figure(1)
imshow(w)
title('Channel Logo')

% Open Embedding Watermark
wm=imread('Embedding Logo/A.png');   
wm=imresize(wm,[100 100]);
wm=rgb2gray(wm);
wm=im2bw(wm,0.5);
figure(2);
subplot(1,2,1)
imshow(wm)
title('Embedding hidden watermark')

% Open Channel Content
vid=VideoReader('Videos/FCB.mp4'); 
nframes=vid.NumberOfFrames;
Ht=vid.Height;
Wd=vid.Width;

% writerObj = VideoWriter('output');
% open(writerObj);
% set(gca,'nextplot','replacechildren');
% set(gcf,'Renderer','zbuffer');

VD=read(vid);
VO=VD;
% figure(2)
% title('Original Channel Content')
% for i=1:nframes
%     imshow(VO(:,:,:,i))
% end

% Channel frame and Embedded Watermark frame
oF=VD(:,:,:,45);
figure(3)
subplot(1,2,1)
imshow(oF)
title('OriginalFrame')

im=rgb2hsv(oF);
h=im(:,:,1);
s=im(:,:,2);
v=im(:,:,3);

[A H V D]=dwt2(v,'haar');

alpha=input('Enter Embedding Strength Parameter alpha ');

block=D(1:100,1:100);
m=mean(block(:));
block=block-m;
c=block*block';
[ph lamb]=eig(c);
y=ph'*block;
y=y+alpha*double(wm);
w=ph*y;
D(1:100,1:100)=w;

imnew=idwt2(A,H,V,D,'haar');

nwp=zeros(Ht,Wd,3);
nwp(:,:,1)=h;
nwp(:,:,2)=s;
nwp(:,:,3)=imnew;

nw=hsv2rgb(nwp);
figure(3);
subplot(1,2,2)
imshow(nw)
title('Watermarked Frame')

% Final visible and hidden watermark frame
VD(:,:,:,45)=im2uint8(nw);

% figure(4);
% title('Watermarked Video');
% j=1;
% for i=1:nframes
%     imshow(VD(:,:,:,i));
%     Frame(j)=getframe;
%     writeVideo(writerObj,Frame(j));
%     j=j+1;
% end
% close(writerObj);

% Extraction

J =(nw);

im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');
        
block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
I=round(y1);
y1=medfilt2(logical(I),[3,3]);
figure(2);
subplot(1,2,2);
imshow(y1);
title('Extracted hidden watermark')



%%%%%%%%%% attacks and extraction


% 1 gaussian noise

J=imnoise(nw,'gaussian',0.001,0.001);


im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');


block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
y1=round(y1);

y1=medfilt2(logical(y1),[3,3]);

figure;
subplot(1,2,1)
imshow(y1)
title('extracted watermark')
subplot(1,2,2)
imshow(J)
title('Gaussian Noise Attack')


% NC_guassian = nc(wm,y1)

%gaussian noise psnr:

PSNR1=psnr(J,nw)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 2 salt & pepper noise 

J = imnoise(nw,'salt & pepper',0.01);

im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');


block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
y1=round(y1);
y1=medfilt2(logical(y1),[3,3]);

figure;
subplot(1,2,1)
imshow(y1)
title('extracted watermark')
subplot(1,2,2)
imshow(J)
title('Salt and pepper Noise Attack')

% NC_salt_pepper=nc(wm,y1)

PSNR2=psnr(J,nw)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3 cropping attack 

J = (nw);
J(1:20,:,:)=0;
J(Ht-19:Ht,:,:)=0;
J(:,1:20,:)=0;
J(:,Wd-19:Wd,:)=0;

im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');


block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
y1=round(y1);
y1=medfilt2(logical(y1),[3,3]);

figure;
subplot(1,2,1)
imshow(y1)
title('extracted watermark')
subplot(1,2,2)
imshow(J)
title('Cropping Attack')

% NC_cropping=nc(wm,y1)

%cropping psnr:

PSNR3=psnr(J,nw)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%4 histogram eq:     
for c=1:3
k=nw(:,:,c);
J(:,:,c)= histeq(k);
end

im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');


block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
y1=round(y1);

y1=medfilt2(logical(y1),[3,3]);

figure;
subplot(1,2,1)
imshow(y1)
title('extracted watermark')
subplot(1,2,2)
imshow(J)
title('histogram equalisation')


% NC_hist=nc(wm,y1)

%hist eq psnr:

PSNR4=psnr(J,nw)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      

%5 sharpning filter:
J=imsharpen(nw);


im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');


block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
y1=round(y1);

y1=medfilt2(logical(y1),[3,3]);

figure;
subplot(1,2,1)
imshow(y1)
title('extracted watermark')
subplot(1,2,2)
imshow(J)
title('sharpning filter')


% NC_sharp=nc(wm,y1)

%hist eq psnr:

PSNR5=psnr(J,nw)  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%6 intensity adjustment:
J= imadjust(nw,[.2 .3 0; .6 .7 1],[]);


im1=rgb2hsv(J);

h=im1(:,:,1);
s=im1(:,:,2);
v=im1(:,:,3);

[A H V D]=dwt2(v,'haar');


block1=D(1:100,1:100);
m=mean(block1(:));
block1=block1-m;
c=block1*block1';
[ph lamb]=eig(c);
y1=ph'*block1;
y1=abs(y-y1)/alpha;
y1=round(y1);

y1=medfilt2(logical(y1),[3,3]);

figure;
subplot(1,2,1)
imshow(y1)
title('extracted watermark')
subplot(1,2,2)
imshow(J)
title('intensity adjustment')


% NC_intadj=nc(wm,y1)

%hist eq psnr:

PSNR6=psnr(J,nw)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%