def count_sites n, m
    res = 0
    (-n..n).each do |x1|
        (1..m).each do |y1|
            y2 = y1
            (x1+1..n).each do |x2|
                y2_square = x1**2 + y1**2 - x2**2
                break if y2_square < 0
                y2 = y2_square**(0.5)
                next if y2 % 1 != 0
                y2 = y2.to_i

                dx, dy = x1+x2, y1+y2
                box_width = [0, dx, x1, x2].max - [0, dx, x1, x2].min
                box_height = [0, dy, y1, y2].max - [0, dy, y1, y2].min
                # next if box_height*box_width == 0

                next if n - box_width + 1 < 0 or m-box_height+1 < 0
                num_site_for_box = (n - box_width + 1)*(m-box_height+1)
                
                res += num_site_for_box
            end
        end
    end
    res
end

p count_sites 2, 2
p count_sites 1, 6
p count_sites 6, 8