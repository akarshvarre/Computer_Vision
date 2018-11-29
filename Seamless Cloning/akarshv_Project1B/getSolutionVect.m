function solVectorb = getSolutionVect(indexes, source, target, offsetX, offsetY)
%% Enter Your Code Here
k = find(indexes~=0);
temp_mask = zeros(size(indexes));
temp_mask(k) = 1;

laplacian = [ 0  1 0; 1 -4 1; 0  1 0];
lap =  conv2(source, -laplacian, 'same');
b = zeros(1,length(k));

%count is used ot loop through b vector
count = 0; 
    for y = 2:((size(indexes,1))-1)
        for x = 2:((size(indexes,2))-1)

            
            if temp_mask(y, x) ~= 0

                count = count + 1;   

                % the corresponding position in the target image
                yd = y;
                xd = x; 

                  %top      
                if temp_mask(y-1, x) == 0
           
                    b(1, count) = b(1, count) + target(yd-1, xd);
%                    
                end

                %  left
                if temp_mask(y, x-1) == 0
                     
                    b(1, count) = b(1, count) + target(yd, xd-1);
                    
                end

                %  bottom            
                if temp_mask(y+1, x) == 0
             
                    b(1, count) = b(1, count) + target(yd+1, xd);
                    
                end

                %  right side
                if temp_mask(y, x+1) == 0
                   
                    b(1, count) = b(1, count) + target(yd, xd+1);
                    
                end       
                		
                b(1, count) = b(1, count) + (lap(y-offsetY, x-offsetX));
                 
            end
        end
    end
  solVectorb = b;  
    
end
