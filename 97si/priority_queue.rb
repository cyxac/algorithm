# insert, bubble, pop take O(log(n)) time
# build takes O(n) time
# bubble can't handle duplicate elements yet
class PriorityQueue
  Elem = Struct.new :key, :index
  def initialize array = [], &cmp
    @heap = array.map { |e| Elem.new e }.unshift nil
    @index = {}
    @cmp = cmp.nil? ? ->(a, b){ a < b ? a : b } : cmp
    build
  end

  def build 
    (size/2).downto 1 do |i| heapify(i) end
    1.upto size do |i|
      @heap[i].index = i
      @index[@heap[i].key] =  @heap[i] 
    end
  end
  
  def include? x
    @index.include? x
  end
  
  def empty?
    size() == 0
  end
  
  def size
    @heap.size - 1
  end
  
  def insert(x)
    new_elem = Elem.new x, size()+1
    @heap << new_elem
    @index[x] = new_elem
  end
  alias :<< :insert

  def add array
    @heap.concat array.map { |e| Elem.new e }
    build
  end

  def bubble_index i, x
    if @cmp.(@heap[i].key, x.key) != x.key
      raise "new element #{x} can't bubble up over old element #{@heap[i]}"
    end
    @heap[i] = x
    x.index = i
    while i > 1 && @cmp.(@heap[parent i].key, @heap[i].key) == @heap[i].key
      swap i, parent(i)
      i = parent i
    end
  end

  # provide a second arg will replace the first arg in the queue
  def bubble x, y = nil
    if e = @index[x]
      if y.nil?
        bubble_index e.index, e
      else
        new_elem = Elem.new y, e.index
        @index[y] = new_elem
        bubble_index e.index, new_elem
        @index.delete x
      end
    else
      raise "can't find value #{x}"
    end
  end

  def parent i
    i/2
  end
  
  def swap i, j
    @heap[i].index, @heap[j].index = j, i
    @heap[i], @heap[j] = @heap[j], @heap[i]
  end

  def pop
    return nil if size < 1
    swap 1, size
    out = @heap.pop.key
    @index.delete out
    heapify(1)
    out
  end

  def heapify i
    l, r = 2*i, 2*i+1
    if l<=size && @cmp.(@heap[l].key, @heap[i].key) == @heap[l].key
      go_up = l
    else
      go_up = i
    end
    if r <= size && @cmp.(@heap[r].key, @heap[go_up].key) == @heap[r].key
      go_up = r
    end
    if go_up != i
      swap i, go_up
      heapify go_up
    end
  end
  
  def peak
    @heap[1].key
  end
end

if __FILE__ == $0
  # q = PriorityQueue.new
  # q << 9
  # q << 8
  # q << 7
  # p q.include? 9
  # p q.heap
  require "Benchmark"
  require "profile"
  q = PriorityQueue.new([6,3, 7, 8, 434, 66, 88, -19, -20])
  while p q.pop
  end
  TESTS = 100
  Benchmark.bmbm do |results|
    results.report("new:") { TESTS.times { 
      q = PriorityQueue.new([6,3, 7, 8, 434, 66, 88, -19, -20])
      while q.pop
      end
     } }     
  end
  # q.add [7676, 54, -321, 54, 65, 0, -432, 44]
  # p q.heap
  # q << 1
  # q << 7
  # p q.heap
  # q << 6
  # p q.heap
  # p q.pop
  # p q.pop
  # p q.pop
  # p q.include? 0

  # q = PriorityQueue.new([6,3, 7, 8, 434, 66, 88, -19, -20]) {|a, b| [a, b].max}
  # p q.heap
  # p q.index
  # q.bubble(88, 500)
  # p q.heap
  
  # puts
  # q = PriorityQueue.new [1, 2, 2]
  # q.pop
  # p q.index
  # p q.heap
  # q.bubble 2, 1
  # p q.index
  # p q.heap
  # q.bubble 2, 1
end