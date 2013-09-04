require_relative 'bellman_ford'

INF = Float::INFINITY

class MinCostFlowResult
  attr_accessor :flow, :value, :cost
  def initialize v_range
    @flow = Array.new(v_range.end+1) { [0]*(v_range.end+1) }
    @value, @cost = 0, 0
  end
  
  
end

def min a, b
  a <= b ? a : b
end

# O(VEBlog(V)), B is the largest supply of any node
# Successive shortest path
class MinCostMaxFlow
  def initialize(n)
    @n = n
    @cap = array(0, n, n)
    @cost = array(0, n, n)
    @flow = array 0, n, n
    @pi = array 0, n
    @dad = []
  end
  
  def add_edge u, v, cap, cost
    @cap[u][v] = cap
    @cost[u][v] = cost
  end
  
  def relax u, v, cap, cost, dir
    val = @dist[u] + @pi[u] - @pi[v] + cost
    if cap > 0 and val < @dist[v]
      @dist[v] = val
      @dad[v] = [u, dir]
      @width[v] = min cap, @width[u]
    end
  end

  def dijkstra s, t
    found = []
    @dist = array INF, @n
    @width = array 0, @n
    @dist[s] = 0
    @width[s] = INF

    while s != -1
      best = -1
      found[s] = true
      @n.times do |k|
        next if found[k]
        relax s, k, @cap[s][k] - @flow[s][k], @cost[s][k], 1
        relax s, k, @flow[k][s], -@cost[k][s], -1
        if best == -1 || @dist[k] < @dist[best]
          best = k
        end
      end
      s = best
    end

    @n.times do |k|
      @pi[k] = @pi[k] + @dist[k]
    end
    @width[t]
  end

  def get_max_flow s, t
    totflow, totcost = 0, 0
    while (amt = dijkstra(s, t)) > 0
      totflow += amt
      x = t
      while x != s
        if @dad[x][1] == 1
          @flow[@dad[x][0]][x] += amt
          totcost += amt * @cost[@dad[x][0]][x]
        else
          flow[dad[x][9]][x] -= amt
          totcost -= amt * cost[dad[x][0]][x]
        end
        x = @dad[x][0]
      end
    end
    [totflow, totcost]
  end
end

def array v, *i
  if i.size == 1
    Array.new(i[0]) { v }
  elsif i.size == 2
    Array.new(i[0]) { Array.new(i[1]) { v } }
  end  
end

if __FILE__ == $0
  g = MinCostMaxFlow.new 7
  g.add_edge 0, 1, 5, 0
  g.add_edge 1, 2, 7, 1
  g.add_edge 1, 3, 7, 5
  g.add_edge 2, 4, 3, 8
  g.add_edge 2, 3, 2, -2
  g.add_edge 3, 4, 3, -3
  g.add_edge 3, 5, 2, 4
  g.add_edge 4, 6, 3, 0
  g.add_edge 5, 6, 2, 0
  p g.get_max_flow 0, 6
end