# http://poj.org/problem?id=1330
require 'stringio'
include Math

def solve input
  @input = StringIO.new input
  num_cases = @input.gets.to_i
  num_cases.times do
    num_nodes = @input.gets.to_i
    anc, depth = ancestors num_nodes
    x,y = @input.gets.split.map(&:to_i)
    p query x, y, anc, depth
  end
end

def query x, y, anc, depth
  same_depth = ->(x, y) {
    if depth[x] < depth[y]
      k = log2(depth[y]-depth[x]).floor
      return same_depth.(x, anc[y][k])
    elsif depth[x] > depth[y]
      k = log2(depth[x]-depth[y]).floor
      return same_depth.(anc[x][k], y)
    else
      return [x, y]
    end 
  }
  x, y = same_depth.(x, y)
  k = log2(depth.size-1).ceil
  p anc[x], anc[y]
  loop do
    # return anc[x][0] if k < 0
    if anc[x][k].nil? || anc[x][k] == anc[y][k]
      k -=1
    else
      x = anc[x][k] 
      y = anc[y][k]
      return anc[x][0] if k == 0
    end
  end
end

def ancestors num_nodes
  anc = Array.new(num_nodes+1) { [] }
  children = Hash.new{|h, k| h[k] = []}
  (num_nodes-1).times do
    parent, child = @input.gets.split.map(&:to_i)
    anc[child] = []
    anc[child][0] = parent
    children[parent] << child
  end
  root = 1.upto(num_nodes).find {|i| anc[i].empty? }
  depth = get_depth root, children
  1.upto(log2 num_nodes-1) do |k|
    1.upto num_nodes do |i|
      next if k > log2(depth[i])
      anc[i][k] = anc[anc[i][k-1]][k-1]
    end
  end
  [anc, depth]
end

def get_depth root, tree
  depth = []
  depth[root] = 0
  visit = ->(node) {
    tree[node].each do |child|
      depth[child] = depth[node] + 1
      visit.(child)
    end
  }
  visit.(root)
  return depth
end

input = 
"2
16
1 14
8 5
10 16
5 9
4 6
8 4
4 10
1 13
6 15
10 11
6 7
10 2
16 3
8 1
16 12
16 7
5
2 3
3 4
3 1
1 5
3 5"

solve input