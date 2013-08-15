# O(log(MaxVal)) for both set and sum
class BIT
  def initialize n
    @maxVal = n
    @tree = [0]*(n+1)
  end
  
  def set i, v
    while i <= @maxVal
      @tree[i] += v
      i += (i & -i)
    end
  end
  
  def sum i
    sum = 0
    while i > 0
      sum += @tree[i]
      i -= (i & -i)
    end
    sum
  end
end

if __FILE__ == $0
  f = [1,0,2,1,1,3,0,4,2,5,2,2,3,1,0,2]
  t = BIT.new 16
  f.each_with_index {|v,i| t.set i+1, v}
  1.upto 16 do |i| print "#{t.sum i}, " end
end