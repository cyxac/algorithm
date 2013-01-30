def next_integer(allowed, current)
    allowed = allowed.sort
    rank = []
    return "INVALID INPUT" if current[0] == "0" or current[0] == "-"
    current.each_char do |ch|
        i = bsearch(allowed, ch.to_i)
        return "INVALID INPUT" if i.nil?
        rank << i
    end

    (current.size-1).downto(0) do |i|
        if rank[i] != allowed.size - 1
            current[i] = allowed[rank[i]+1].to_s
            return current
        else
            current[i] = allowed[0].to_s
        end
    end
    
    non_zero = allowed.index { |int| int != 0 }
    return allowed[non_zero].to_s + current
end

def bsearch(array, k, l=0, h=array.size-1)
    while l <= h
        middle = (l + h)/2
        return middle if array[middle] == k
        if k < array[middle]
            h = middle-1
        else
            l = middle+1
        end
    end
    return nil
end

p next_integer([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "16")
p next_integer([0, 1, 2, 3, 4, 5, 6, 8, 9], "16")
p next_integer([3, 5, 8], "16")
p next_integer([0, 5, 3, 4], "033")
p next_integer([9, 8, 7, 6, 5, 4, 3, 2, 1, 0], "999")
p next_integer([0, 1, 2, 3, 4, 5], "0")
p next_integer([1], "1")

#"17"
#"18"
#"INVALID INPUT"
#"INVALID INPUT"
#"1000"
#"INVALID INPUT"
#"11"