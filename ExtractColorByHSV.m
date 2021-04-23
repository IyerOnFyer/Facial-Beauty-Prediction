function ExtractColorByHSV(image)
    color = 'red';
    close all;  % Close figures

    % Change the current folder to the folder of this m-file.
    if(~isdeployed)
      cd(fileparts(which(mfilename)));
    end
        
    im = imread(image);
    
    hsvIm = rgb2hsv(im);    % Convert RGB to HSV
    hIm = hsvIm(:,:,1); % Get the hue
    sIm = hsvIm(:,:,2); % Get the saturation
    vIm = hsvIm(:,:,3); % Get the value
    
    % Plot original image
    subplot(3,3,1);
    imshow(im);
    title('Original Image');
    
    % Plot the HSV images
    subplot(3,3,4);
    imshow(hIm);
    title('Hue Image');
    subplot(3,3,5);
    imshow(sIm);
    title('Saturation Image');
    subplot(3,3,6);
    imshow(vIm);
    title('Value Image');
    
    % Plot the HSV values
    subplot(3,3,7);
    imhist(hIm);
    title('Hue Dist');
    subplot(3,3,8);
    imhist(sIm);
    title('Saturation Dist');
    subplot(3,3,9);
    imhist(vIm);
    title('Value Dist');
    
    % Get hue, saturation, value masks
    [hThresholdLow, hThresholdHigh, sThresholdLow, sThresholdHigh, ... 
        vThresholdLow, vThresholdHigh] = GetThresholds(color);
    
    % Apply masks
    mask = (sIm >= sThresholdLow) & (sIm <= sThresholdHigh);
    mask = mask & (vIm >= vThresholdLow) & (vIm <= vThresholdHigh); 
    if hThresholdLow < 0 % If hue is red
        mask = mask & (hIm <= hThresholdHigh);
        mask = mask | ((hIm >= -hThresholdLow) & (hIm <= 1));
    else
        mask = mask & (hIm >= hThresholdLow) & (hIm <= hThresholdHigh);
    end
    
    % Plot original image
    subplot(3,3,2);
    imshow(mask);
    title('Processed Image');
    
    imwrite(mask, 'processed_image.jpg');
    
    hhist=imhist(hIm);
    shist=imhist(sIm);
    vhist=imhist(vIm);
    
    figure;
    plot(hhist);
    figure;
    plot(shist);
    figure;
    plot(vhist);
end

% GetThresholdValues - Gets the threshold values for the different colors
function [hThresholdLow, hThresholdHigh, sThresholdLow, sThresholdHigh, ... 
        vThresholdLow, vThresholdHigh]  = GetThresholds(color)

    % Hue, saturation, value thresholds
    switch color
        case 'red' % Red goes from 0.9 to 1 and 0 to 0.2, thus use neg
            hThresholdLow = -359/360;
			hThresholdHigh = 19/360;
			sThresholdLow = 0.05;
			sThresholdHigh = 1;
			vThresholdLow = 0;    
			vThresholdHigh = 1;   
        case 'green'
            hThresholdLow = 70/360;
			hThresholdHigh = 180/360;
			sThresholdLow = 0.4;
			sThresholdHigh = 1;
			vThresholdLow = 0.3;    % 30%
			vThresholdHigh = 0.6;   % 60%
        otherwise  
            warndlg('Invalid color');
    end
    
end