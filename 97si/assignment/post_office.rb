# http://poj.org/problem?id=1160
require 'stringio'
INF = Float::INFINITY

def solve input_str
  @input = StringIO.new input_str
  v, p = readline_int @input
  @villages = readline_int @input
  dp = Array.new(v) { Array.new(p+1) }
  v.times {|i| dp[i][1] = min_dist 0, i}
  2.upto(p) {|j| dp[0][j] = INF }
  1.upto(v-1) do |i|
    2.upto(p) do |j|
      dp[i][j] = 0.upto(i-1).map {|k| dp[k][j-1] + min_dist(k+1, i)}.min
    end
  end
  dp[v-1][p]
end

def min_dist a, b
  mid = (a+b)/2
  a.upto(b).reduce(0) {|acc, i| acc + (@villages[i]-@villages[mid]).abs }
end

def readline_int input
  input.gets.split.map(&:to_i)
end

input_str = 
"10 5
1 2 3 6 7 9 11 22 44 50"

p solve input_str