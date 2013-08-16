# http://poj.org/problem?id=2292

require 'stringio'
INF = Float::INFINITY

def solve inputstr
  @input = StringIO.new inputstr
  @input.gets.to_i.times do # test cases
    count = Hash.new {|h,k| h[k]=0}
    @input.gets.to_i.times do # words
      @input.gets.strip.each_char {|c| count[c] += 1 }
    end
    keys = [nil] + ('a'..'z').to_a + ["+", "*", "/", "?"]
    
    dp = Array.new(13){ Array.new(31) { Array.new(31) {0} } }
    sep = Array.new(13){ Array.new(2) { Array.new(31) {0} } }
    1.upto(12) do |k|
      1.upto 30 do |i|
        (i+k-1).upto 30 do |j|
          if k == 1
            dp[k][i][j] = dp[k][i][j-1] + count[keys[j]]*(j-i+1)
            next
          end
          min = INF
          s = i+k-1
          (i+k-2).upto(j-1) do |l|
            sum = dp[k-1][i][l] + dp[1][l+1][j]
            min, s = sum, l+1 if sum < min 
          end
          dp[k][i][j] = min
          sep[k][1][j] = s if i == 1
        end
      end
    end
    # p sep[8][1][8]
    
    k = 12
    j = 30
    output = []
    while k>1
      output << keys[sep[k][1][j]]
      j = sep[k][1][j] - 1
      k-=1
    end
    puts output.reverse.join
  end
end

str = 
"2
2
hi
ok
5
hello
bye
how
when
who"

solve str