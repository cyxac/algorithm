require 'set'

class Graph
    attr_accessor :adj, :vertices, :edges, :weight
    def initialize
        @adj = Hash.new []
        @vertices = Set.new
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
            @vertices << u
            @vertices << v
        end
    end
    
    def add_edge_weight(u, v, w)
        add_edge u, v
        @weight[[u, v]] = w
    end
    
    def add_edge_undirected(u, v)
        add_edge(u, v)
        add_edge(v, u)
    end
    
    def add_edge_weight_undirected(u, v, w)
        add_edge_undirected(u, v)
        @weight[[u,v]] = w
        @weight[[v,u]] = w
    end
    
    def each_vertex &block
        @vertices.each &block
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
    
    def augment_flow(path, t, g, path_cap)
        where = t
        @value += path_cap
        while path.parent[where]
            parent = path.parent[where]
            if g.edges.include? [parent, where]
                @flow[[parent, where]] += path_cap
            else
                @flow[[where, parent]] -= path_cap
            end
            where = parent
        end
    end
end

class MinCostFlowResult < MaxFlowResult
    attr_accessor :total_cost
    def initialize
        super
        @total_cost = 0
    end
    
    def augment_flow(path, t, g, path_cap)
        where = t
        @value += path_cap
        while path.parent[where]
            parent = path.parent[where]
            if g.edges.include? [parent, where]
                @flow[[parent, where]] += path_cap
                @total_cost += path_cap * g.weight[[parent, where]]
            else
                @flow[[where, parent]] -= path_cap
                @total_cost -= path_cap * g.weight[[where, parent]]
            end
            where = parent
        end
    end
end

class MinCostFlowGraph < Graph
    attr_accessor :capacity, :supply
    def initialize
        super
        @capacity = {}
        @supply = Hash.new(0)
    end
    
    def add_edge_cap_cost(u, v, cap, cost)
        add_edge_weight u, v, cost
        @capacity[[u, v]] = cap
    end
    
    def add_supply(node, amount)
        @supply[node] = amount
    end
    
    def add_demand(node, amount)
        add_supply(node, -amount)
    end
end

def min_cost_flow g
    #Successive Shortest Path
    s, t = "source", "sink"
    g.supply.each do |node, supply|
        if supply>0
            g.add_edge_cap_cost(s, node, supply, 0)
        elsif supply<0
            g.add_edge_cap_cost(node, t, -supply, 0)
        end
    end
    res = MinCostFlowResult.new
    g.edges.each do |e|
        res.flow[e] = 0
    end
    
    potential = bellman_ford(g, s).dist
    g_residual = reduce_cost g, potential
    while true
        dijk = dijkstra g_residual, s
        break if dijk.parent[t].nil?
        
        path_cap = path_capacity_2(dijk, t, g_residual)
        res.augment_flow(dijk, t, g, path_cap)
        g_residual = update_residual_graph(g, dijk.dist, res.flow)
    end
    
    g.supply.each do |node, supply|
        if supply>0
            res.flow.delete [s, node]
        elsif supply<0
            res.flow.delete [node, t]
        end
    end
    
    res
end

def path_capacity_2(bfs_res, t, g)
    where = t
    path_cap = Float::INFINITY
    while bfs_res.parent[where]
        parent = bfs_res.parent[where]
        path_cap = [path_cap, g.capacity[[parent, where]]].min
        where = parent
    end
    path_cap
end

def update_residual_graph(g, potential, flow)
    g_new = MinCostFlowGraph.new
    g.edges.each do |u, v|
        if flow[[u,v]]>0
            uv = g.capacity[[u, v]] - flow[[u,v]]
            vu = flow[[u,v]]
            g_new.add_edge_cap_cost(u, v, uv, 0) if uv != 0
            g_new.add_edge_cap_cost(v, u, vu, 0) if vu != 0
        else
            g_new.add_edge_cap_cost(u, v, g.capacity[[u,v]], g.weight[[u,v]] + potential[u] - potential[v])
        end
    end
    g_new
end

