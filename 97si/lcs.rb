# Longest common subsequence
# O(nm) where n, m are sizes of inputs
def lcs x, y
  n, m = x.size, y.size
  x, y = "0" + x, "0" + y
  str = Array.new(n+1) { Array.new(m+1) }
  d1, d2 = [0]*(m+1), [0]*(m+1)
  1.upto n do |i|
    1.upto m do |j|
      if x[i] == y[j]
        d2[j] = d1[j-1] + 1
        str[i][j] = "\\"
      else
        if d1[j] > d2[j-1]
          d2[j] = d1[j]
          str[i][j] = "|"
        else
          d2[j] = d2[j-1]
          str[i][j] = "-"
        end
      end
    end
    d1 = d2
  end
  
  trace = ->(i,j){
    out = []
    while i>0 && j>0
      if str[i][j] == "\\"
        out << x[i]
        i-=1 and j-=1
      elsif str[i][j] == "|"
        j -= 1
      elsif str[i][j] == "-"
        j -= 1
      end
    end
    out.reverse
  }
  
  out_str = trace.(n, m)
  [d2[m], out_str.join]
end

p lcs "ABCBDAB", "BDCABC"