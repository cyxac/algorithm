require 'stringio'

def solve inputstr
  @input = StringIO.new inputstr
  n = @input.gets.to_i
  ints = @input.read.split.map(&:to_i)
  a = Array.new(n) do |i|
    Array.new(n) do |j|
      ints[i*n + j]
    end
  end
  # dp = Array.new(n) { Array.new(n) }
  # dp[0][0] = [a[0][0], 1, 1]
  # 0.upto n-1 do |i|
  #   0.upto n-1 do |j|
  #     next if i == 0 && j == 0
  #     adj = [[a[i][j], 1, 1]]


  #   end
  # end
end

str = 
"4
0 -2 -7 0 9 2 -6 2
-4 1 -4 1 -1

8 0 -2"

# p solve str

a = Array.new(4) { Array.new(4) { rand(-10..10) } }
a.each { |e| p e }