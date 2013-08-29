require 'matrix'
require 'set'

# O(V^2) storage, use only for dense graph, and V is less than a few thousands
# A^k is the length-k walk counting matrix for the graph
# A^k[u][v] = the number of length-k walks from u to v
def adj_matrix n
  Matrix.zero n
end

# Adjacency List with vector
class Graph
  attr_accessor :adj, :vertices, :edges, :v_range
  def initialize v_range
    @adj, @v_range, @edges = [], v_range, []
  end
  
  def add_edge u, v
    @adj[u] ||= []
    @adj[u] << v
    @edges << [u, v]
  end
  
  def vertices
    return @vertices if @vertices.is_a? Array
    @vertices = @v_range.to_a
  end
end

class WeightedGraph < Graph
  attr_accessor :weight
  def initialize v_range
    super v_range
    @weight = Array.new(v_range.end+1) { [] }
  end
  
  def add_edge u, v, w
    super u, v
    @weight[u][v] = w
  end
end

class UndirectedGraph < Graph
  def add_edge u, v
    super u, v
    super v, u
  end
end

class UndirectedWeightedGraph < WeightedGraph
  def add_edge u, v, w
    super u, v, w
    super v, u, w
  end
end

# Adjacency list with array, no speedup in Ruby
class Graph2
  # attr_accessor :edges, :last_edge
  # Edge = Struct.new(:to, :nextID)
  def initialize v_size, e_size
    @edges = Array.new e_size+1
    @last_edge = [-1]*(v_size+1)
    @id = 0
  end

  def add_edge u, v
    @edges[@id+=1] = [v, @last_edge[u]]
    @last_edge[u] = @id
  end

  def adj u
    id = @last_edge[u]
    while id != -1
      yield @edges[id][0]
      id = @edges[id][1]
    end
  end
end

if __FILE__ == $0
  require "benchmark"

  n = 500000

  Benchmark.bm do |x|
    x.report("1 add edges") do
      n.times do
        g = Graph.new 5
        g.add_edge 1,2
        g.add_edge 2,3
        g.add_edge 1,3
        g.add_edge 1,5
        g.add_edge 4,3
        g.add_edge 3,2
        g.add_edge 4,2
        g.add_edge 2,5
      end
    end
    x.report("2 add edges") do
      n.times do
        g = Graph2.new 5, 8
        g.add_edge 1,2
        g.add_edge 2,3
        g.add_edge 1,3
        g.add_edge 1,5
        g.add_edge 4,3
        g.add_edge 3,2
        g.add_edge 4,2
        g.add_edge 2,5
      end
    end
  end
  g = Graph.new 5
  g.add_edge 1,2
  g.add_edge 2,3
  g.add_edge 1,3
  g.add_edge 1,5
  g.add_edge 4,3
  g.add_edge 3,2
  g.add_edge 4,2
  g.add_edge 2,5
  g2 = Graph2.new 5, 8
  g2.add_edge 1,2
  g2.add_edge 2,3
  g2.add_edge 1,3
  g2.add_edge 1,5
  g2.add_edge 4,3
  g2.add_edge 3,2
  g2.add_edge 4,2
  g2.add_edge 2,5

  Benchmark.bm do |x|
    x.report("1 iterate") do
      n.times do |i|
        g.adj[i%5+1].each { |e| 1 } if !g.adj[i%5+1].nil?
      end
    end
    x.report("2 iterate") do
      n.times do |i|
        g2.adj(i%5+1) { |e| 1 }
      end
    end
  end
end