function[glcmVar,glcmCtr,glcmEnt,glcmEne,glcmHom,glcmCor] = glidingGLCM(img,G,dx,dy,windowSize)
%GlidingGLCM
% Calulates the GLCM and the feature in fun for
% every gliding window in img. It is first added
% a frame of ones around img to make sure that the
% resulting feature images is the same size as img.

[Mo,No] = size(img);            %Size of original image
halfSize = floor(windowSize/2); %Size of "half" the filter

% Expand the original image with a zero border
imgWithBorders = zeros(Mo+windowSize-1, No+windowSize-1);
imgWithBorders(halfSize:end-halfSize-1,halfSize:end-halfSize-1) = img;

% figure(100)
% imagesc(imgWithBorders);
% colormap gray
% title('The resuting image with borders')

% Size of the image with borders
[M,N] = size(imgWithBorders);

% Index matrices. These are needed for the online implementation of the
% GLCM features
i = repmat((0:(G-1))', 1, G);
j = repmat( 0:(G-1)  , G, 1);

% Defining buffers for the resulting glcm feature images
glcmVar = zeros(Mo,No);
glcmCtr = zeros(Mo,No);
glcmEnt = zeros(Mo,No);
glcmHom = zeros(Mo,No);
glcmEne = zeros(Mo,No);
glcmCor = zeros(Mo,No);


% Go through the image
for m = 1+halfSize:M-halfSize-1
    for n = 1+halfSize:N-halfSize-1

        % Extracting the wanted window
        window = imgWithBorders(m-halfSize:m+halfSize,n-halfSize:n+halfSize);
        % Calculate the
        p = GLCM(window,G, dx,dy,0,0);

        % Compute GLCM's variance feature.
        mu = mean(window(:));
        sig=std(window(:));
        glcmVar(m-halfSize,n-halfSize) = sum(sum(p .* ((i-mu).^2)));
        % Computed using for-loops:
        % for i = 0:(G-1)
        %     for j = 0:(G-1)
        %         glcm_var(m,n) = glcm_var(m,n) + p(i+1,j+1) * (i-mu)^2;
        %     end
        % end

        % Compute GLCM's contrast feature.
        glcmCtr(m-halfSize,n-halfSize) = sum(sum(p .* ((i - j).^2)));
        % Computed using for-loops:
        % for i = 0:(G-1)
        %     for j = 0:(G-1)
        %         glcm_ctr(m,n) = glcm_ctr(m,n) + p(i+1,j+1) * (i-j)^2;
        %     end
        % end

        % Compute GLCM's entropy feature (with base 2).
        glcmEnt(m-halfSize,n-halfSize) = -sum(p(p>0) .* log2(p(p>0)));
        
        glcmHom(m-halfSize,n-halfSize) = sum(sum(p/(1+abs(i-j))));
        
        glcmEne(m-halfSize,n-halfSize) = sum(sum(p.*p));
        
        glcmCor(m-halfSize,n-halfSize) = sum(sum((i-mu*i)*(j-mu*j)*p)/(sig*sig));
    end
end
end