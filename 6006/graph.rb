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
        @adj[u] << v
        @edges << [u, v]
    end
    
    def add_edge_weight(u, v, w)
        add_edge u, v
        @weight[[u, v]] = w
    end
    
    def each_vertex &block
        @adj.each_key &block
    end
end

Default_predicate = lambda { |v| false }

class BFSResult
    attr_accessor :parent, :level
    def initialize
        @parent = {}
        @level = {}
    end
end

def bfs(g, s, predicate = default_predicate)
    res = BFSResult.new
    res.level[s] = 0
    res.parent[s] = nil
    queue = [s]
    while not queue.empty?
        v = queue.shift
        g.adj[v].each do |neighbor|
            if not g.level.has_key? neighbor
                queue << neighbor
                res.level[neighbor] = res.level[v]+1
                res.parent[neighbor] = v
                return res if predicate.call(v)
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
    
    while true
        bfs_res = bfs_max_flow g, res.flow, s, t
        if bfs_res.parent[t].nil?
            return res
        end
        
        path_cap = path_capacity(bfs_res, t, res.flow, g)
        res.value += path_cap
        
        v = t
        while bfs_res.parent[v]
            parent = bfs_res.parent[v]
            if g.edges.include? [parent, v]
                res.flow[[parent, v]] += path_cap
            else
                res.flow[[parent,v]] -= path_cap
            end
            v = parent
        end
    end
    res
end

def path_capacity(bfs_res, t, flow, g)
    where = t
    path_cap = Float::INFINITY
    while bfs_res.parent[where]
        parent = bfs_res.parent[where]
        path_cap = [path_cap, residual_cap(parent, where, flow, g)].min
        where = parent
    end
    path_cap
end

def residual_cap(u, v, flow, g)
    if g.edges.include? [u, v]
        return g.weight[[u, v]] - flow[[u,v]]
    elsif g.edges.include? [v, u]
        return res.flow[[v, u]]
    else
        return 0
    end
end

def bfs_max_flow(g, flow, s, t)
    res = BFSResult.new
    res.level[s] = 0
    res.parent[s] = nil
    queue = [s]
    while not queue.empty?
        v = queue.shift
        g.adj[v].each do |neighbor|
            if not res.level.has_key?(neighbor) and residual_cap(v, neighbor, flow, g) > 0
                queue << neighbor
                res.level[neighbor] = res.level[v]+1
                res.parent[neighbor] = v
                return res if v == t
            end
        end
    end
    return res
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
##p g
#p ford_Fulkerson(g, 1, 6)
