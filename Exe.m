clear;
im = imread('Black_Bird.jpg');
im = im(:,:,1);
%imshow(im);
Padding_Length = 5;

Sensitivity = 0.9;

Logical_Image = Set_Image_To_Logical(im,Padding_Length,Sensitivity); %此的 Sensitivity value 如果能提高對找中心點有更高效果

Imcomplement_Logical_Image = imcomplement(Logical_Image);

%imshow(Imcomplement_Logical_Image);

Logical_Image_Connected_Components = bwconncomp(Imcomplement_Logical_Image); %求出多個連接的部分

List = Logical_Image_Connected_Components.PixelIdxList;

[~,Size_Of_List] = size(List);

for i = 1 : Size_Of_List
    [Size_Of_Connected_Components(i),~] = size(List{1,i});
end
[~, Idx] = max(Size_Of_Connected_Components); %求出最大連接的部分

Imcomplement_Logical_Image(1:end) = 1;
Imcomplement_Logical_Image(Logical_Image_Connected_Components.PixelIdxList{Idx}) = 0;

imshow(Imcomplement_Logical_Image);

imwrite(Imcomplement_Logical_Image,'Processed_Black_Bird.jpg');