def max_sub_array a
    max_sub = []
    max = -Float::INFINITY
    t_max_sub = []
    t_sum = -Float::INFINITY
    
    a.each_with_index do |e, i|
        if t_sum <= 0
            t_sum = e
            t_max_sub = [i, i]
        else
            t_sum += e
            t_max_sub[1] = i
        end
        
        if max < t_sum
            max_sub = t_max_sub.dup
            max = t_sum
        end
    end
    [max, a[max_sub[0]..max_sub[1]]]
end


def ways_for_sum a
    max = a.reduce(0, :+)
    ways = Hash.new(0)
    ways[0] = 1
    a.each do |e|
        max.downto(e) do |sum|
            ways[sum] += ways[sum-e]
        end
    end
    ways
end

if __FILE__ == $0
  p max_sub_array [1, -4, 7, -1, 10]
  p max_sub_array [13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7]
  p ways_for_sum [1, 2, 3, -4]   
end
