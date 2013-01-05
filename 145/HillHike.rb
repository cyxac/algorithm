def num_paths distance, max_height, landmarks
    cache1 = Array.new(2) { Array.new(52) { Array.new(51) { 0 } } }
    cache2 = Array.new(cache1)
    cache1[0][0][0] = 1
    1.upto(distance - 1) do |i|
       cache2 =  Array.new(2) { Array.new(52) { Array.new(51) { 0 } } }
       1.upto(max_height) do |j|
           seen_max = j == max_height ? 1 : 0
           0.upto(landmarks.size) do |k|
               -1.upto(1) do |d|
                   lm = j == landmarks[k] ? k + 1 : k
                   # if j == max_height
                   #     cache2[1][j][lm] += cache1[0][j + d][k]
                   #     cache2[1][j][lm] += cache1[1][j + d][k]
                   # else
                   #     cache2[0][j][lm] += cache1[0][j + d][k]
                   #     cache2[1][j][lm] += cache1[1][j + d][k]
                   # end
                   cache2[seen_max][j][lm] += cache1[0][j + d][k]
                   cache2[1][j][lm] += cache1[1][j + d][k]
               end
           end
       end
       cache1 = cache2
    end
    return cache1[1][1][landmarks.size]
end

puts num_paths(5, 2, []) # 3
puts num_paths(2, 45, []) # 0
puts num_paths(5, 2, [2,2]) # 1
puts num_paths(8, 3, [2,2,3,1]) # 7
puts num_paths(38, 11, [4,5,8,5,6]) # 201667830444