require 'stringio'
require 'matrix'

def solve input
  input = StringIO.new input
  points = []
  while line = input.gets do
    points << Vector[*line.split().map(&:to_f)]
  end
  max = 0
  0.upto(points.size-1) do |i|
    (i+1).upto(points.size-1) do |j|
      p1, p2 = points[i], points[j]
      mid = (p1+p2)/2.0
      half_dist = (p1-p2).norm/2
      next if half_dist > 2.5
      mid_to_center = (2.5**2 - half_dist**2)**0.5
      p1_p2 = p1-p2
      normal_vector = Vector[p1_p2[1], -p1_p2[0]].normalize * mid_to_center
      center1 = mid + normal_vector
      center2 = mid - normal_vector
      c1, c2 = 0, 0
      points.each do |point|
        c1 += 1 if (point-center1).norm <= 2.5
        c2 += 1 if (point-center2).norm <= 2.5
      end
      max = [c1, c2].max if c1 > max || c2 > max
    end
  end
  max
end

input = 
"4.0 4.0
4.0 5.0
5.0 6.0
1.0 20.0
1.0 21.0
1.0 22.0
1.0 25.0
1.0 26.0"

p solve input