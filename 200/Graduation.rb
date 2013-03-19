require_relative "../6006/graph"

def more_classes(classesTaken, requirements)
    g = Graph.new
    sink = 1
    set_a = []
    total_req = 0
    requirements.each do |req_str|
        num, req = req_str.split(/(?<=\d)(?:\B|\b)(?=\D)/)
        g.add_edge_weight(req, sink, num.to_i)
        total_req += num.to_i
        req.each_char do |c|
            g.add_edge_weight(c, req, 1)
            set_a << c
        end
    end
    
    res = MaxFlowResult.new
    g.edges.each do |e|
        res.flow[e] = 0
    end
    g_residual = g
    
    # Run max flow on bipartite graph without super node.
    # First run on classesTaken nodes, then run on the rest in
    # alphabet order.
    classesTaken.each_char do |c|
        bfs_res = bfs g_residual, c, sink
        next if bfs_res.parent[sink].nil?
        
        path_cap = path_capacity(bfs_res, sink, g_residual)
        res.value += path_cap
        augment_flow(res.flow, bfs_res, sink, g, path_cap)
        
        g_residual = create_residual_graph(g, res.flow)
    end
    return "" if res.value == total_req
    
    output = ""
    set_a.uniq.sort.each do |c|
        bfs_res = bfs g_residual, c, sink
        next if bfs_res.parent[sink].nil?
        
        output << c
        path_cap = path_capacity(bfs_res, sink, g_residual)
        res.value += path_cap
        augment_flow(res.flow, bfs_res, sink, g, path_cap)
        
        g_residual = create_residual_graph(g, res.flow)
    end
    
    return output if res.value == total_req
    return "0" if res.value != total_req
end

p more_classes("A", ["2ABC","2CDE"])
p more_classes("+/NAMT", ["3NAMT","2+/","1M"])
p more_classes("A", ["100%*Klju"])
p more_classes("", ["5ABCDE","1BCDE,"])
p more_classes("CDH", ["2AP", "3CDEF", "1CDEFH"])

#"BCD"
#""
#"0"
#",ABCDE"
#"AEP"