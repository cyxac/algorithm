# Construction in O(nlog^2(n)) time
def get_suffix_array t
  l = t.size
  p = [[]]
  0.upto t.size-1 do |i| p[0][i] = t[i].ord end
  skip, level = 1, 1
  while skip < l
    p << []
    m = l.times.map do |i|
      [[p[level-1][i], i+skip < l ? p[level-1][i+skip] : -1000], i]
    end
    m.sort!
    l.times do |i|
      p[level][m[i][1]] = i>0 && m[i][0]==m[i-1][0] ? p[level][m[i-1][1]] : i
    end
    skip *= 2
    level += 1
  end
  sa = []
  p[-1].each_with_index do |v, i| sa[v] = i end
  sa
end

if __FILE__ == $0
  sa = get_suffix_array "bobocel"
  p get_suffix_array "alabalaalabala"
end