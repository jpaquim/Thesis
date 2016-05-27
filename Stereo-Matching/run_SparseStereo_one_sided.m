function [image_coordinates, Disp_map] = run_SparseStereo_one_sided( imgL, imgR, width, height)
max_disparity = 10;

%% Parameters
DIFF_THRESHOLD = 10;
FEATURE_FACTOR = 1.3;
MATCHING_THRESHOLD = ones(1,max_disparity+1);

% MATCHING_THRESHOLD(4:end) = 150;
% MATCHING_THRESHOLD(5:end) = 350;
% % MATCHING_THRESHOLD(6:end) = 200;
% MATCHING_THRESHOLD(7:end) = 350;
% MATCHING_THRESHOLD(8:end) = 350;
% MATCHING_THRESHOLD(11:end) = 350;
% % MATCHING_THRESHOLD(14:end) = 250;
% MATCHING_THRESHOLD(15:end) = 400;
% % MATCHING_THRESHOLD(17:end) = 350;

%% Settings
feature_window_horizontal = 3; % half window size (one-sided) 2->5
feature_window_vertical = 3;

%% variable declaration
disparity_range = max_disparity+1;
cost = zeros(1,disparity_range);
image_coordinates = zeros(2000,3);
Disp_map = zeros(size(imgL(:,:,1)));
disp_cnt = 0;
disp_cnt_1 = 0;
disp_cnt_2 = 0;

%% simple Sobel filter [-1 0 1]
% DIFF_L = imabsdiff(imgL(:,1:end-2,1),imgL(:,3:end,1));
% DIFF_R = imabsdiff(imgR(:,1:end-2,1),imgR(:,3:end,1));

%% simple edge filter [-1 1]
DIFF_L = imabsdiff(imgL(:,1:end-1,1),imgL(:,2:end,1));
DIFF_R = imabsdiff(imgR(:,1:end-1,1),imgR(:,2:end,1));

for line = 1+feature_window_vertical:height-feature_window_vertical
    for i = 1+feature_window_horizontal+max_disparity: width-feature_window_horizontal-2
%         line
%         i
        if (DIFF_L(line,i) > DIFF_L(line,i-1)) && (DIFF_L(line,i) > DIFF_L(line,i+1) && DIFF_L(line,i) > DIFF_THRESHOLD ) % check if current idx is local maximum and value exceeds min_threshold

            ii = i;

            % perform SAD calculations
            for D = 0:max_disparity
                cost(D+1) = sum(sum(imabsdiff(imgL(line-feature_window_vertical:line+feature_window_vertical,ii-feature_window_horizontal:ii+feature_window_horizontal,1),imgR(line-feature_window_vertical:line+feature_window_vertical,ii-feature_window_horizontal-D:ii+feature_window_horizontal-D,1))));
            end

%             % perform SAD calculations
%             for D = 0:max_disparity
%                 cost(D+1) = sum(sum(imabsdiff(imgL(line,ii-feature_window_horizontal:ii+feature_window_horizontal,1),imgR(line:line,ii-feature_window_horizontal-D:ii+feature_window_horizontal-D,1))));
%                 cost(D+1) = cost(D+1) + sum(sum(imabsdiff(imgL(line-feature_window_vertical:line+feature_window_vertical,ii-D,1),imgR(line-feature_window_vertical:line+feature_window_vertical,ii-D,1))));
%
%             end

            [first, i_first] = min(cost); % find minimum cost c1
            neighbors = i_first-1:i_first+1;
%             neighbors = [i_first i_first i_first];
            if neighbors(1) == 0
                neighbors = 1:2;
            elseif neighbors(3) == disparity_range+1
                neighbors = neighbors(end-2:end-1);
            end

            cost_neighbors = cost(neighbors);
            cost(neighbors) = 1000000;
            second = min(cost);   % find second minimum cost c2
            cost(neighbors) = cost_neighbors;

            if (second / first > FEATURE_FACTOR && second > MATCHING_THRESHOLD(i_first) ) % check if match peak ratio ( PKR-N ) exceeds minimum threshold
                disparity = i_first;
                if ( i_first > 1 && i_first < max_disparity )
                    range = i_first-1:i_first+1;
                    p = polyfit(range,cost(range),2);
                    disparity = roots(p);
                    disparity = real(disparity);
                    disparity = disparity(1);
                end

                disp_cnt = disp_cnt+1;
                disparity = disparity-1; %compensate for the disparity offset introduced in line 42 (D+1)
                image_coordinates(disp_cnt,:) = [line i disparity];
                Disp_map(line,i) = round(disparity*6)-4;

            end
        end
    end
