function coeffA = getCoefficientMatrix(indexes)
%% Enter Your Code Here
%create a temporary mask to evaluate the boundary pixes
k = find(indexes~=0);
temp_mask = zeros(size(indexes));
temp_mask(k) = 1;

A = zeros();
count = 0; %is used to loop through A vector
for y = 2:((size(indexes,1))-1)
    for x = 2:((size(indexes,2))-1)
        
   %If the temp_mask pixel is not zero 
        if temp_mask(y, x) ~= 0
            
            count = count + 1;
            
            % corresponding position in the target image
            yt = y;
            xt = x;
            % Top
            if temp_mask(y-1, x) ~= 0

                colIndex = indexes(yt-1, xt);
                A(count, colIndex) = -1;
            end  
                %left
            if temp_mask(y, x-1) ~= 0
                colIndex = indexes(yt, xt-1);
                A(count, colIndex) = -1;
                
            end   
                %bottom
            if temp_mask(y+1, x) ~= 0
                colIndex = indexes(yt+1, xt);
                A(count, colIndex) = -1;
                
            end
                
                % right
            if temp_mask(y, x+1) ~= 0
                colIndex = indexes(yt, xt+1);
                A(count, colIndex) = -1;
                
            end
            
            %finally the daigonal element
            A(count, count) = 4;
            
        end
    end
end

coeffA = A;
end
