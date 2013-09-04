# http://poj.org/problem?id=2540

require 'stringio'

def solve str
  io = StringIO.new str
  same = false
  prev  = [0, 0]
  while line = io.gets
    line = line.split
    x, y, hint = line[0].to_f, line[1].to_f, line[2]
    if same
      puts "0.00"
      next
    end
    same = true if hint == 'Same'
    dx, dy = x - prev[0], y-prev[1]
    a = dx/dy
    b = 1
    c = -a*x/2-y/2
    side = a*x+y+c
    
    if hint == 'Colder'
      if side < 0
        a,b,c = -a, -b, -c
      end
    else
      if side > 0
        a,b,c = -a, -b, -c
      end
    end
    p [a, b, c]
  end
end

input = 
"10.0 10.0 Colder
10.0 0.0 Hotter
0.0 0.0 Colder
10.0 10.0 Hotter"

solve input