require 'set'

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end
  
  def eql? other
    return self.== other
  end
  
  def hash
    [@x,@y].hash
  end

  def == other
    return @x == other.x && @y == other.y
  end
end

class Line
  attr_accessor :head, :tail
  
  def initialize(head, tail)
    @head, @tail = head, tail
  end

  def to_s
    "#@head->#@tail"
  end

  def horizontal?
    @head.y == @tail.y
  end

  def merge! other
    return false if horizontal? != other.horizontal?
    if horizontal? && @head.y == other.head.y
      if ([@head.x, @tail.x].min <= [other.head.x, other.tail.x].max &&
          [@head.x, @tail.x].max >= [other.head.x, other.tail.x].min)
          all_x = [@head, @tail, other.head, other.tail].map { |e| e.x  }
          @head.x = all_x.min
          @tail.x = all_x.max
          return self
      end
    elsif !horizontal? && @head.x == other.head.x
      if ([@head.y, @tail.y].min <= [other.head.y, other.tail.y].max &&
          [@head.y, @tail.y].max >= [other.head.y, other.tail.y].min)
          all_y = [@head, @tail, other.head, other.tail].map { |e| e.y  }
          @head.y = all_y.min
          @tail.y = all_y.max
          return self
      end
    end

    return false
  end

  def intersect other
    return false if horizontal? == other.horizontal?
    if horizontal?
      if (other.head.y..other.tail.y).cover?(@head.y) && (@head.x..@tail.x).cover?(other.head.x)
        return Point.new other.head.x, @head.y
      end
    else
      if (other.head.x..other.tail.x).cover?(@head.x) && (@head.y..@tail.y).cover?(other.head.y)
        return Point.new @head.x, other.head.y
      end
    end
    return false
  end

  def cover? point
    if horizontal?
      return point.y == @head.y && (@head.x..@tail.x).cover?(point.x)
    else
      return point.x == @head.x && (@head.y..@tail.y).cover?(point.y)
    end
  end
end

def merge_overlap!(lines)
  (lines.size - 1).downto(0) do |i|
    lines[0...i].each do |line2|
        if line2.merge! lines[i]
            lines.delete_at i
            break
        end
    end
  end
end

def split_intersect! lines
  intersections = []
  lines.each_with_index do |l1, i|
    lines[i+1..-1].each_with_index do |l2, j|
      if intersect = l1.intersect(l2)
        intersections << intersect
      end
    end
  end

  intersections.each do |intersection|
    lines.each_with_index do |l, i|
      if l.head != intersection && l.tail != intersection && l.cover?(intersection)
        tail = l.tail
        l.tail = intersection
        new_line = Line.new(intersection, tail)
        lines << new_line
      end
    end
  end
end

def build_adj edges
    adj = {}
    edges.each do |e|
        adj[e.head] ||= []
        adj[e.head] << e.tail
        
        adj[e.tail] ||= []
        adj[e.tail] << e.head
    end
    return adj
end

def split_into_connected_graphs_bfs adj
    graphs = []
    seen = Set.new
    adj.each_key do |v|
        if not seen.include? v
            queue = [v]
            connected_graph = Set.new [v]
            while !queue.empty?
              vertice = queue.shift
              adj[vertice].each do |point|
                if !connected_graph.include?(point) # not recorded yet
                    seen << point
                    queue << point
                    connected_graph << point
                end
              end
            end
            graphs << connected_graph
        end
    end
    graphs
end

def split_into_connected_graphs_dfs adj
    graphs = []
    seen = Set.new
    adj.each_key do |v|
        if not seen.include? v
            seen << v
            connected_graph = Set.new [v]
            graphs << dfs_visit(v, adj, seen, connected_graph)
        end
    end
    graphs
end

def dfs_visit(s, adj, seen, connected_graph)
    adj[s].each do |neighbor|
        if not seen.include? neighbor
            seen << neighbor
            connected_graph << neighbor
            dfs_visit(neighbor, adj, seen, connected_graph)
        end
    end
    return connected_graph
end

