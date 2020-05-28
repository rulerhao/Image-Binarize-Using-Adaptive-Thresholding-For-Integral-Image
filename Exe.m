clear;
im = imread('Black_Bird.jpg');
im = im(:,:,1);
%imshow(im);
Padding_Length = 5;

Sensitivity = 0.9;

Logical_Image = Set_Image_To_Logical(im,Padding_Length,Sensitivity); %���� Sensitivity value �p�G�ണ����䤤���I���󰪮ĪG

Imcomplement_Logical_Image = imcomplement(Logical_Image);

%imshow(Imcomplement_Logical_Image);

Logical_Image_Connected_Components = bwconncomp(Imcomplement_Logical_Image); %�D�X�h�ӳs��������

List = Logical_Image_Connected_Components.PixelIdxList;

[~,Size_Of_List] = size(List);

for i = 1 : Size_Of_List
    [Size_Of_Connected_Components(i),~] = size(List{1,i});
end
[~, Idx] = max(Size_Of_Connected_Components); %�D�X�̤j�s��������

Imcomplement_Logical_Image(1:end) = 1;
Imcomplement_Logical_Image(Logical_Image_Connected_Components.PixelIdxList{Idx}) = 0;

imshow(Imcomplement_Logical_Image);

imwrite(Imcomplement_Logical_Image,'Processed_Black_Bird.jpg');