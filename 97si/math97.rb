require "matrix"
include Math

class Integer
  # binomial coefficient: n C k
  def choose(k)
    # n!/(n-k)! / k!
    (self-k+1 .. self).reduce(1, :*) / (2 .. k).reduce(1, :*)
  end
end

class Vector
  def rotate(angle)
    Matrix[[cos(angle), -sin(angle)], [sin(angle), cos(angle)]] * self
  end
end

class Array
  def rotate(angle)
    Vector.elements(self).rotate(angle).to_a
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

  module_function :pow
end

module Test
  def foo
    p 'yeah'
  end

  module_function :foo
end

if __FILE__ == $0
  include Math97
  
  p 300.choose(30)
  p 60.choose(30)
  
  p Vector[1, 0].rotate(PI/2)

  p [1,0].rotate(PI/2)
end