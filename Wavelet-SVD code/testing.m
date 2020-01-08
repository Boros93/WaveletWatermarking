I1 = imread("lena.png");
I2 = imread("watermarked.png");
I1 = I1(:,:,1);
I2 = I2(:,:,1);
disp(psnr(I1,I2));
ssimval = ssim(I1,I2);
disp(ssimval);