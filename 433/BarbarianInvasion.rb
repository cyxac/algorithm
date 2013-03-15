require "./6006/graph"

def minimal_detachment country_map, detachment_size
    detachment_size = Hash[("A".."Z").zip(detachment_size)]
    g = Graph.new
    sink = nil
    country_map.each_with_index do |row, i|
        row.each_char.with_index do |char, j|
            in_node, out_node = 2*(i*row.size+j), 2*(i*row.size+j)+1
            if char == "*"
                sink = in_node
                next
            end
            next if char == "-"
            g.add_edge_weight(in_node, out_node, detachment_size[char] + 1000000)
            if i == 0 or i == country_map.size-1 or j == 0 or j == row.size-1
                g.add_edge_weight(-1, in_node, Float::INFINITY)
            end
            [[i-1,j], [i, j-1], [i, j+1], [i+1,j]].each do |i_, j_|
                if i_ >=0 and i_ <= country_map.size-1 and j_ >=0 and j_ <= row.size-1
                    in_ = 2*(i_*row.size+j_)
                    g.add_edge_weight(out_node, in_, Float::INFINITY)
                end
            end
        end
    end
    ford_Fulkerson(g, -1, sink).value % 1000000
end

p minimal_detachment(
["ABA", 
 "A*A",  
 "AAA"], [1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])

p minimal_detachment(
["CCCC",
 "-BAC",
 "-*AC",
 "--AC"],
[5,20,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])

p minimal_detachment(
["A----A",
 "-AAAA-",
 "-AA*A-",
 "-AAAA-",
 "A----A"],
[9,8,2,5,3,2,1,2,6,10,4,6,7,1,7,8,8,8,2,9,7,6,5,1,5,10])

p minimal_detachment(
["-A-----",
 "-BCCC*-",
 "-A-----"],
[1,5,10,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])

p minimal_detachment(
["WANNABRUTEFORCEMEHUH",
 "ASUDQWNHIOCASFIUQISA",
 "UWQD-ASFFC-AJSQOOWE-",
 "-----*Y--AVSSFIUQISA",
 "UWQD-ASFFC-AJSQOOWE-",
 "JUFDIFD-CHBVISBOOWE-",
 "WANNABRUTEFORCEMEHUH"],
[87,78,20,43,30,12,9,18,57,93,32,60,64,9,69,74,74,78,12,81,63,57,48,8,44,95])

#5
#25
#0
#5
#218