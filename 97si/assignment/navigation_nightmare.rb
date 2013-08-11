# http://poj.org/problem?id=1984
require 'stringio'
require 'matrix'

class UnionFind
  attr_accessor :xy
  def initialize(nodes=[])
    @parent, @rank, @xy = [], [], []
    nodes.each { |e| insert e } if !nodes.empty?
  end
  
  def insert x
    @parent[x] = x
    @rank[x] = 0
    @xy[x] = Vector[0, 0]
  end

  def find x
    if @parent[x] == x
      x
    else
      previous_parent = @parent[x]
      @parent[x] = find @parent[x]
      @xy[x] += @xy[previous_parent]
      @parent[x]
    end
  end

  def union x, y, v_xy
    px, py = find(x), find(y)
    if @rank[px] < @rank[py]
      @parent[px] = py
      @xy[px] = @xy[y] - v_xy
    else
      @parent[py] = px
      @xy[py] = @xy[x] + v_xy
    end
    @rank[px] += 1 if @rank[px] == @rank[py]
  end
end

def solve inputstr
  dir = {N: Vector[0,1], S: Vector[0, -1], W: Vector[-1, 0], E: Vector[1, 0]}
  @input = StringIO.new inputstr
  n, m = @input.gets.split.map(&:to_i)
  roads = [nil]
  m.times do
    line = @input.gets.split
    0.upto(2) { |i| line[i]=line[i].to_i }
    roads << line
  end
  s = UnionFind.new [*(1..n)]
  last_i = 0
  @input.gets.to_i.times do
    x, y, i = @input.gets.split.map(&:to_i)
    (last_i+1).upto(i) do |index|
      a, b, dist, d = roads[index]
      s.union a, b, dist*dir[d.to_sym]
    end
    last_i = i
    if s.find(x) != s.find(y)
      puts(-1)
    else
      man_dist = s.xy[x] - s.xy[y]
      puts(man_dist[0].abs + man_dist[1].abs)
    end
  end
end

inputstr = 
"7 6
1 6 13 E
6 3 9 E
3 5 7 S
4 1 3 N
2 4 20 W
4 7 2 S
5
1 6 1
1 4 3
2 6 6
6 5 6
7 6 6"

solve inputstr
