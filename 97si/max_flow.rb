require_relative 'graph'

# O(VE^2) Edmonds-Karp
# Works on directed graph
def max_flow g, s, t
  res = MaxFlowResult.new g.v_range
  weighted_graph_dup = ->(inp){
    out = WeightedGraph.new inp.v_range
    out.weight = Array.new(inp.v_range.end+1) { Array.new(inp.v_range.end+1) {0} }
    inp.edges.each do |u, v| out.add_edge u, v, inp.weight[u][v] end
    out
  }
  g_residual = weighted_graph_dup.(g)
  bfs = ->(g, s, t){
    parent = {}
    q = [s]
    while not q.empty?
      v = q.shift
      g.adj[v].each do |neighbor|
        if not parent.has_key?(neighbor) and g.weight[v][neighbor] > 0
          q << neighbor
          parent[neighbor] = v
          return parent if neighbor == t
        end
      end
    end
    parent
  }
  while flow_path = bfs.(g_residual, s, t) and !flow_path[t].nil?
    res.augment_flow flow_path, t, g_residual
  end
  res.flow = g.edges.map do |u, v| [u, v, res.flow[u][v]-res.flow[v][u]] end
  res
end

class MaxFlowResult
  attr_accessor :flow, :value
  def initialize v_range
    @flow = Array.new(v_range.end+1) { [0]*(v_range.end+1) }
    @value = 0
  end
    
  def augment_flow(flow_path, t, g_residual)
    flow_value = Float::INFINITY
    u = t
    while parent = flow_path[u]
      edge_cap = g_residual.weight[parent][u]
      flow_value = edge_cap < flow_value ? edge_cap : flow_value
      u = parent
    end
    @value += flow_value
    where = t
    while parent = flow_path[where]
      @flow[parent][where] += flow_value
      g_residual.weight[parent][where] -= flow_value
      g_residual.weight[where][parent] += flow_value
      where = parent
    end
  end
end

if __FILE__ == $0
  # CLRS page 726
  g = WeightedGraph.new 0..5
  g.weight = Array.new(6) { Array.new(6) {0} }
  g.add_edge(0, 1, 16)
  g.add_edge(0, 2, 13)
  g.add_edge(2, 1, 4)
  g.add_edge(1, 3, 12)
  g.add_edge(3, 2, 9)
  g.add_edge(2, 4, 14)
  g.add_edge(4, 3, 7)
  g.add_edge(3, 5, 20)
  g.add_edge(4, 5, 4)
  p max_flow(g, 0, 5)
end