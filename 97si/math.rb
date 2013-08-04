class Integer
  # binomial coefficient: n C k
  def choose(k)
    # n!/(n-k)! / k!
    (self-k+1 .. self).reduce(1, :*) / (2 .. k).reduce(1, :*)
  end
end

module Math97
  def pow a, n
    ret = 1
    while n > 0
      ret *= a if n.odd?
      a *= a
      n /=2
    end
    ret
  end
end

module Test
  def self.foo
    p 'yeah'
  end
end

if __FILE__ == $0
  include Math97
  
  p 5.choose(3)
  p 60.choose(30)
  
  p pow 5, 2
  p pow 5, 0
  p pow 5, 10
  
  include Math
  Math.cos
end