def find_eigen_vector(matrix)
    matrix = matrix.map { |s| s.split(" ").map(&:to_i) }

    1.upto(9) do |l0|
        vectors_with_norm(l0, matrix.size) do |vector|
            if proportional?(vector, multiply(matrix, vector))
                return vector
            end
        end
    end
end

def vectors_with_norm(norm, size)
    output = [0]*(size-1) << norm
    while output
        yield output
        output = next_vector(output, norm)
    end
end

def next_vector(vector, norm)
    i = (vector.size-1).downto(1).find { |index| vector[index] != 0 }
    return nil if i == nil
    
    if vector[i] < 0 and i == vector.size-1
        vector[i] = -vector[i]
    elsif vector[i] > 0
        vector[i-1] += 1
        vector[i] = -(norm - vector[0...i].map(&:abs).reduce(:+))
    elsif vector[i] < 0
        vector[i] += 1
        vector[i+1] = -1
    end
    return vector
end

def proportional?(v1, v2)
    k = nil
    v1.zip(v2).each do |a, b|
        if a != b and a*b == 0
            return false
        elsif a == 0 and b == 0
            next
        elsif k.nil?
        # elsif !defined?(k) will not work, since each iteration has its own
        # scope, defining k in one will not define k for the others.
            k = a/b.to_f
            next
        elsif a != k*b
            return false
        end
    end
    return true
end

def multiply(matrix, vector)
    return matrix.map do |row|
        row.zip(vector).reduce(0) do |sum, pair|
            sum + pair[0]*pair[1]
        end
    end
end

p find_eigen_vector(["1 0 0 0 0",
                     "0 1 0 0 0",
                     "0 0 1 0 0",
                     "0 0 0 1 0",
                     "0 0 0 0 1"])      # [0,0,0,0,1]
p find_eigen_vector(["100 0 0 0",
                     "0 200 0 0",
                     "0 0 333 0",
                     "0 0 0 42"])       # [0, 0, 0, 1]
p find_eigen_vector(["10 -10 -10 10",
                     "20 40 -10 -10",
                     "10 -10 10 20",
                     "10 10 20 5"])     # [ 1,  -5,  2,  0 ]
p find_eigen_vector(["30 20","87 2"])   # [2, 3]
