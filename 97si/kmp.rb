# p needs to be 1-index
def compute_prefix_function p
  pi = [-1]
  k = -1
  1.upto p.size-1 do |i|
    while k >= 0 && p[k+1] != p[i]
      k = pi[k]
    end
    pi[i] = k += 1
  end
  pi
end

# O(n)
def kmp t, p
  n, m = t.size, p.size
  t = "$" + t
  p = "$" + p
  pi = compute_prefix_function p
  q = 0
  1.upto n do |i|
    while q >= 0 && p[q+1] != t[i]
      q = pi[q]
    end
    q += 1
    if q == m
      return i-m # store instead of return to findall
      q = pi[q]
    end
  end
  nil
end

if __FILE__ == $0
  t = "The example above illustrates the general technique for assembling "+
    "the table with a minimum of fuss. The principle is that of the overall search: "+
    "most of the work was already done in getting to the current position, so very "+
    "little needs to be done in leaving it. The only minor complication is that the "+
    "logic which is correct late in the string erroneously gives non-proper "+
    "substrings at the beginning. This necessitates some initialization code."
  i = kmp t, "table"
  p i, t[i, 'table'.size] 
end