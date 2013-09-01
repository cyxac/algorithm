require_relative 'graph'

def min a, b
  a<=b ? a : b
end

# O(V^3)
def floyd_warshall g
  d = g
  1.upto(d.size-1) do |k|
    1.upto(d.size-1) do |i|
      1.upto(d.size-1) do |j|
        d[i][j] =  min(d[i][j], d[i][k]+d[k][j])
      end
    end
  end
  d
end

if __FILE__ == $0
  # CLRS 696
  inf = Float::INFINITY
  d = [[nil]*6,
       [nil, 0, 3, 8, inf, -4],
       [nil, inf, 0, inf, 1, 7],
       [nil, inf, 4,0, inf, inf],
       [nil, 2, inf, -5, 0, inf],
       [nil, inf, inf, inf, 6, 0]]
  p floyd_warshall d
end