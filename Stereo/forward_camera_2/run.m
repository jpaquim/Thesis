set = 1;
img_nr = 20;

width = 128;
height = 86;

I = imread(['Track' num2str(set) '/' num2str(img_nr) '.bmp']);
imgR = I(1:end,1:width,:);
imgL = I(1:end,width+1:end,:);

[image_coordinates, Disp_map] = run_SparseStereo_one_sided( imgL, imgR, width, height);

figure;
% imshow([imgL imgR])
imagesc(imgL);
figure;
imagesc(Disp_map)
caxis([0,60])
