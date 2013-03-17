require 'set'

class Graph
    attr_accessor :adj, :edges, :weight
    def initialize
        @adj = Hash.new []
        @edges = Set.new
        @weight = {}
    end
    
    def add_edge(u, v)
        if not @adj.has_key? u
            @adj[u] = []
        end
        if not @edges.include? [u, v]
            @adj[u] << v
            @edges << [u, v]
        end
    end
    
    def add_edge_weight(u, v, w)
        add_edge u, v
        @weight[[u, v]] = w
    end
    
    def each_vertex &block
        @adj.each_key &block
    end
end

class BFSResult
    attr_accessor :parent, :level
    def initialize
        @parent = {}
        @level = {}
    end
end

def bfs(g, s, t)
    res = BFSResult.new
    res.level[s] = 0
    res.parent[s] = nil
    queue = [s]
    while not queue.empty?
        v = queue.shift
        g.adj[v].each do |neighbor|
            if not res.level.has_key? neighbor
                queue << neighbor
                res.level[neighbor] = res.level[v]+1
                res.parent[neighbor] = v
                return res if s == t
            end
        end
    end
    return res
end

class MaxFlowResult
    attr_accessor :flow, :value
    def initialize
        @flow = {}
        @value = 0
    end
end

def ford_Fulkerson g, s, t
    res = MaxFlowResult.new
    g.edges.each do |e|
        res.flow[e] = 0
    end
    
    g_residual = g
    
    while true
        bfs_res = bfs g_residual, s, t
        if bfs_res.parent[t].nil?
            return res
        end
        
        path_cap = path_capacity(bfs_res, t, g_residual)
        res.value += path_cap
        augment_flow(res.flow, bfs_res, t, g, path_cap)
        
        g_residual = create_residual_graph(g, res.flow)
    end
end

def path_capacity(bfs_res, t, g)
    where = t
    path_cap = Float::INFINITY
    while bfs_res.parent[where]
        parent = bfs_res.parent[where]
        path_cap = [path_cap, g.weight[[parent, where]]].min
        where = parent
    end
    path_cap
end

def augment_flow(flow, bfs_res, t, g, path_cap)
    where = t
    while bfs_res.parent[where]
        parent = bfs_res.parent[where]
        if g.edges.include? [parent, where]
            flow[[parent, where]] += path_cap
        else
            flow[[where, parent]] -= path_cap
        end
        where = parent
    end
end

def create_residual_graph(g, flow)
    g_residual = Graph.new
    g.edges.each do |u, v|
        uv = g.weight[[u, v]] - flow[[u,v]]
        vu = flow[[u,v]]
        g_residual.add_edge_weight(u, v, uv) if uv != 0
        g_residual.add_edge_weight(v, u, vu) if vu != 0
    end
    g_residual
end

class DFSResult
    attr_accessor :parent, :start_time, :finish_time, :edge_type, :order, :t
    def initialize
        @parent = {}
        @start_time = {}
        @finish_time = {}
        @edge_type = {}
        @order = []
        @t = 0
    end
end

def dfs_visit(v, g, result, parent = nil, predicate = Default_predicate)
    return v if predicate.call(v)
    result.parent[v] = parent
    result.t += 1
    result.start_time[v] = result.t
    result.edge_type[[parent, v]] = "tree" if not parent.nil?
    g.adj[v].each do |neighbor|
        if not result.parent.has_key? neighbor
            dfs_visit(neighbor, g, result, v, predicate)
        elsif not result.finish_time.has_key? neighbor
            result.edge_type[[v, neighbor]] = "back"
        elsif result.start_time[v] < result.start_time[neighbor]
            result.edge_type[[v, neighbor]] = "forward"
        else
            result.edge_type[[v, neighbor]] = "cross"
        end
    end
    result.t += 1
    result.finish_time[v] = result.t
    result.order << v
end

def dfs(g, predicate = Default_predicate)
    result = DFSResult.new
    g.each_vertex do |v|
        if not result.parent.has_key? v
            dfs_visit(v, g, result, nil, predicate)
        end
    end
    result
end

#g = Graph.new
#g.add_edge 1, 2
#g.add_edge 2, 3
#g.add_edge 3, 4
#g.add_edge 4, 2
#g.add_edge 1, 4
#p dfs(g)

#g = Graph.new
#g.add_edge_weight(1, 2, 16)
#g.add_edge_weight(1, 3, 13)
#g.add_edge_weight(3, 2, 4)
#g.add_edge_weight(2, 4, 12)
#g.add_edge_weight(4, 3, 9)
#g.add_edge_weight(3, 5, 14)
#g.add_edge_weight(5, 4, 7)
#g.add_edge_weight(4, 6, 20)
#g.add_edge_weight(5, 6, 4)
#p ford_Fulkerson(g, 1, 6)
#<@flow={[1, 2]=>12, [1, 3]=>11, [3, 2]=>0, [2, 4]=>12, [4, 3]=>0, [3, 5]=>11, [5, 4]=>7, [4, 6]=>19, [5, 6]=>4}, 
# @value=23>