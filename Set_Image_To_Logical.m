function [Output_Image] = Set_Image_To_Logical(Image,Padding_Size,Sensitivity)
% Use "Adaptive Thresholding Using the Integral Image" to solve
% https://people.scs.carleton.ca/~roth/iit-publications-iti/docs/gerh-50002.pdf
% the main idea is that look for surrounding area of the pixel.
% if the pixel is darker than the surrounding area, set the pixel logical(true)
% s = Padding_Size;
% t = Sensitivity;
% im = Image;
% if area average * t < pixel(i,j)
% set Output_Image(i,j) = logical(true);

im = Image;
s = Padding_Size;
t = Sensitivity;

[h,w] = size(im);
out(h,w) = logical(false);
Sum_Table = zeros(h,w);

% 當 i = 1,j = 1 時
for i = 1:1 + s
    for j = 1:1 + s
        Sum_Table(1,1) = Sum_Table(1,1) + double(im(i,j));
    end
end
% 當 i = 1, j = 1:w 時
for i = 2:w
    Sum_Table(1,i) = Sum_Table(1,i - 1);
    for j = 1:1 + s
        if i <= 1 + s
            Sum_Table(1,i) = Sum_Table(1,i) + double(im(j,i + s));
        elseif i <= w - s
            Sum_Table(1,i) = Sum_Table(1,i) + double(im(j,i + s));
            Sum_Table(1,i) = Sum_Table(1,i) - double(im(j,i - s - 1));
        else
            Sum_Table(1,i) = Sum_Table(1,i) - double(im(j,i - s - 1));
        end
    end
end

% 當 i = 1:h, j = 1 時
for i = 2:h
    Sum_Table(i,1) = Sum_Table(i - 1,1);
    for j = 1:1 + s
        if i <= 1 + s
            Sum_Table(i,1) = Sum_Table(i,1) + double(im(i + s,j));
        elseif i <= h - s
            Sum_Table(i,1) = Sum_Table(i,1) + double(im(i + s,j));
            Sum_Table(i,1) = Sum_Table(i,1) - double(im(i - s - 1,j));
        else
            Sum_Table(i,1) = Sum_Table(i,1) - double(im(i - s - 1,j));
        end
    end
end

% 當 i = 2:h, j = 2:w 時
for i = 2:h
    for j = 2:w
        Upper_Left_pixel = double(0);
        Upper_Right_pixel = double(0);
        Lower_Left_pixel = double(0);
        Lower_Right_pixel = double(0);
        if i - s >= 1 && j - s >= 1
            Upper_Left_pixel = double(im(i - s,j - s));
        end
        if i - s >= 1 && j + s <= w
            Upper_Right_pixel = double(im(i - s,j + s));
        end
        if i + s <= h && j - s >= 1
            Lower_Left_pixel = double(im(i + s,j - s));
        end
        if i + s <= h && j + s <= w
            Lower_Right_pixel = double(im(i + s,j + s));
        end
        
        Sum_Table(i,j) = Sum_Table(i - 1,j) + Sum_Table(i,j - 1) - Sum_Table(i - 1,j - 1) - Lower_Left_pixel - Upper_Right_pixel + Upper_Left_pixel + Lower_Right_pixel;
        
    end
end

for i = 1:h
    for j = 1:w
        height = s * 2 + 1;
        width = height;
        if i - s <= 1
            height = s + i;
        end
        if i + s >= h
            height = h - i + s + 1;
        end
        if j - s <= 1
            width = s + j;
        end
        if j + s >= w
            width = w - j + s + 1;
        end
        
        Count = height * width;;
        
        if (Sum_Table(i,j) / Count) * t < im(i,j)
            out(i,j) = true;
        end
    end
end
Output_Image = out;