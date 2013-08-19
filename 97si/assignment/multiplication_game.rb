# http://poj.org/problem?id=2505

require 'stringio'
require 'set'

def solve inputstr
  inputio = StringIO.new inputstr
  dp = [nil]
  dp[1] = 0
  dp[2] = 1
  3.upto 700 do |i|
    s = (2..9).map {|j| dp[(i/j.to_f).ceil]}.to_set
    dp[i] = 0.upto(1000).find {|v| !s.member? v}
    # if (2..9).any? {|j| dp[(i.to_f/j).ceil] == 'L' }
    #   dp[i] = 'W'
    # else
    #   dp[i] = 'L'
    # end
  end
  # p dp
  dp.each_with_index do |v, i|
    puts "#{i}: #{v}"
  end
end

str = 
"162
17
34012226"

solve str