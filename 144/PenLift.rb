class Point
  attr_accessor :x, :y, :connected

  def initialize(x, y)
    @x, @y, @connected = x, y, []
  end
  
  def to_s
    "(#@x, #@y)"
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
    return false if self.horizontal? != other.horizontal?
    if self.horizontal? && @head.y == other.head.y
      if ([@head.x, @tail.x].min <= [other.head.x, other.tail.x].max &&
          [@head.x, @tail.x].max >= [other.head.x, other.tail.x].min)
          all_x = [@head, @tail, other.head, other.tail].map { |e| e.x  }
          @head.x = all_x.min
          @tail.x = all_x.max
          return self
      end
    elsif !self.horizontal? && @head.x == other.head.x
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
    return false if self.horizontal? == other.horizontal?
    if self.horizontal?
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
    if self.horizontal?
      return point.y == @head.y && (@head.x..@tail.x).cover?(point.x)
    else
      return point.x == @head.x && (@head.y..@tail.y).cover?(point.y)
    end
  end
end

def merge_overlap!(lines)
  i = 0
  while i < lines.size
    lines[i+1..-1].each_with_index do |l2, j|
      if lines[i].merge! l2
        #lines.delete l2
        lines.delete_at(i+j+1)
        i -= 1
        break
      end
    end
    i += 1
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

def build_graph edges
  graph = {}
  edges.each do |l|
    graph[l.head.to_s] ||= l.head
    head = graph[l.head.to_s]

    graph[l.tail.to_s] ||= l.tail
    tail = graph[l.tail.to_s]

    head.connected << tail
    tail.connected << head
  end
  return graph
end

def split_into_connected_graphs graph
  connected_graphs = []
  queue = []
  while !graph.empty?
    queue << graph.first[1]
    connected_graph = {}
    while !queue.empty?
      vertice = queue.shift
      vertice.connected.each do |point|
        if !connected_graph.has_key?(point.to_s) # not recorded yet
          queue << point
          connected_graph[point.to_s] = point
          graph.delete(point.to_s)
        end
      end
    end
    connected_graphs << connected_graph
  end
  return connected_graphs
end

def num_times segments, n
  segments = segments.map { |e| e.split(" ").map(&:to_i) }
  lines = segments.map do |e|
    head = Point.new e[0], e[1]
    tail = Point.new e[2], e[3]
    Line.new head, tail
  end

  merge_overlap! lines

  split_intersect! lines

  whole_graph = build_graph lines

  connected_graphs = split_into_connected_graphs whole_graph

  if n % 2 == 0
    return connected_graphs.size - 1
  end

  pen_lift = 0
  connected_graphs.each do |graph|
    odd_vertices = graph.count {|k, v| v.connected.size % 2 == 1}
    pen_lift += odd_vertices > 0 ? odd_vertices/2 : 1
  end

  return pen_lift - 1
end

a = num_times(["-252927 -1000000 -252927 549481","628981 580961 -971965 580961",
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
b = num_times(["-10 0 10 0","0 -10 0 10"], 1) # => 1
c = num_times(["-10 0 0 0","0 0 10 0","0 -10 0 0","0 0 0 10"], 1) # => 1
d = num_times(["-10 0 0 0","0 0 10 0","0 -10 0 0","0 0 0 10"], 4) # => 0
