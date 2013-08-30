require_relative 'graph'

# O(V+E)
# needs tweaking for directed graph
def find g
  circuit = []
  connected = Array.new(g.v_range.end+1) {[]}
  g.edges.each {|u, v| connected[u][v] = true}
  find_circuit = ->(v) {
    if g.adj[v].nil? or g.adj[v].empty?
      circuit << v
    else
      while !g.adj[v].nil? or !g.adj[v].empty?
        while u = g.adj[v].shift && !connected[v][u]
        end
        break if u.nil?
        connected[u][v], connected[v][u] = false, false
        find_circuit.(u)
      end
      circuit << v
    end
  }
  find_circuit.(g.v_range.begin)
  circuit.reverse
end

if __FILE__ == $0
  # www.cppblog.com/Files/klion/Eulerian_Tour.doc‎
  g = UndirectedGraph.new 1..7
  g.add_edge 1, 4
  g.add_edge 1, 5
  g.add_edge 2, 4
  g.add_edge 2, 5
  g.add_edge 2, 6
  g.add_edge 2, 7
  g.add_edge 3, 4
  g.add_edge 3, 7
  g.add_edge 4, 6
  g.add_edge 5, 6
  g.add_edge 5, 7
  g.add_edge 6, 7
  p find g
end