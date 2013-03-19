require_relative "../6006/graph"

def determineCost n, roads
    roads = roads.join.split.map do |str|
        str.split(",").map(&:to_i)
    end
    g = Graph.new
    roads.each do |u, v, w|
        g.add_edge_weight_undirected(u, v, w)
    end
    return -1 if g.adj.keys.size != n
    mst_prim(g, 0).total
end

p determineCost 3, ["0,1,1 0,2,1 1,2,2"]
p determineCost 6, ["0,1,2 1,4,2 4,3,3 2,4,4 0,5,3"]
p determineCost 3, ["0,2,2"]
p determineCost 4, ["1,0",",10","0 2,1",",584 3,2",",754"]

# 2
# 14
# -1
# 1438