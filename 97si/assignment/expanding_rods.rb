# http://poj.org/problem?id=1905

require 'stringio'
include Math

class StringIO
  def gets_ints
    self.gets.split.map(&:to_f)
  end
end

def solve str
  inputio = StringIO.new str
  while line = inputio.gets_ints and line[0] > 0
    l, n, c = *line
    l_ = (1+n*c)*l
    # p l_
    
    low, high = 0, PI/2
    while true
      mid = (low+high)/2
      r = l/(2*sin(mid))
      est = 2*mid*r
      # p est
      if (est-l_).abs <= 0.0000001
        puts '%.3f' % (r-r*cos(mid))
        break
      elsif est > l_
        high = mid
      else
        low = mid
      end
    end
  end
end

input = 
"1000 100 0.0001
15000 10 0.00006
10 0 0.001
-1 -1 -1"

solve input