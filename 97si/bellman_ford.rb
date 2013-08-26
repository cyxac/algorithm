# http://hi.baidu.com/z917912363/item/32e8cd5ba15b2fc2d2e10c76

require_relative "graph"

SingleSourceSPResult = Struct.new :dist, :parent

# O(VE)
def bellman_ford g, s
  res = SingleSourceSPResult.new [], []
  g.vertices.each do |v|
    res.dist[v] = Float::INFINITY
    res.parent[v] = nil
  end
  res.dist[s] = 0
  
  (g.vertices.size-1).times do
    g.edges.each do |u,v|
      if res.dist[v] > res.dist[u] + g.weight[u][v]
        res.dist[v] = res.dist[u] + g.weight[u][v]
        res.parent[v] = u
      end
    end
  end

  g.edges.each do |u, v|
    if res.dist[v] > res.dist[u] + g.weight[u][v]
      return false
    end
  end
  res
end

if __FILE__ == $0
  # CLRS page 652
  g = WeightedGraph.new 1..5
  g.add_edge 1, 2, 6
  g.add_edge 1, 4, 7
  g.add_edge 2, 3, 5
  g.add_edge 2, 4, 8
  g.add_edge 2, 5, -4
  g.add_edge 3, 2, -2
  g.add_edge 4, 3, -3
  g.add_edge 4, 5, 9
  g.add_edge 5, 1, 2
  g.add_edge 5, 3, 7
  p bellman_ford g, 1

  # http://poj.org/problem?id=3169
  g2 = WeightedGraph.new 1..4
  g2.add_edge 1,3,10
  g2.add_edge 2,4,20
  g2.add_edge 3,2,-3
  p g2.vertices
  p bellman_ford g2, 1
end