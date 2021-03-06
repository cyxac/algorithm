MAX_TRY = 10_000_000

def bounces(rows, columns, startrow, startcol, holes)
    return -1 if holes.empty?
    
    $holes = holes.map do |s|
        s.split(" ").map(&:to_i).reverse!
    end
    
    $bad_plus, $bad_minus = {}, {}
    $holes.each do |x, y|
        $bad_plus[x-y] = true
        $bad_minus[x+y] = true
    end
    
    bounce = 0
    start = [startcol, startrow]
    dir = [1,1]
    0.upto(MAX_TRY) do
        end_point, new_start, new_dir = travel(start, dir, rows, columns)
        #p end_point, new_start,new_dir
        return bounce if fall?(start, end_point, dir, bounce)
        start = new_start
        dir = new_dir
        bounce += 1
    end
    
    -1
end

def travel(start, dir, rows, columns)
    x, y = start
    if dir[0] > 0
        x_dist = columns - 1- x
    else
        x_dist = x
    end
    
    if dir[1] > 0
        y_dist = rows - 1 - y
    else
        y_dist = y
    end
    
    wall_dist = [x_dist, y_dist].min
    end_point = x + dir[0]*wall_dist, y + dir[1]*wall_dist
    new_dir = dir.dup
    new_dir[1] = -dir[1] if wall_dist == y_dist
    new_dir[0] = -dir[0] if wall_dist == x_dist
    new_start = end_point[0] + (dir[0]+new_dir[0])/2,
                end_point[1] + (dir[1]+new_dir[1])/2
    [end_point, new_start, new_dir]
end

def fall?(start, end_point, dir, bounce)
    if bounce == 0
        slow_fall?(start, end_point)
    else
        quick_fall?(start, dir)
    end
end

def slow_fall?(start, end_point)
    xs, ys = start
    xe, ye = end_point
    $holes.each do |xh, yh|
        if (yh-ys)*(xe-xs) == (ye-ys)*(xh-xs)
            if (xs..xe).cover?(xh) and (ys..ye).cover?(yh)
                return true
            end
        end
    end
    false
end

def quick_fall?(start, dir)
    x, y = start
    dir[0] == dir[1] ? $bad_plus[x-y] : $bad_minus[x+y]
end

p bounces(8, 11,2,1,["1 5", "5 3", "4 4"])
p bounces(6,5,5,3,["1 3"])
p bounces(6,7,4,4,[])
p bounces(3,3,1,1,["2 2"])
p bounces(6,6,0,5,["4 1", "3 2", "4 3", "2 1", "3 0", "5 2"])
p bounces(1000000,999999,66246,84332,["854350 4982"])
p bounces(5,7,3,4,["0 6", "2 3"])
p bounces(1,5,0,1,["0 3"])

# 3
# 7
# -1
# 0
# -1
# 1662562
# 5
# 2