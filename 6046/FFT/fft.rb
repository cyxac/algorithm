def recursive_FFT a, inverse = false
  n = a.size
  return a if n == 1
  w_n = inverse ? Complex.polar(1, -2*Math::PI/n) : Complex.polar(1, 2*Math::PI/n)
  w = 1
  a_even = a.each_with_index.flat_map {|elem, i| i.even? ? elem : [] }
  a_odd = a.each_with_index.flat_map {|elem, i| i.odd? ? elem : [] }
  y_even = recursive_FFT a_even, inverse
  y_odd = recursive_FFT a_odd, inverse
  y = []
  0.upto(n/2 - 1) do |k|
    y[k] = y_even[k] + w*y_odd[k]
    y[k+n/2] = y_even[k] - w*y_odd[k]
    w *= w_n
  end
  y
end

def inverse_FFT a
  y = recursive_FFT a, true
  y = y.map {|elem| elem/a.size} 
end

def multiply a, b
  a_pv = recursive_FFT a
  b_pv = recursive_FFT b
  c_pv = a_pv.zip(b_pv).map {|elem_a, elem_b| elem_a * elem_b }
  inverse_FFT c_pv
end

# 6x^3 + 7x^2 - 10x + 9 times -2x^3 + 4x - 5
# eqauls -12x^6 - 14x^5 + 44x^4 -20x^3 + 75x^2 +86x -45
p multiply [9, -10, 7, 6, 0, 0, 0, 0], [-5, 4, 0, -2, 0, 0, 0, 0]