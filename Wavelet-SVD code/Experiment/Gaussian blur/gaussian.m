I = imread("watermarked.png");
I_out = imgaussfilt(I,1.5);
imwrite(I_out,"gaussian_img.png");