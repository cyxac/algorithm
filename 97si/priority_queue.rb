# insert, buble, pop take O(log(n)) time
# build takes O(n) time
# buble can't handle duplicate elements yet
class PriorityQueue
  def initialize array = [], &cmp
    @heap = array.unshift nil
    @index = {}
    @cmp = cmp.nil? ? ->(a, b){ [a, b].min } : cmp
    build @heap
  end

  def build array
    @heap = array
    (size/2).downto 1 do |i| heapify(i) end
    1.upto size do |i| @index[@heap[i]] = i end
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
    @heap << x
    @index[x] = size()
    buble_index size(), x
  end
  alias :<< :insert

  def add array
    build(@heap + array)
  end

  def buble_index i, x
    if @cmp.(@heap[i], x) != x
      raise "new element #{x} can't buble up over old element #{@heap[i]}"
    end
    @heap[i] = x
    @index[x] = i
    while i > 1 && @cmp.(@heap[parent i], @heap[i]) == @heap[i]
      swap i, parent(i)
      i = parent i
    end
  end

  # provide a second arg will replace the first arg in the queue
  def buble x, y=x
    if i = @index[x]
      buble_index i, y
    else
      raise "can't find value #{x}"
    end
    @index.delete x if x != y
  end

  def parent i
    i/2
  end

  
  def swap i, j
    @index[@heap[i]], @index[@heap[j]] = j, i
    @heap[i], @heap[j] = @heap[j], @heap[i]
  end

  def pop
    return nil if size < 1
    swap 1, size
    out = @heap.pop
    @index.delete out
    heapify(1)
    out
  end

  def heapify i
    l, r = 2*i, 2*i+1
    if l<=size && @cmp.(@heap[l], @heap[i]) == @heap[l]
      go_up = l
    else
      go_up = i
    end
    if r <= size && @cmp.(@heap[r], @heap[go_up]) == @heap[r]
      go_up = r
    end
    if go_up != i
      swap i, go_up
      heapify go_up
    end
  end
  
  def peak
    @heap[1]
  end
  
  def heap
    @heap
  end

  def index
    @index
  end
end

if __FILE__ == $0
  q = PriorityQueue.new [9, 8, 7]
  q.buble 7
  # q = PriorityQueue.new
  # q << 9
  # q << 8
  # q << 7
  # p q.include? 9
  # p q.heap
  # q = PriorityQueue.new([6,3, 7, 8, 434, 66, 88, -19, -20]) {|a, b| [a, b].min}
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
  # q.buble(88, 500)
  # p q.heap
  # while p q.pop
  # end
  # puts
  # q = PriorityQueue.new [1, 2, 2]
  # q.pop
  # p q.index
  # p q.heap
  # q.buble 2, 1
  # p q.index
  # p q.heap
  # q.buble 2, 1
end