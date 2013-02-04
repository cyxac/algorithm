def minimum_effort(initial)
    initial = initial.sort
    min = Float::INFINITY
    0.upto(initial.size-1) do |f|
        0.upto(initial.size-1) do |i|
            dist = initial[f] == initial[i] ? 
                1.5 : (initial[f]-initial[i])/(f-i).to_f
            min = [min, compute_effort(initial, f, dist.floor)].min
            min = [min, compute_effort(initial, f, dist.ceil)].min
        end
    end
    min
end

def compute_effort(initial, fixed, dist)
    initial.each_index.reduce(0) do |memo, i|
        memo + (initial[fixed] + (i-fixed)*dist - initial[i]).abs
    end
end

p minimum_effort [1, 4, 7, 10]
p minimum_effort [4, 3, 1]
p minimum_effort [3, 3, 3]
p minimum_effort [-2000000000, 2000000000]
p minimum_effort [2, 3, 4, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18]