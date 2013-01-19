def determine(x, y)
    points = x.zip y # points is [[x1, y1],[x2,y2]...]
    found = 0
    used_angle = nil
    points.combination(2) do |point1, point2|
        x1, y1 = point1
        x2, y2 = point2
        angle = Math.atan2(y2 - y1, x2 - x1)
        next if !used_angle.nil? and considered? angle, used_angle
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

def considered?(angle, used)
    equal?(angle, used) or equal?((angle - used).abs%(Math::PI/2), 0)
end

$delta = 1.0e-5
def equal?(a, b)
    (a - b).abs < $delta
end

def less?(a, b)
    (b - a) > $delta
end

def good_for_square?(points)
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
        if equal?(x, x_min) and equal?(y, y_min)
            pos[0] = 1
        elsif less?(x_min, x) and less?(x, x_max) and equal?(y, y_min)
            pos[1] = 1
        elsif equal?(x, x_max) and equal?(y, y_min)
            pos[2] = 1
        elsif equal?(x, x_min) and less?(y_min, y) and less?(y, y_max)
            pos[3] = 1
        elsif equal?(x, x_max) and less?(y_min, y) and less?(y, y_max)
            pos[4] = 1
        elsif equal?(x, x_min) and equal?(y, y_max)
            pos[5] = 1
        elsif less?(x_min, x) and less?(x, x_max) and equal?(y, y_max)
            pos[6] = 1
        elsif equal?(x, x_max) and equal?(y, y_max)
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
        return equal?(width, height)
    elsif pos[6] == 0 and pos[1] == 0
        #case ||
        return "ambiguous" if less?(height, width)
        return equal?(height, width)
    elsif pos[3] == 0 and pos[4] == 0
        #case =
        return "ambiguous" if less?(width, height)
        return equal? width, height
    elsif pos[6] == 0 or pos[1] == 0
        #case U and n
        less?(height, width) or equal?(height, width)
    elsif pos[3] == 0 or pos[4] == 0
        #case C and )
        less?(width, height) or equal?(width, height)
    end
end

p determine([0,0,2,3,5,5,3,2],[2,3,0,0,3,2,5,5]) # ambiguous
p determine([0,0,10,10,4],[0,10,0,10,5]) # inconsistent
p determine([1,1,1,1,1,1,1,1,1,1,1,1,1,2,3,4,5,6,7,8,9,10,11,12,13,
13,13,13,13,13,13,13,13,13,13,13,13,12,11,10,9,8,7,6,5,4,3,2],
[1,2,3,4,5,6,7,8,9,10,11,12,13,13,13,13,13,13,13,13,13,13,13,13,13,
12,11,10,9,8,7,6,5,4,3,2,1,1,1,1,1,1,1,1,1,1,1,1]) # consistent
p determine([0,4,8,-5,-1,3], [0,3,6,15,18,21]) # consistent
p determine([0,4,8,-5,-1,3,16], [0,3,6,15,18,21,12]) # inconsistent
p determine([0,4,8,-5,-1], [0,3,6,15,18]) # ambiguous
p determine([998,-1000,-998,1000,999], [1000,998,-1000,-998,0]) # inconsistent
p determine([0,1,2,0,100], [0,0,0,1,140]) # consistent
p determine([0,1,2,0,2,0], [0,0,0,2,2,3]) # inconsistent