def reduce_cost g, potential
    g_residual = MinCostFlowGraph.new
    g.edges.each do |u, v|
        g_residual.add_edge_cap_cost u, v, g.capacity[[u,v]], g.weight[[u,v]] + potential[u] - potential[v]
    end
    g_residual
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
        res.augment_flow(bfs_res, t, g, path_cap)

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

class ShortestPathResult
    attr_accessor :dist, :parent
    def initialize
        @dist = {}
        @parent = {}
    end
end

def dijkstra(graph, source)
    # O(Elog(V)
    res = ShortestPathResult.new
    graph.each_vertex do |v|
        res.dist[v] = Float::INFINITY
        res.parent[v] = nil
    end
    res.dist[source] = 0
    q = PriorityQueue.new
    q.insert([0,source])
    while not q.empty?
        u = q.extract_min[1]
        graph.adj[u].each do |v|
            new_dist = res.dist[u] + graph.weight[[u,v]]
            if new_dist < res.dist[v]
                if res.dist[v] == Float::INFINITY
                    q.insert([new_dist, v])
                else
                    q.decrease_key([res.dist[v], v], [new_dist, v])
                end
                res.dist[v] = new_dist
                res.parent[v] = u
            end
        end
    end
    res
end

def bellman_ford(graph, source)
    # O(VE)
    res = ShortestPathResult.new
    graph.each_vertex do |v|
        res.dist[v] = Float::INFINITY
        res.parent[v] = nil
    end
    res.dist[source] = 0
    
    (graph.vertices.size-1).times do
        graph.edges.each do |u, v|
            if res.dist[v] > res.dist[u] + graph.weight[[u, v]]
                res.dist[v] = res.dist[u] + graph.weight[[u, v]]
                res.parent[v] = u
            end
        end
    end
    
    graph.edges.each do |u, v|
        if res.dist[v] > res.dist[u] + graph.weight[[u, v]]
            return false
        end
    end
    res
end

class MSTResult
    attr_accessor :parent, :total
    def initialize
        @parent = {}
        @total = 0
    end
end

def mst_prim(g, s)
    # O(Elog(V))
    res = MSTResult.new
    dist = {}
    parent = {}
    g.each_vertex do |v|
        dist[v] = Float::INFINITY
        parent[v] = nil
    end
    dist[s] = 0
    q = PriorityQueue.new
    q.insert([0, s])
    while not q.empty?
        u = q.extract_min[1]
        res.parent[u] = parent[u]
        res.total += dist[u]
        g.adj[u].each do |v|
            if not res.parent.has_key?(v) and g.weight[[u,v]] < dist[v]
                if dist[v] == Float::INFINITY
                    q.insert([g.weight[[u,v]], v])
                else
                    q.decrease_key([dist[v], v], [g.weight[[u,v]], v])
                end
                dist[v] = g.weight[[u,v]]
                parent[v] = u
            end
        end
    end
    res
end

class PriorityQueue
    def initialize
        @heap = [nil]
        @key_index = {}
    end
    
    def empty?
        size() == 0
    end
    
    def size
        @heap.size - 1
    end
    
    def insert(key)
        @heap << key
        @key_index[key] = size()
        decrease_key_by_index(size(), key)
    end
    
    def decrease_key(old, new)
        if old[1] != new [1]
            raise "vertex does not match"
        end
        index = @key_index[old]
        if index
            decrease_key_by_index(index, new)
        end
        @key_index.delete old
    end
    
    def decrease_key_by_index(i, key)
        if (key[0] <=> @heap[i][0]) > 0
            raise "new key is larger than current key"
        end
        @heap[i] = key
        while i > 1
            parent = i / 2
            if (@heap[parent][0] <=> key[0]) > 0
                swap i, parent
                i = parent
            else
                break
            end
        end
    end
    
    def swap i, j
        @heap[i], @heap[j] = @heap[j], @heap[i]
        @key_index[@heap[i]], @key_index[@heap[j]] = i, j
    end
    
    def extract_min
        """Removes and returns the minimum key."""
        if size() < 1
            return nil
        end
        swap(1, size())
        min = @heap.pop()
        @key_index.delete min
        min_heapify(1)
        return min
    end
    
    def min_heapify(i)
        l = 2 * i
        r = 2 * i + 1
        smallest = i
        if l <= size() and (@heap[l] <=> @heap[i]) < 0
            smallest = l
        end
        if r <= size() and (@heap[r] <=> @heap[smallest]) < 0
            smallest = r
        end
        if smallest != i
            swap(i, smallest)
            min_heapify(smallest)
        end
    end
    
    def heap
        @heap
    end
