%Case1-Front1.bmp
%Case2-Front2.jpg
%Case2-Rear1.jpg
%Case2-Rear2.jpg
test_img = imread('Case2-Front2.jpg'); 
    
    im_cropped_image = pre_processing_image(test_img);      % get a 500x500 image
    imgcrope= im_cropped_image;
    %crop
    im_cropped_image=rgb2gray(im_cropped_image);
    im_cropped_image = imcrop(im_cropped_image,[130 130 200 200]);
    im_cropped_image = imsharpen(im_cropped_image);
    %canny
    BW = edge(im_cropped_image,'Canny',0.2);
        figure, imshow(BW);
        
    %fill holes
    BW = imfill(BW,'holes');
    
se = strel('disk',2);
BW = imclose(BW,se);
se = strel('disk',2);
BW = imerode(BW,se);

%dilation        
se = strel('square', 2);
BW = imdilate(BW,se);
figure,imshow(BW), title('after dilation');

max = -1;
[L ,num] = bwlabel(BW);
st = regionprops(L, 'BoundingBox','Area','Perimeter');
figure, imshow(BW);
hold on
x=0;
y=0;
w=0;
h=0;
for k = 1 : length(st)
     BB = st(k).BoundingBox;

     area=BB(4)*BB(3);

     if BB(4)>BB(3)
         X=BB(3)/BB(4);
     else 
         X= BB(4)/BB(3);
     end
     
      if X>=0.5 && X<1 && area >= 153 && area <= 1634
           area = st(k).Area;
           perm = st(k).Perimeter;
           circularity = (4*pi*area) / (perm^2)
           
           if (circularity>max)
               max = circularity;
           x=BB(1);
           y=BB(2);
           w=BB(3);
           h=BB(4);
           end
      end    
end


for k = 1 : length(st)
     
     BB = st(k).BoundingBox;
     area=BB(4)*BB(3);
   
     if BB(4)>BB(3)
         X=BB(3)/BB(4);
     else 
         X= BB(4)/BB(3);
     end
     
     if X>=0.5&&X<1&&area>=153&&area<=1634
           area = st(k).Area;
           perm = st(k).Perimeter;
           circularity = (4*pi*area) / (perm^2);
           
           if (circularity==max)
               rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],'EdgeColor','r','LineWidth',2) ;
           end
      end
end

myimg=imcrop(imgcrope,[x+128 y+128 w+2 h+2]);
%figure,imshow(myimg);
similarity(myimg);


function s=similarity(myimg)
[r,c,~] = size(myimg);

A1= imread('1.jpg');
A2 = imread('2.jpg');
A3 = imread('3.jpg');
A4 = imread('4.jpg');
A1= imresize(A1, [r c]);
A2= imresize(A2, [r c]);
A3= imresize(A3, [r c]);
A4= imresize(A4, [r c]);

[ssimval1,ssimmap] = ssim(im2double(A1),myimg);
[ssimval2,ssimmap] = ssim(im2double(A2),myimg);
[ssimval3,ssimmap] = ssim(im2double(A3),myimg);
[ssimval4,ssimmap] = ssim(im2double(A4),myimg);


s= max([ssimval1,ssimval2 ,ssimval3, ssimval4])
if s==ssimval1
    figure, imshow(myimg),title('opel');
end
if s ==ssimval2
    figure, imshow(myimg),title('Kia')
end
if s ==ssimval3 || s ==ssimval4
    figure, imshow(myimg),title('hyundai');  
end

end



function I = pre_processing_image(im) % im is the file name

im_test_rgb = im2double(im);    


im_rows = 500;
im_cols = 500;

% resize the image
I = imresize(im_test_rgb, [im_rows im_cols]);


end