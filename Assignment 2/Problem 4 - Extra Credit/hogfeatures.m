%% test image - 'pd6.jpg'

images = ['ms02.jpg';'ms03.jpg';'ms04.jpg';'ms05.jpg';'ms06.jpg';'ms07.jpg';'ms08.jpg';'ms09.jpg';'ms10.jpg';
  'pd01.jpg';'pd02.jpg';'pd03.jpg';'pd04.jpg';'pd05.jpg';'pd06.jpg';'pd07.jpg';'pd08.jpg';'pd09.jpg';'pd10.jpg';];

cellsize = 2;
conVector = [];
for  i = 1:length(images)
   
   I = imread(images(i,:));
   I = im2single(I);
   
   Ihog = vl_hog(I,cellsize);
   
   %imIhog = vl_hog('render', Ihog, 'verbose');
   %title = ['hog' images(i,:)];
   %imwrite(imIhog, title);
   
   reshape_Ihog = reshape(Ihog, [], 1);
   
   conVector = [conVector reshape_Ihog];
end

label = [1 1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];

[W, B] = vl_svmtrain(conVector, label, 0.1);

testImage = 'msor01.jpg';
Itest = imread(testImage);
Itest = im2single(Itest);


% Sliding Window feature
maxrow=1;
maxcol=1;
maxscore = -1;
refsize(1) = size(Itest,1)/2;
refsize(2) = size(Itest,2)/2;
blocksize = 128;
for row = 1:blocksize:size(Itest,1)-refsize(1)
 for col = 1:blocksize:size(Itest,2)-refsize(2)
   window = imresize(Itest(r:r+refsize(1)-1, c:c+refsize(2)-1, :),[522 293]);
   Itesthog = vl_hog(window, cellsize);  
   scores = W'*reshape(Itesthog,[],1) + B;
   if(scores > maxscore)
       maxscore = scores;
       maxrow = row;
       maxcol = col;
    end
  end
 end

% saving the scores

fileID = fopen('scores.txt','a');
%fprintf(fileID,'%6s %20s\n','TestImage','Score');
fprintf(fileID,'%6s %24f\n',testImage, scores);
fclose(fileID);
