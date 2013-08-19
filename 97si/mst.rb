require_relative "graph"
require_relative "union_find"

MstResult = Struct.new :edges, :cost

# Elog(E)
def mst_kruskal g, w = g.weight
  res = MstResult.new [], 0
  u_set = UnionFind.new g.vertices
  g.edges.sort_by {|e| g.weight[e] }.each do |u, v|
    if u_set.find(u) != u_set.find(v)
      res.edges << [u, v]
      res.cost += w[[u, v]]
      u_set.union u, v
    end
  end
  res
end

def matrix_to_graph m
  g= WeightedGraph.new
  m.row_size.times do |i|
    m.column_size.times do |j|
      g.add_edge(i, j, m[i,j]) if m[i,j]!=0
    end
  end
  g
end

if __FILE__ == $0
  m = Matrix[[0,4,9,21],[0,0,8,17],[0,0,0,16],[0,0,0,0]]
  g = matrix_to_graph m
  p mst_kruskal g
end