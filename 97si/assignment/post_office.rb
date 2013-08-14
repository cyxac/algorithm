# http://poj.org/problem?id=1160
require 'stringio'
INF = Float::INFINITY

def solve input_str
  @input = StringIO.new input_str
  v, m = readline_int @input
  villages = readline_int(@input).unshift nil
  dp = [[[0]*(v+1)]*(m+1)]*(v+1)
  1.upto(v) do |i|
    1.upto(m) do |j|
      1.upto(v) do |k|
        if k <= i
          dp[i][j][k] = [dp[i-1][j-1][i-1], dp[i-1][j][k]].min
        elsif k > i
          sum = (i+1).upto(k-1).reduce(0) do |acc, l|
            acc + [villages[l]-villages[i], villages[k]-villages[l]].min
          end
          dp[i][j][k] = [dp[i-1][j-1][i]+sum, dp[i-1][j][k]].min
        end
      end
    end
  end
  p dp[1][1]
  dp[v][m][v]
end

def readline_int input
  input.gets.split.map(&:to_i)
end

input_str = 
"10 5
1 2 3 6 7 9 11 22 44 50"

p solve input_str