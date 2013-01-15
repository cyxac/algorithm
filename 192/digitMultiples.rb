def get_longest(single, multiple)
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