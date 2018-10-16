A = imread('vertical.jpg'); %%% read the image
hsv = rgb2hsv(A); %%% convert from rgb to hsv
B = hsv(:,:,3); %%% separate V plane from hsv
F2 = fft2(B); %%% Fourier transform of image
[m,n,d] = size(F2); %%% dimensions of image
kernal1 = [1, 1, 1, 1, 1, 1]; %%% kernel chosen by trial
[x,y,z] = size(kernal1); %%% dimensions of kernel
win = fft2(kernal1,m,n); %%% Fourier transform of kernel
feat = F2./win; %%% full inverse filter
feath = ifft2(feat); %%% image in spatial domain
feather = mat2gray(feath); %%% scaling the values
hsv(:,:,3)= feather; %%% merging V plane back to hsv
color = hsv2rgb(hsv); %%% converting hsv to rgb
imshow(color); %%% display the colored image
