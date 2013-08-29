require_relative "graph"
require_relative "union_find"
require_relative "priority_queue"

MstResult = Struct.new :edges, :cost

# Elog(E)
# Since E < V^2, run time can be stated as Elog(V) as well
def mst_kruskal g, w = g.weight
  res = MstResult.new [], 0
  u_set = UnionFind.new g.vertices
  g.edges.sort_by {|u, v| g.weight[u][v] }.each do |u, v|
    if u_set.find(u) != u_set.find(v)
      res.edges << [u, v]
      res.cost += w[u][v]
      u_set.union u, v
    end
  end
  res
end

# Elog(V)
def mst_prim g, w = g.weight
  res = MstResult.new [], 0
  d = Hash.new Float::INFINITY
  parent = {}
  d[g.vertices[0]] = 0
  q = PriorityQueue.new(g.vertices) do |u, v| d[u] < d[v] ? u : v end
  while not q.empty?
    u = q.pop
    res.cost += d[u]
    res.edges << [parent[u], u] if parent[u]
    (g.adj[u] || []).each do |v|
      if q.include?(v) and w[u][v] < d[v]
        parent[v] = u
        d[v] = w[u][v]
        q.bubble v 
      end
    end
  end
  res
end

def matrix_to_graph m
  g= WeightedGraph.new (0..m.row_size-1)
  m.row_size.times do |i|
    m.column_size.times do |j|
      g.add_edge(i, j, m[i,j]) if m[i,j]!=0
    end
  end
  g
end

if __FILE__ == $0
  # http://poj.org/problem?id=1258
  m = Matrix[[0,4,9,21],[0,0,8,17],[0,0,0,16],[0,0,0,0]]
  g = matrix_to_graph m
  p mst_kruskal g
  
  # CLRS page 625
  g = WeightedGraph.new 1..9
  g.add_edge(1,2, 4)
  g.add_edge(1,8, 8)
  g.add_edge(2,8, 11)
  g.add_edge(2,3, 8)
  g.add_edge(9,8, 7)
  g.add_edge(7,8, 1)
  g.add_edge(9,3, 2)
  g.add_edge(9,7, 6)
  g.add_edge(3,4, 7)
  g.add_edge(3,6, 4)
  g.add_edge(7,6, 2)
  g.add_edge(4,5, 9)
  g.add_edge(4,6, 14)
  g.add_edge(5,6, 10)
  p mst_kruskal(g)
  
  g2 = UndirectedWeightedGraph.new 1..9
  g2.add_edge(1,2, 4)
  g2.add_edge(1,8, 8)
  g2.add_edge(2,8, 11)
  g2.add_edge(2,3, 8)
  g2.add_edge(9,8, 7)
  g2.add_edge(7,8, 1)
  g2.add_edge(9,3, 2)
  g2.add_edge(9,7, 6)
  g2.add_edge(3,4, 7)
  g2.add_edge(3,6, 4)
  g2.add_edge(7,6, 2)
  g2.add_edge(4,5, 9)
  g2.add_edge(4,6, 14)
  g2.add_edge(5,6, 10)
  p mst_prim(g2)

  require 'benchmark'
  # require "profile"
  n = 5000
  Benchmark.bm do |x|
    x.report('kruskal') { n.times {mst_kruskal g2}}
    x.report('prim') {n.times {mst_prim g2}}
  end
  # n.times do
  #   mst_prim g2
  # end
end