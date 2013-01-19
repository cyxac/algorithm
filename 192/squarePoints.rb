def determine(x, y)
    points = x.zip y # points is [[x1, y1],[x2,y2]...]
    found = 0
    used_angle = nil
    points.combination(2) do |point1, point2|
        x1, y1 = point1
        x2, y2 = point2
        angle = Math.atan2(y2 - y1, x2 - x1)
        next if angle == used_angle
        r_points = points.map do |x, y|
            [x*Math.cos(-angle) - y*Math.sin(-angle),
            x*Math.sin(-angle) + y*Math.cos(-angle)]
        end
        
        answer = good_for_square? r_points
        return answer if answer == "ambiguous"
        if answer == true
            found += 1 if answer == true
            used_angle = angle    
        end
        return "ambiguous" if found > 1
    end
    return "consistent" if found == 1
    return "inconsistent" if found == 0
end

def good_for_square?(points)
    #p points
    x_min, x_max, y_min, y_max = points.reduce(
        [Float::INFINITY, 
        -Float::INFINITY, 
        Float::INFINITY, 
        -Float::INFINITY]) do |memo, point|
        [   [point[0], memo[0]].min,
            [point[0], memo[1]].max,
            [point[1], memo[2]].min,
            [point[1], memo[3]].max,]
    end
    return "ambiguous" if y_min == y_max #case _
    width = x_max - x_min
    height = y_max - y_min
    
    pos = [0]*8
    points.each do |x, y|
        if x == x_min and y == y_min
            pos[0] = 1
        elsif x_min < x and x < x_max and y == y_min
            pos[1] = 1
        elsif x == x_max and y == y_min
            pos[2] = 1
        elsif x == x_min and y_min < y and y < y_max
            pos[3] = 1
        elsif x == x_max and y_min < y and y < y_max
            pos[4] = 1
        elsif x == x_min and y == y_max
            pos[5] = 1
        elsif x_min < x and x < x_max and y == y_max
            pos[6] = 1
        elsif x == x_max and y == y_max
            pos[7] = 1
        else
            return false
        end
    end
    
    if [pos[3], pos[5], pos[6]] == [0,0,0] or
        [pos[6], pos[7], pos[4]] == [0,0,0]
        #case L
        return "ambiguous"
    elsif [pos[1], pos[3], pos[4],pos[6]] == [1,1,1,1]
        #case O
        return width == height
    elsif pos[6] == 0 and pos[1] == 0
        #case ||
        return "ambiguous" if height < width
        return true if height == width
        return false if height > width
    elsif pos[3] == 0 and pos[4] == 0
        #case =
        return "ambiguous" if width < height
        return true if width == height
        return false if width > height
    elsif pos[6] == 0 or pos[1] == 0
        #case U and n
        return height <= width
    elsif pos[3] == 0 or pos[4] == 0
        #case C and )
        return width <= height
    end
end

p determine([0,0,2,3,5,5,3,2],[2,3,0,0,3,2,5,5])