def num_times segments, n
  segments = segments.map { |e| e.split(" ").map(&:to_i) }
  lines = segments.map do |x1, y1, x2, y2|
    head = Point.new x1, y1
    tail = Point.new x2, y2
    Line.new head, tail
  end

  merge_overlap! lines

  split_intersect! lines

  adj = build_adj lines

  connected_graphs = split_into_connected_graphs_dfs adj

  if n % 2 == 0
    return connected_graphs.size - 1
  end

  pen_lift = 0
  connected_graphs.each do |graph|
    odd_vertices = graph.count {|v| adj[v].size % 2 == 1}
    pen_lift += odd_vertices > 0 ? odd_vertices/2 : 1
  end

  return pen_lift - 1
end

p num_times(["-252927 -1000000 -252927 549481","628981 580961 -971965 580961",
"159038 -171934 159038 -420875","159038 923907 159038 418077",
"1000000 1000000 -909294 1000000","1000000 -420875 1000000 66849",
"1000000 -171934 628981 -171934","411096 66849 411096 -420875",
"-1000000 -420875 -396104 -420875","1000000 1000000 159038 1000000",
"411096 66849 411096 521448","-971965 580961 -909294 580961",
"159038 66849 159038 -1000000","-971965 1000000 725240 1000000",
"-396104 -420875 -396104 -171934","-909294 521448 628981 521448",
"-909294 1000000 -909294 -1000000","628981 1000000 -909294 1000000",
"628981 418077 -396104 418077","-971965 -420875 159038 -420875",
"1000000 -1000000 -396104 -1000000","-971965 66849 159038 66849",
"-909294 418077 1000000 418077","-909294 418077 411096 418077",
"725240 521448 725240 418077","-252927 -1000000 -1000000 -1000000",
"411096 549481 -1000000 549481","628981 -171934 628981 923907",
"-1000000 66849 -1000000 521448","-396104 66849 -396104 1000000",
"628981 -1000000 628981 521448","-971965 521448 -396104 521448",
"-1000000 418077 1000000 418077","-1000000 521448 -252927 521448",
"725240 -420875 725240 -1000000","-1000000 549481 -1000000 -420875",
"159038 521448 -396104 521448","-1000000 521448 -252927 521448",
"628981 580961 628981 549481","628981 -1000000 628981 521448",
"1000000 66849 1000000 -171934","-396104 66849 159038 66849",
"1000000 66849 -396104 66849","628981 1000000 628981 521448",
"-252927 923907 -252927 580961","1000000 549481 -971965 549481",
"-909294 66849 628981 66849","-252927 418077 628981 418077",
"159038 -171934 -909294 -171934","-252927 549481 159038 549481"], 824759) # => 19
p num_times(["-10 0 10 0","0 -10 0 10"], 1) # => 1
p num_times(["-10 0 0 0","0 0 10 0","0 -10 0 0","0 0 0 10"], 1) # => 1
p num_times(["-10 0 0 0","0 0 10 0","0 -10 0 0","0 0 0 10"], 4) # => 0
p num_times(
    ["0 0 1 0",   "2 0 4 0",   "5 0 8 0",   "9 0 13 0",
     "0 1 1 1",   "2 1 4 1",   "5 1 8 1",   "9 1 13 1",
     "0 0 0 1",   "1 0 1 1",   "2 0 2 1",   "3 0 3 1",
     "4 0 4 1",   "5 0 5 1",   "6 0 6 1",   "7 0 7 1",
     "8 0 8 1",   "9 0 9 1",   "10 0 10 1", "11 0 11 1",
     "12 0 12 1", "13 0 13 1"], 1) # 6
p num_times(["-2 6 -2 1",  "2 6 2 1",  "6 -2 1 -2",  "6 2 1 2",
             "-2 5 -2 -1", "2 5 2 -1", "5 -2 -1 -2", "5 2 -1 2",
             "-2 1 -2 -5", "2 1 2 -5", "1 -2 -5 -2", "1 2 -5 2",
             "-2 -1 -2 -6","2 -1 2 -6","-1 -2 -6 -2","-1 2 -6 2"],5) # 3