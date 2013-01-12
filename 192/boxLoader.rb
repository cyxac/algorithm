def most_item(box_x, box_y, box_z, item_x, item_y, item_z)
    [item_x, item_y, item_z].permutation.map do |a, b, c|
        (box_x/a) * (box_y/b) * (box_z/c)
    end.max
end

p most_item(100, 98, 81, 3, 5, 7) # 7560
p most_item(10, 10, 10, 9, 9, 11) # 0
p most_item(201, 101, 301, 100, 30, 20) # 100
p most_item(913, 687, 783, 109, 93, 53) # 833
p most_item(6,5,4,3,2,1) # 20