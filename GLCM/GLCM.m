function [glcm] = GLCM(img,G,dx,dy,normalize,symmetric)
%GLCM calculates the GLCM (Gray Level Coocurrence
%Matrices) of an image
%   img         : the input image
%   G           : number of gray levels
%   dx          : distance in x-direction
%   dy          : distance in y-direction
%   normalize   : if 1 normalize by pixel pairs
%                 so sum(glcm(:)) = 1
%   symmetric   : if 1 make GLCM matrix symmetric
[N,M] = size(img);
glcm = zeros(G);

% For the image go through the entire image and count how many transitions
% from the first to the second graylevel
for i = 1:N
    for j = 1:M
        %Some idexing details, could proably be simlified ?
        if i+dy > N || i+dy < 1 || j+dx > M || ...
                j+dy < 1 || i + dx < 1 || j + dx < 1
           continue
        end
        firstGLevel = img(i,j);
        secondGLevel = img(i+dy,j+dx);
        glcm(firstGLevel+1, secondGLevel+1) = ...
                glcm(firstGLevel+1, secondGLevel+1) + 1;
    end
end

% If we want a symmetric GLCM add the transpose. Read about the symmetric
% GLCM in the book or the lecture foils. It is basically counting both 2,1
% and 1,2 graylevel. Thus "counting both ways".
if symmetric
    glcm = glcm+glcm';
end
% If we want to normalize the GLCM
if normalize
    glcm = glcm/sum(sum(glcm));
end
end
% post_id = 286; %delete this line to force new post;
% permaLink = http://inf4300.olemarius.net/2015/09/09/glcmexercises-m/;