end

% for line = 1+feature_window_vertical:height-feature_window_vertical
%
%
%     for i = feature_window_horizontal+1: width/4*3
%         if (DIFF_R(line,i) > DIFF_R(line,i-1)) && (DIFF_R(line,i) > DIFF_R(line,i+1) && DIFF_R(line,i) > DIFF_THRESHOLD ) % check if current idx is local maximum and value exceeds min_threshold
% %         if (DIFF_R(line,i+1) > DIFF_R(line,i)) && (DIFF_R(line,i+1) > DIFF_R(line,i+2) && DIFF_R(line,i+1) > DIFF_THRESHOLD ) % check if current idx is local maximum and value exceeds min_threshold
% %         if (DIFF_R(line,i-1) > DIFF_R(line,i-2)) && (DIFF_R(line,i-1) > DIFF_R(line,i) && DIFF_R(line,i-1) > DIFF_THRESHOLD ) % check if current idx is local maximum and value exceeds min_threshold
%
%             ii = i;
%
%             % perform SAD calculations
%             for D = 0:max_disparity
%                 cost(D+1) = sum(sum(imabsdiff(imgL(line-feature_window_vertical:line+feature_window_vertical,ii-feature_window_horizontal+D:ii+feature_window_horizontal+D,1),imgR(line-feature_window_vertical:line+feature_window_vertical,ii-feature_window_horizontal:ii+feature_window_horizontal,1))));
%             end
%
% %             for D = 0:max_disparity
% %                 cost(D+1) = sum(sum(imabsdiff(imgL(line-feature_window_vertical:line+feature_window_vertical,ii-feature_window_horizontal:ii+feature_window_horizontal,1),imgR(line-feature_window_vertical:line+feature_window_vertical,ii-feature_window_horizontal-D:ii+feature_window_horizontal-D,1))));
% %             end
%
%
%             [first, i_first] = min(cost); % find minimum cost c1
%             neighbors = i_first-1:i_first+1;
% %             neighbors = [i_first i_first i_first];
%             if neighbors(1) == 0
%                 neighbors = 1:2;
%             elseif neighbors(3) == disparity_range+1
%                 neighbors = neighbors(end-2:end-1);
%             end
%
%             cost_neighbors = cost(neighbors);
%             cost(neighbors) = 1000000;
%             second = min(cost);   % find second minimum cost c2
%             cost(neighbors) = cost_neighbors;
%
%             if (second / first > FEATURE_FACTOR && second > MATCHING_THRESHOLD(i_first) ) % check if match peak ratio ( PKR-N ) exceeds minimum threshold
%
%                 disparity = i_first;
%
%                 if ( i_first > 1 && i_first < max_disparity )
%                     range = i_first-1:i_first+1;
%                     p = polyfit((range),cost(range),2);
%                     disparity = roots(p);
%                     disparity = real(disparity);
%                     disparity = disparity(1);
%
%                 end
%
%                 disp_cnt = disp_cnt+1;
%                 disparity = disparity-1; %compensate for the disparity offset introduced in line 42 (D+1)
% %                 disparity = max_disparity-disparity;
%                 image_coordinates(disp_cnt,:) = [line i+round(disparity) disparity];
%                 Disp_map(line,i) = round(disparity*6)-4;
%
%             end
%         end
%     end
% end

image_coordinates = image_coordinates(1:disp_cnt,:);
% disp_cnt
% figure(6)
% imshow([imgL ; imgR; imgR(:,1:width/2) imgL(:,width/2+1:end) ])

end
