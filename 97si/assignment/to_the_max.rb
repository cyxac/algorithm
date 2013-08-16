require 'stringio'

def max_sub_array a
    max_sub = []
    max = -Float::INFINITY
    t_max_sub = []
    t_sum = -Float::INFINITY
    
    a.each_with_index do |e, i|
        if t_sum <= 0
            t_sum = e
            t_max_sub = [i, i]
        else
            t_sum += e
            t_max_sub[1] = i
        end
        
        if max < t_sum
            max_sub = t_max_sub.dup
            max = t_sum
        end
    end
    [max, a[max_sub[0]..max_sub[1]]]
end

def solve inputstr
  @input = StringIO.new inputstr
  n = @input.gets.to_i
  a = @input.read.split.map(&:to_i)
  max = a[0][0]
  a = Array.new(n) { |i| Array.new(n) { |j| a[i*n+j] } }
  a.each_index { |i| 
    t_max = max_sub_array(a[i])[0]
    max = t_max if t_max > max
    (i+1).upto n-1 do |j|
      a[i] = a[i].zip(a[j]).map { |pair| pair[0]+pair[1] }
      t_max = max_sub_array(a[i])[0]
      max = t_max if t_max > max
    end
  }
  max
end

str = 
"4
0 -2 -7 0 9 2 -6 2
-4 1 -4 1 -1

8 0 -2"

p solve str
