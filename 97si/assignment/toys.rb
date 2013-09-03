# http://poj.org/problem?id=2318
require 'matrix'
require 'stringio'

class StringIO
  def gets_ints
    self.gets.split.map(&:to_i)
  end
end

def solve str
  io = StringIO.new str
  while (line = io.gets_ints) and line != [0]
    n, m, x1, y1, x2, y2 = *line
    cardboards = []
    n.times do 
      t, b = *io.gets_ints
      cardboards << [Vector[b, y2], Vector[t,y1]] 
    end
    cardboards << [Vector[x2, y2], Vector[x2,y1]]
    counts = [0] * (n+1)
    m.times do
      toy = Vector[*io.gets_ints]
      low, high = 0, cardboards.size-1
      while true
        mid = (low+high)/2
        r = cardboards[mid]
        ccwr = ccw *r, toy
        if mid == low
          if ccwr > 0
            counts[mid] +=1
          else
            counts[mid+1] +=1
          end
          break
        end
        l = cardboards[mid-1]
        ccwl = ccw *l, toy
        if ccwr > 0  and ccwl < 0
          counts[mid] += 1
          break
        elsif ccwr > 0
          high = mid-1
        else
          low = mid+1
        end
      end
    end
    p counts
  end
end

def ccw a, b, c
  ba = b - a
  ca = c - a
  ba[0]*ca[1]-ba[1]*ca[0]
end

input = 
"5 6 0 10 60 0
3 1
4 3
6 8
10 10
15 30
1 5
2 1
2 8
5 5
40 10
7 9
4 10 0 10 100 0
20 20
40 40
60 60
80 80
 5 10
15 10
25 10
35 10
45 10
55 10
65 10
75 10
85 10
95 10
0"

solve input