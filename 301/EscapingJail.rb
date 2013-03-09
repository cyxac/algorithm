def getMaxDistance(chain)
    char_values = char_to_int

    adj = {}
    weight = {}
    chain.each_with_index do |str, i|
        if not adj.has_key?(i)
            adj[i] = []
        end
        str.each_char.with_index do |ch, j|
            if i != j and ch != " "
                adj[i] << j
                weight[[i,j]] = char_values[ch]
            end
        end
    end
    result = {}
    adj.each_key do |v|
        dijkstra(adj, weight, v, result)
    end
    max = result.max_by{|k,v| v}[1]
    max = max == Float::INFINITY ? -1 : max
    max
end

def char_to_int
    output = {}
    ("0".."9").each do |i|
        output[i] = i.to_i
    end
    ("a".."z").zip(10..35).each do |ch, value|
        output[ch] = value
    end
    ("A".."Z").zip(36..61).each do |ch, value|
        output[ch] = value
    end
    output
end

def dijkstra(adj, weight, source, result)
    dist = {}
    adj.each_key do |key|
        dist[key] = Float::INFINITY
        result[[source, key]] = Float::INFINITY
    end
    dist[source] = 0
    q = PriorityQueue.new
    q.insert([0,source])
    while not q.empty?
        u = q.extract_min[1]
        result[[source, u]] = dist[u] 
        adj[u].each do |v|
            new_dist = dist[u] + weight[[u,v]]
            if new_dist < dist[v]
                if dist[v] == Float::INFINITY
                    q.insert([new_dist, v])
                else
                    q.decrease_key([dist[v], v], [new_dist, v])
                end
                dist[v] = new_dist
            end
        end
    end
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
        if (key <=> @heap[i]) > 0
            raise "new key is larger than current key"
        end
        @heap[i] = key
        while i > 1
            parent = i / 2
            if (@heap[parent] <=> key) > 0
                swap i, parent
                i = parent
            else
#                @key_index[key] = i
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

p getMaxDistance ["0568", "5094", "6903", "8430"]
p getMaxDistance ["0 ", " 0"]
p getMaxDistance [
 "0AxHH190",
 "A00f3AAA",
 "x00     ",
 "Hf 0  x ",
 "H3  0   ",
 "1A   0  ",
 "9A x  0Z",
 "0A    Z0"]
 p getMaxDistance ["00", "00"]