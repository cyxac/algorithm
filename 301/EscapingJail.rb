require_relative "../6006/graph"
include Graphs

def getMaxDistance(chain)
    char_values = char_to_int
    
    g = Graph.new
    chain.each_with_index do |str, i|
        str.each_char.with_index do |ch, j|
            if i != j and ch != " "
                g.add_edge_weight i, j, char_values[ch]
            end
        end
    end
    result = []
    g.each_vertex do |v|
        result.concat dijkstra(g, v).dist.values
    end
    return -1 if result.empty?
    max = result.max
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
 
# 8
#-1
#43
#0