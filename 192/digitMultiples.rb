# running time depends on var longest, if longest = 1 all the time,
# this is O(n^2). But if longest = n/2 half the time, this becomes O(n^3)
def get_longest_1(single, multiple)
    longest = 0
    sofar = 0
    0.upto(single.size - 1) do |i|
        length = sofar + 1
        found = 0.upto(multiple.size - 1).any? do |i_mul|
            multiple?(single[i-sofar..i], multiple[i_mul, length])
        end
        if found
            sofar += 1
        end
        if sofar > longest
            longest = sofar
        end
    end
    return longest
end

# O(n^2)
def get_longest(single, multiple)
    max = 0
    (-single.size).upto(multiple.size - 1) do |offset|
        0.upto(9) do |k|
            count = 0
            (0...single.size).each do |i|
                if (i+offset) >= 0 and (i+offset) < multiple.size
                    if single[i].to_i * k == multiple[i+offset].to_i
                        count += 1
                        max = count if count > max
                    else
                        count = 0
                    end
                end
            end
        end
    end
    return max
end

def multiple?(single, multiple)
    return false if single.size != multiple.size
    k = nil
    0.upto(single.size - 1) do |i|
        s, m = single[i].to_i, multiple[i].to_i
        next if s==0 and m==0
        return false if s == 0
        if k.nil?
            k = m/s.to_f
            return false if !(0..9).include?(k)
            next
        end
        if m == s * k
            next
        else
            return false
        end
    end
    return true
end

p get_longest("3211113321571", "5555266420") # 5
p get_longest("100200300", "100400600") # 8
p get_longest("111111111100000000000000000000000000000000000",
            "122333444455555666666777777788888888999999999") # 9
p get_longest("000000000000", "000000000000") # 12
p get_longest("11111111111", "11111111111") # 11
p get_longest("89248987092734709478099", "00000000000000000000000") # 23
p get_longest("11111111111111111111111111111111111111111111111111", 
            "00000000000000000000000001111111111111111111111111") # 25