def edit_distance n1, s1, n2, s2
    distances = Array.new(n1) { Array.new(n2) }
    distances[n1] = []
    distances[n1][n2] = [0, "nothing to do"]

    (n1).downto(0) do |i|
        (n2).downto(0) do |j|
            next if i == n1 and j == n2
            if s1[i] == s2[j]
                distances[i][j] = distances[i+1][j+1][0], "right"
                next
            end
            ops = []
            ops << [distances[i+1][j+1][0]+4, "replace"] if i < n1 and j < n2
            ops << [distances[i][j+1][0]+3, "insert"] if j < n2
            ops << [distances[i+1][j][0] + 2, "delete"] if i < n1
            distances[i][j] = ops.min
        end
    end
    output distances, n1, n2, s1, s2
end

def output distances, n1, n2, s1, s2
    cost = {"right" => 0, "replace" => 4, "insert" => 3, "delete" => 2}
    puts "x: #{s1}"
    puts "y: #{s2}"
    puts "Edit distance: #{distances[0][0][0]}"
    puts
    puts "Oper    | c |Total| z"
    puts "initial | 0 |   0 | *#{s1}"

    left = []
    right = s1.chars.to_a
    i,j = 0,0
    total = 0
    while i != n1 && j != n2
        op = distances[i][j][1]
        total += cost[op]
        
        if op == "right"
            i += 1
            j += 1
            left << right.shift
        elsif op == "replace"
            left << s2[j]
            right.shift
            i+=1
            j+=1
        elsif op == "insert"
            left << s2[j]
            j+=1
        elsif op == "delete"
            right.shift
            i+=1
        end

        puts "%-8s| %u |%4s | %s" % [op, cost[op], total, left.join+"*"+right.join]
    end
end

def read_file file_name
    file = File.new(File.dirname(__FILE__) + "/#{file_name}", "r")
    n1 = file.gets.to_i
    s1 = file.gets.strip
    n2 = file.gets.to_i
    s2 = file.gets.strip
    [n1, s1, n2, s2]
end

edit_distance *(read_file "input1.txt")