end

if __FILE__ == $0
    # g = Graph.new
    # g.add_edge_weight(1, 2, 16)
    # g.add_edge_weight(1, 3, 13)
    # g.add_edge_weight(3, 2, 4)
    # g.add_edge_weight(2, 4, 12)
    # g.add_edge_weight(4, 3, 9)
    # g.add_edge_weight(3, 5, 14)
    # g.add_edge_weight(5, 4, 7)
    # g.add_edge_weight(4, 6, 20)
    # g.add_edge_weight(5, 6, 4)
    # p ford_Fulkerson(g, 1, 6)
    # # <@flow={[1, 2]=>12, [1, 3]=>11, [3, 2]=>0, [2, 4]=>12, [4, 3]=>0, [3, 5]=>11, [5, 4]=>7, [4, 6]=>19, [5, 6]=>4}, 
    # # @value=23>
    
    # g = Graph.new
    # g.add_edge_weight_undirected("a","b", 4)
    # g.add_edge_weight_undirected("a","h", 8)
    # g.add_edge_weight_undirected("b","h", 11)
    # g.add_edge_weight_undirected("b","c", 8)
    # g.add_edge_weight_undirected("i","h", 7)
    # g.add_edge_weight_undirected("g","h", 1)
    # g.add_edge_weight_undirected("i","c", 2)
    # g.add_edge_weight_undirected("i","g", 6)
    # g.add_edge_weight_undirected("c","d", 7)
    # g.add_edge_weight_undirected("c","f", 4)
    # g.add_edge_weight_undirected("g","f", 2)
    # g.add_edge_weight_undirected("d","e", 9)
    # g.add_edge_weight_undirected("d","f", 14)
    # g.add_edge_weight_undirected("e","f", 10)
    # p mst_prim(g, "a")
    
    # g = MinCostFlowGraph.new
    # g.add_edge_cap_cost(1, 2, 7, 1)
    # g.add_edge_cap_cost(1, 3, 7, 5)
    # g.add_edge_cap_cost(2, 3, 2, -2)
    # g.add_edge_cap_cost(2, 4, 3, 8)
    # g.add_edge_cap_cost(3, 4, 3, -3)
    # g.add_edge_cap_cost(3, 5, 2, 4)
    # g.add_supply(1, 5)
    # g.add_demand(4, 3)
    # g.add_demand(5, 2)
    # p min_cost_flow g
    
    #<MinCostFlowResult:@flow={[1, 2]=>2, [1, 3]=>3, [2, 3]=>2, [2, 4]=>0, [3, 4]=>3, [3, 5]=>2}, 
    # @value=5, @total_cost=12>
        
    g = MinCostFlowGraph.new
    g.add_edge_cap_cost(1, 3, 1, 1)
    g.add_edge_cap_cost(1, 4, 1, 2)
    g.add_edge_cap_cost(2, 3, 1, 1)
    g.add_edge_cap_cost(2, 4, 2, 2)
    g.add_supply(1, 2)
    g.add_supply(2, 2)
    g.add_demand(3, 2)
    g.add_demand(4, 2)
    p min_cost_flow g
    
    #<MinCostFlowResult: @flow={[1, 3]=>1, [1, 4]=>1, [2, 3]=>1, [2, 4]=>1}, @value=4, @total_cost=6>
    
    # g = Graph.new
    # g.add_edge_weight("s", "t", 10)
    # g.add_edge_weight("s", "y", 5)
    # g.add_edge_weight("t", "y", 2)
    # g.add_edge_weight("t", "x", 1)
    # g.add_edge_weight("y", "x", 9)
    # g.add_edge_weight("y", "t", 3)
    # g.add_edge_weight("y", "z", 2)
    # g.add_edge_weight("x", "z", 4)
    # g.add_edge_weight("z", "x", 6)
    # g.add_edge_weight("z", "s", 7)
    # p dijkstra g, "s"
end