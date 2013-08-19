require_relative "graph"
require_relative "union_find"

MstResult = Struct.new :edges, :cost

# Elog(E)
def mst_kruskal g, w
  res = MstResult.new [], 0
  u_set = union_find.new g.vertices
  g.edges.sort do |e1, e2|
    w[e2] <=> w[e1]
  end.each do |u, v|
    if u_set.find(u) != u_set.find(v)
      res.edges << [u, v]
      res.cost += w[[u, v]]
    end
  end
end