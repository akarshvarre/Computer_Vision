function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
%% Enter Your Code Here

indexes = zeros(targetH,targetW);

%resize the mask to the target image size
for y1=1:100
    for x1 = 1:100
        indexes(offsetY+y1-1,offsetX+x1-1) = mask(y1,x1);
    end
end


%compute the indexes matrix
count1 = 0;
for y = 1:size(indexes,1)
    for x = 1:size(indexes,2)
        if indexes(y, x) ~= 0
            count1 = count1 + 1;
            indexes(y, x) = count1;
        end
    end
end


end
