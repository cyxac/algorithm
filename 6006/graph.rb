Default_predicate = Proc.new { |v| false }

def bfs_visit(s, adj, seen, predicate = default_predicate)
    queue = [s]
    while not queue.empty?
        v = queue.shift
        return v if predicate.call(v)
        adj[v].each do |neighbor|
            if not seen.has_key? neighbor
                queue << neighbor
                seen[neighbor] = nil
            end
        end
    end
    return seen
end

def bfs(adj, predicate = default_predicate)
    seen = {}
    adj.each_key do |v|
        if not seen.has_key? v
            seen[v] = nil
            bfs_visit(v, adj, seen, predicate)
        end
    end
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

def dfs_visit(v, adj, result, parent = nil, predicate = Default_predicate)
    return v if predicate.call(v)
    result.parent[v] = parent
    result.t += 1
    result.start_time[v] = result.t
    result.edge_type[[parent, v]] = "tree"
    adj[v].each do |neighbor|
        if not result.parent.has_key? neighbor
            dfs_visit(neighbor, adj, result, v, predicate)
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

def dfs(adj, predicate = Default_predicate)
    result = DFSResult.new
    adj.each_key do |v|
        if not result.parent.has_key? v
            dfs_visit(v, adj, result, nil, predicate)
        end
    end
    result
end

g = {1 =>[2,4], 2=>[3], 3=> [4], 4=> [2]}
p dfs(g)