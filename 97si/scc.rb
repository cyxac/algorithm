require_relative "graph"

def scc g
  c = 0
  lable = []
  visited = []
  group = []
  dfs = ->(v){ 
    visited[v] = true
    g.adj[v].each { |e| dfs.(e) if not visited[e] }
    lable[c+=1] = v
  }
  g.vertices.each do |v|
    dfs.(v) if not visited[v]
  end
  p lable
  visited = []
  group_cnt = -1
  gr = Graph.new g.v_range
  g.edges.each { |u, v| gr.add_edge v, u }
  dfs_backward = ->(v){ 
    visited[v] = true
    group[group_cnt] = [] if not group[group_cnt]
    group[group_cnt] << v
    gr.adj[v].each { |e| dfs_backward.(e) if not visited[e] }
  }
  c.downto(1) { |i| 
    if not visited[lable[i]]
      group_cnt+=1; 
      dfs_backward.(lable[i]) 
    end
  }
  group
end

if __FILE__ == $0
  # http://theory.stanford.edu/~tim/
  # Part 1, section 10 notes
  g = Graph.new 1..9
  g.add_edge 1, 7
  g. add_edge 4, 1
  g.add_edge 7, 4
  g.add_edge 7, 9
  g.add_edge 9, 6
  g.add_edge 3, 9
  g.add_edge 6, 3
  g.add_edge 6, 8
  g.add_edge 8, 2
  g.add_edge 2, 5
  g.add_edge 5, 8
  p scc(g)
end