% Caricamento immagine marchiata
I = imread('gaussian_img.png');
I = I(:,:,1);
% Caricamento watermark originale
I_w = imread('watermark.png');
I_w = I_w(:,:,1);
% Caricamento immagine originale
cover_I = imread('lena.png');

alpha = 0.05;

% Preprocessing 
original_I = cover_I(:,:,1);
cover_I = cover_I(:,:,1);
size_I = size(cover_I);
disp(size_I);
if (size_I(1) == size_I)
    disp('quadrata');
    n = size_I(1);
elseif (size_I(2) > size_I(1))
    disp('larga');
    n = size_I(1);
else
    disp(' alta');
    n = size_I(2);
end
% Cerco una finestra divisibile per 4
while (mod(n,4)~=0)
    n = n - 1;
end
cover_I = cover_I(1:n,1:n,1);
I = I(1:n,1:n,1);
figure(2);imshow(cover_I);
% DWT
[LL1_wmk,HL1_wmk,LH1_wmk,HH1_wmk] = dwt2(I, 'haar');
[LL2_wmk,HL2_wmk,LH2_wmk,HH2_wmk] = dwt2(LL1_wmk, 'haar');

% SVD per i 4 watermark
[U1_wmk,S1_wmk,V1_wmk] = svd(LL2_wmk);
[U2_wmk,S2_wmk,V2_wmk] = svd(HL2_wmk);
[U3_wmk,S3_wmk,V3_wmk] = svd(LH2_wmk);
[U4_wmk,S4_wmk,V4_wmk] = svd(HH2_wmk);

% DWT e SVD dell'immagine originale
[LL,HL,LH,HH] = dwt2(cover_I,'haar');
[LL2,HL2,LH2,HH2] = dwt2(LL, 'haar');
[Ui_LL,Si_LL,Vi_LL]  = svd(LL2);
[Ui_HL,Si_HL,Vi_HL]  = svd(HL2);
[Ui_LH,Si_LH,Vi_LH]  = svd(LH2);
[Ui_HH,Si_HH,Vi_HH]  = svd(HH2);

% Extract
S1 = (S1_wmk - Si_LL)/0.05; 
S2 = (S2_wmk - Si_HL)/0.008; 
S3 = (S3_wmk - Si_LH)/0.008; 
S4 = (S4_wmk - Si_HH)/0.008; 

% Calcolo delle matrici A
I_w = imresize(I_w, size(Ui_LL));
[Uw, Sw, Vw] = svd(double(I_w));
W1 = Uw*S1*Vw';
W2 = Uw*S2*Vw';
W3 = Uw*S3*Vw';
W4 = Uw*S4*Vw';

figure(1); imshow(uint8(W1)); title('Watermarked 1');
figure(2); imshow(uint8(W2)); title('Watermarked 2');
figure(3); imshow(uint8(W3)); title('Watermarked 3');
figure(4); imshow(uint8(W4)); title('Watermarked 4');

imwrite(uint8(W1),'w1.png');
imwrite(uint8(W2),'w2.png');
imwrite(uint8(W3),'w3.png');
imwrite(uint8(W4),'w4.png');
