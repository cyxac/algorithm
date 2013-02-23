def num_paths_bottomup distance, max_height, landmarks
    cache1 = Hash.new(0) # Array.new(2) { Array.new(52) { Array.new(51) { 0 } } }
    cache1[[false,0,0]] = 1 # Treat it as 3d array. indexed by <seen_max, height, num_landmarks>
    1.upto(distance - 1) do
       cache2 = Hash.new(0)
       1.upto(max_height) do |h|
           max = h == max_height
           0.upto(landmarks.size) do |k|
               -1.upto(1) do |d|
                   lm = h == landmarks[k] ? k + 1 : k
                   # if h != max_height, update both seen max and not seen max table,
                   # otherwise, use sum of the true and false data to update the true data,
                   # false data should be zero at h, so leave it to the hash.
                   cache2[[max,h,lm]] += cache1[[false,h + d,k]]
                   cache2[[true,h,lm]] += cache1[[true,h + d,k]]
               end
           end
       end
       cache1 = cache2
    end
    return cache1[[true,1,landmarks.size]]
end

def num_paths_2 distance, max_height, landmarks
    memo = {}
    num_paths_topdown = lambda do |distance, height, seen_max, num_lm_seen|
        return memo[[distance, height, seen_max, num_lm_seen]] if memo.has_key?([distance,height, seen_max, num_lm_seen])
        if distance == 0
            return 1 if seen_max == false and height == 0 and num_lm_seen == 0 
            return 0
        end
        if height <= 0
            return 0
        end
        
        num_paths = 0
        at_max = height == max_height
        if num_lm_seen == 0
            previous_lm = 0
        else
            previous_lm = height == landmarks[num_lm_seen-1] ? num_lm_seen-1 : num_lm_seen
        end
        
        if seen_max and not at_max
            num_paths += num_paths_topdown.call(distance-1, height+1, true, previous_lm)
            num_paths += num_paths_topdown.call(distance-1, height, true, previous_lm)
            num_paths += num_paths_topdown.call(distance-1, height-1, true, previous_lm)
        elsif seen_max and at_max
            num_paths += num_paths_topdown.call(distance-1, height, true, previous_lm)
            num_paths += num_paths_topdown.call(distance-1, height-1, false, previous_lm)
            num_paths += num_paths_topdown.call(distance-1, height-1, true, previous_lm)
        elsif not seen_max and not at_max
            num_paths += num_paths_topdown.call(distance-1, height+1, false, previous_lm)
            num_paths += num_paths_topdown.call(distance-1, height, false, previous_lm)
            num_paths += num_paths_topdown.call(distance-1, height-1, false, previous_lm)
        else
            return 0
        end
        
        memo[[distance, height, seen_max, num_lm_seen]] = num_paths
        num_paths
    end
    
    num_paths_topdown.call distance-1 , 1, true, landmarks.size
end

puts num_paths_2(5, 2, []) # 3
puts num_paths_2(2, 45, []) # 0
puts num_paths_2(5, 2, [2,2]) # 1
puts num_paths_2(8, 3, [2,2,3,1]) # 7
puts num_paths_2(38, 11, [4,5,8,5,6]) # 201667830444