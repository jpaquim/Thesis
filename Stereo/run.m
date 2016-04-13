img_nr = 190;
set = 1;

width = 128;
height = 86;

I = imread(['Track' num2str(set) '/' num2str(img_nr) '.bmp']);
imgR = I(1:end,1:width,:);
imgL = I(1:end,width+1:end,:);

[image_coordinates, Disp_map] = run_SparseStereo_one_sided( imgL, imgR, width, height);


figure(1)
imshow([imgL imgR])
figure(2)
image(Disp_map,'CDataMapping','scaled')
caxis([0,60])