# http://poj.org/problem?id=2540

require 'stringio'
require 'matrix'
require 'set'
require_relative '../convex_hull'

def solve str
  io = StringIO.new str
  zero = false
  prev  = [0, 0]
  planes = [[-1, 0, 0], [0, -1, 0], [0, 1, -10], [1, 0, -10]]
  while line = io.gets
    if zero
      puts "0.00"
      next
    end
    line = line.split
    x, y, hint = line[0].to_f, line[1].to_f, line[2]
    if hint == 'Same'
      zero = true
      next     
    end
    dx, dy = x - prev[0], y-prev[1]
    mid_x = prev[0] + dx/2
    mid_y = prev[1] + dy/2
    if dy == 0
      b = 0
      a = 1.0
      c = -mid_x
    else
      a = dx/dy
      b = 1.0
      c = -a*mid_x-mid_y
    end
    
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
    planes << [a, b, c]
    prev = x, y

    points = Set.new
    planes.combination(2) do |e1, e2|
      p = get_intersection(e1, e2)
      next if p.nil?
      p = p.map(&:to_f)
      if planes.all? { |_a, _b, _c| _a*p[0] + _b*p[1] + _c <= 0 }
        points << p
      end
    end
    ch = convex_hull points
    p area_polygon ch
    # find convex hull of the points and calculate area
  end
end

def get_intersection l1, l2
  a = Matrix[[l1[0],l1[1]], [l2[0], l2[1]]]
  return nil if a.det == 0
  b = Vector[-l1[2], -l2[2]]
  a.inverse * b
end

input = 
"10.0 10.0 Colder
10.0 0.0 Hotter
0.0 0.0 Colder
10.0 10.0 Hotter"

solve input