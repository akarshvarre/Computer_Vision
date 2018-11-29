function resultImg = reconstructImg(indexes, red, green, blue, targetImg)
%% Enter Your Code Here

%split the target image
targetImgr = targetImg(:,:,1);
targetImgg = targetImg(:,:,2);
targetImgb = targetImg(:,:,3);

k = find(indexes~=0);
temp_mask = zeros(size(indexes));
temp_mask(k) = 1;


%copy the red blue and green pixels to the target channels
count2 = 1;
for y2 = 2:((size(indexes,1))-1)
    for x2 = 2:((size(indexes,2))-1)
        
      
        if temp_mask(y2, x2) ~= 0
            
           targetImgr(y2,x2) = red(count2);
           targetImgg(y2,x2) = green(count2);
           targetImgb(y2,x2) = blue(count2);
           
           count2 = count2+1;
        end
    end
end

%align the resultant channles

targetImg(:,:,1) = targetImgr;
targetImg(:,:,2) = targetImgg;
targetImg(:,:,3) = targetImgb;

resultImg = targetImg;



end