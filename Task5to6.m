% Task 5: Robust method --------------------------

mask = bwareafilt(pad, [100, inf]);
[labeledImage, numBlobs] = bwlabel(mask);
props = regionprops(labeledImage, 'Area', 'MajorAxisLength', 'MinorAxisLength');
aspectRatios = [props.MajorAxisLength] ./ [props.MinorAxisLength];
% Define an aspect ratio that will select bacteria:
aspectRatioThreshold = 3;
% Get cell mask:
cellMask = ismember(labeledImage, find(aspectRatios < aspectRatioThreshold));

cellColouredR  = ind2rgb(cellMask, CMap2);

bacteriaMask = ismember(labeledImage, find(aspectRatios >= aspectRatioThreshold));
bacColouredR  = ind2rgb(bacteriaMask, CMap);
% Display bacteria mask image.

% combine two images
robustFinal = imadd(bacColouredR,cellColouredR);
figure, imshow(robustFinal)
imwrite(robustFinal, [I,'.png'])



% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("Assignment_GT/IMG_01_GT.png");


similarity = dice(GT, robustFinal);

figure
imshowpair(GT, robustFinal)
title(['Dice Index = ' num2str(similarity)])

% To visualise the ground truth image, you can
% use the following code.
L_GT = label2rgb(GT, 'prism','k','shuffle');
figure, imshow(L_GT)