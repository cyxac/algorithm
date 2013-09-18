# Construction in O(nlog^2(n)) time
class SuffixArray
  def initialize t
    @t = t
    @l = t.size
    @p = [[]]
  end

  def get_suffix_array
    0.upto @t.size-1 do |i| @p[0][i] = @t[i].ord end
    skip, level = 1, 1
    while skip < @l
      @p << []
      m = @l.times.map do |i|
        [[@p[level-1][i], i+skip < @l ? @p[level-1][i+skip] : -1000], i]
      end
      m.sort!
      @l.times do |i|
        @p[level][m[i][1]] = i>0 && m[i][0]==m[i-1][0] ? @p[level][m[i-1][1]] : i
      end
      skip *= 2
      level += 1
    end
    sa = []
    @p[-1].each_with_index do |v, i| sa[v] = i end
    sa
  end

  # Longest common prefix of t[i..-1] and t[j..-1] in O(lg(n)) time
  def lcp i, j
    len = 0
    return @l-i if i == j
    k = @p.size-1
    while k>=0 && i<@l && j<@l
      if @p[k][i] == @p[k][j]
        skip = 2**k
        i += skip
        j += skip
        len += skip
      end
      k -= 1
    end
    len
  end
end

if __FILE__ == $0
  sa = SuffixArray.new "bobocel"
  p sa.get_suffix_array
  p sa.lcp 0, 2
  p SuffixArray.new("alabalaalabala").get_suffix_array 
end