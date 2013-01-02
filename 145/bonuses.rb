def get_division(points)
    total = points.reduce(0, :+)
    bonuses = points.map {|p| (p*100) / total}
    extra = 100 - bonuses.reduce(0, :+)
    if extra != 0
        ranked_index = points.each_with_index.sort_by{|p,i| -p}.map {|p,i| i}
        (0...extra).each {|i| bonuses[ranked_index[i]] += 1}
    end
    return bonuses
end

puts get_division([1,2,3,4,5]).to_s
puts get_division([5,5,5,5,5,5]).to_s
puts get_division([485, 324, 263, 143, 470, 292, 304, 188, 100, 254, 296, 255, 360, 231, 311, 275,  93, 463, 115, 366, 197, 470]).to_s