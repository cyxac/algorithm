require 'matrix'

# Graham scan O(nlog(n))
def convex_hull ps
  l_most = ps.min_by do |p| p[0] end
  t = l_most*-1
  ps_t = ps.map do |p|
    p + t
  end
  ps_t.sort_by! do |p|
    p[0] == 0 && p[1]==0 ? -Float::INFINITY : p[1]/p[0].to_f
  end
  s = []
  ps_t.each do |p|
    if s.size < 2
      s << p
      next
    end
    a, b = s[-2], s[-1]
    if ccw(a, b, p) < 0
      s.pop
      redo
    else
      s << p
    end
  end
  s.map do |p| p - t end
end

def ccw a, b, c
  ba = b - a
  ca = c - a
  ba[0]*ca[1]-ba[1]*ca[0]
end

def area_polygon ps
  area = 0
  ps.size.times do |i|
    j = (i+1) % ps.size
    area += (ps[i][0]*ps[j][1] - ps[j][0]*ps[i][1])
  end
  area/2.0
end

if __FILE__ == $0
  p convex_hull [Vector[0.0, 0.0], Vector[10, 0], Vector[0, 10.0]]
  # p area_polygon [Vector[0,0], Vector[1,0], Vector[1,1], Vector[0,1]]
  # p ccw Vector[0,0], Vector[1,1], Vector[0,1]
end