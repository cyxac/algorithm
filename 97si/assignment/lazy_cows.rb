# http://poj.org/problem?id=2430

require "stringio"
require 'set'
INF = Float::INFINITY

class StringIO
  def gets_ints
    self.gets.split.map(&:to_i)
  end
end

def solve inputstr
  inputio = StringIO.new inputstr
  cows, barns = inputio.gets_ints
  a1, a2, s = [nil], [nil], Set.new
  cows.times do
    up_down, i = inputio.gets_ints
    s << i
    if up_down == 1
      a1[i] = true
    else
      a2[i] = true
    end
  end
  cows_index = s.to_a.sort
  dp = Array.new(cows_index.size) {
    Array.new(barns+1) {
      Array.new(4) { INF } 
    } 
  }
  height = [1,1,2,2]
  top1, bottom1 = a1[cows_index[0]], a2[cows_index[1]]
  if !bottom1
    dp[0][1][0] = 1
  elsif !top1
    dp[0][1][1] = 1
  end
  dp[0][1][2] = 2

  size_delta = ->(i, k){ height[k]*(cows_index[i]-cows_index[i-1]) }
  1.upto cows_index.size-1 do |i|
    1.upto barns do |j|
      0.upto 3 do |k|
        top, bottom = a1[cows_index[i]], a2[cows_index[i]]
        if top and bottom
          if k == 2 or k == 3
            t = [dp[i-1][j][k] + size_delta.(i,k)]
            4.times {|l| t << dp[i-1][j-1][l] + 2} if k == 2 && j > 1
            4.times {|l| t << dp[i-1][j-2][l] + 2} if k == 3 && j > 2
            dp[i][j][k] = t.min
          end
        elsif top
          if k!=1
            t = [dp[i-1][j][k] + size_delta.(i,k)]
            4.times {|l| t << dp[i-1][j-1][l] + 1} if k == 0 && j > 1
            4.times {|l| t << dp[i-1][j-1][l] + 2} if k == 2 && j > 1
            4.times {|l| t << dp[i-1][j-2][l] + 2} if k == 3 && j > 2
            dp[i][j][k] = t.min
          end
        else
          if k!=0
            t = [dp[i-1][j][k] + size_delta.(i,k)]
            4.times {|l| t << dp[i-1][j-1][l] + 1} if k == 1 && j > 1
            4.times {|l| t << dp[i-1][j-1][l] + 2} if k == 2 && j > 1
            4.times {|l| t << dp[i-1][j-2][l] + 2} if k == 3 && j > 2
            dp[i][j][k] = t.min
          end
        end
      end
    end
  end
  dp[cows_index.size-1][barns]
  # dp[2][1]
  # dp[0][1][3]
end


str = 
"8 2 9
1 2
1 6
1 7
1 8
1 9
2 2
2 3
2 4"

p solve str