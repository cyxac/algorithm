# O(alpha(n)) amortized, where alpha(n) <= 4 for practical purposes
# Union by rank, path compression alone gives O(log(n)) amortized
class UnionFind
  def initialize nodes=[]
    @parent, @rank = [], []
    if !nodes.empty?
      nodes.each { |e| insert e }
    end
  end

  def insert x
    @parent[x] = x
    @rank[x] = 0
  end
  alias :<< :insert

  def find x
    @parent[x] == x ? x : find(@parent[x])
  end

  def union x, y
    px = find x
    py = find y
    if @rank[px] <= @rank[py]
      @parent[px] = py
    else
      @parent[py] = px
    end
    @rank[py] += 1 if @rank[px] == @rank[py]
  end
end

if __FILE__ == $0
  set = UnionFind.new [*(1..4)]
  p set.find 1
  p set.find 2
  set.union 1, 2 
  p set.find 1
  p set.find 2
  set.union 4, 3
  set.union 1, 4
  p set.find 1
  p set.find 2
  p set.find 3
  p set.find 4
  set << 5
  p set.find 5
end