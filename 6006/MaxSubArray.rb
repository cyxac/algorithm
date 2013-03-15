def find_max_sub_array a
    max_sub = []
    max = -Float::INFINITY
    
    max_sub_right = []
    max_right = -Float::INFINITY
    
    a.each do |e|
        if max_right <= 0
            max_right = e
            max_sub_right = [e]
        else
            max_right += e
            max_sub_right << e
        end
        
        if max < max_right
            max_sub = max_sub_right.dup
            max = max_right
        end
    end
    max_sub
end

p find_max_sub_array [1, -4, 7, -1, 10]
p find_max_sub_array [13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7]