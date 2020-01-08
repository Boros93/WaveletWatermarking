% Caricamento cover image
I = imread('lena.png');
figure(1); imshow(I); title('Cover image');

% Caricamento watermark image
I_w = imread('watermark.png');
I_w = I_w(:,:,1);
figure(2); imshow(I_w); title('Watermark image');

alpha = 0.05;

% Preprocessing cover image
original_I = I(:,:,1);
I = I(:,:,1);
size_I = size(I);
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
I = I(1:n,1:n,1);
disp(size(I));

% DWT alla cover image
[LL,HL,LH,HH] = dwt2(I,'haar');
[LL2,HL2,LH2,HH2] = dwt2(LL, 'haar');

% SVD per ogni sottobanda
[Ui_LL,Si_LL,Vi_LL]  = svd(LL2);
[Ui_HL,Si_HL,Vi_HL]  = svd(HL2);
[Ui_LH,Si_LH,Vi_LH]  = svd(LH2);
[Ui_HH,Si_HH,Vi_HH]  = svd(HH2);

% Preprocessing watermark
I_w = imresize(I_w, size(Ui_LL));
disp(size(I_w));
% SVD watermark
[Uw, Sw, Vw] = svd(double(I_w));
% Embedding
SLL_emb = Si_LL + 0.05*Sw;
SHL_emb = Si_HL + 0.008*Sw;
SLH_emb = Si_LH + 0.008*Sw;
SHH_emb = Si_HH + 0.008*Sw;

% Calcolo della matrice A
LL_new = Ui_LL*SLL_emb*Vi_LL';
HL_new = Ui_HL*SHL_emb*Vi_HL';
LH_new = Ui_LH*SLH_emb*Vi_LH';
HH_new = Ui_HH*SHH_emb*Vi_HH';

% IDWT sulla nuova A
F_pass = idwt2(LL_new,HL_new,LH_new,HH_new,'haar');
I_out = idwt2(F_pass,HL,LH,HH,'haar');
I_out = uint8(I_out);
original_I(1:n,1:n,1) = I_out(:,:,1);
figure(3); imshow(original_I); title('Watermarked image');
imwrite(original_I,'watermarked.png');

% Estrazione
%[LL1_wmv,HL1_wmv,LH1_wmv,HH1_wmv] = dwt2(I_out, 'haar');
%[LL2_wmv,HL2_wmv,LH2_wmv,HH2_wmv] = dwt2(LL1_wmv, 'haar');

%[Uy_wmv,Sy_wmv,Vy_wmv] = svd(LL2_wmv);
%Swrec = (Sy_wmv - Si_LL)/alpha;
%WMy = Uw*Swrec*Vw';
%figure(4); imshow(uint8(WMy)); title('Watermarked extracted');







