def num_paths distance, max_height, landmarks
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

puts num_paths(5, 2, []) # 3
puts num_paths(2, 45, []) # 0
puts num_paths(5, 2, [2,2]) # 1
puts num_paths(8, 3, [2,2,3,1]) # 7
puts num_paths(38, 11, [4,5,8,5,6]) # 201667830444