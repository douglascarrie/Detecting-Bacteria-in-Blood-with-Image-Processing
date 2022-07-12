clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.png');
figure, imshow(I)
title('Original');

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
figure, imshow(I_gray)
title('Grayscale');

% Step-3: Rescale image
reScale = imresize(I_gray,[512 NaN]);
figure, imshow(reScale)
title('Rescale');

% Step-4: Produce histogram before enhancing - RESIZED HISTO
h = histogram(reScale,64);
title('Histogram before enhancing');



% Step-5: Enhance image before binarisation

% Contrast Adjustment
enhanced = imadjust(reScale);

% Step-6: Histogram after enhancement
hE = histogram(enhanced,64);
title('Histogram after enhancing');

% Step-7: Image Binarisation
Binarize = imbinarize(enhanced);

figure, imshow(Binarize)





% Task 2: Edge detection ------------------------
filterC = edge(Binarize,'canny'); 
filterP = edge(Binarize,'Prewitt'); 
filterS = edge(Binarize,'Sobel');

% Display three next to eachother
tiledlayout(1,3)
nexttile
imshow(filterC)
title('Canny')
nexttile
imshow(filterP)
title('Prewitt')
nexttile
imshow(filterS)
title('Sobel')


% Task 3: Filling the blood cells

crop = filterC(2:end-1, 2:end-1);

% padding top & right White
pad=padarray(crop,[1 1],1,'pre');
pad = imfill(pad,'holes');
pad = pad(2:end,2:end);

% padding bottom & left White
pad=padarray(pad,[1 1],1,'post');
pad = imfill(pad,'holes');
% remove padding again
pad = pad(2:end-1,1:end-1);
% show image
figure, imshow(pad)



% Task 4: Object Recognition --------------------

% removes noise
nR = bwareaopen(pad, 100);

% find smallest 3 area white objects (bacteria)
bac = bwareafilt(nR, 3, 'smallest');
% turn them blue
CMap = [0, 0, 0;  0, 0.8, 1];
bacColoured  = ind2rgb(bac, CMap);

% find biggest 7 area white object (blood)
blood = bwareafilt(nR, 7);
% change colour of 7 largest to red
CMap2 = [0, 0, 0;  1, 0, 0];
bloodColoured  = ind2rgb(blood, CMap2);
% show image
final = imadd(bacColoured,bloodColoured);
figure, imshow(final)
