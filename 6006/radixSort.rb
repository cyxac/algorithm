def counting_sort(input, k)
    c = [0]*k
    input.each do |e|
        c[e] += 1
    end
    1.upto(c.size-1) do |i|
        c[i] += c[i-1]
    end
    output = [nil]*input.size
    input.reverse_each do |e|
        output[c[e]-1] = e
        c[e] -= 1
    end
    return output
end

def radix_sort(a, d)
#    for i in 1 to d
#        use a stable sort to sort array A on digit i
end

p counting_sort [5,1,4,2,3],6