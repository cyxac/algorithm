def decode input
  input_ary = input.chars.map(&:to_i)
  [make_assumption(0, input_ary), make_assumption(1, input_ary)]
end

def make_assumption head, input
  origin = [head]
  input.each_with_index do |v, i|
    left_i = i - 1 >= 0 ? i-1 : i
    origin_i_plus_1 = v - origin[left_i..i].reduce(0, :+)
    if ![0, 1].include? origin_i_plus_1
      return "None"
    end
    if i == input.size - 1
      return "None" if origin_i_plus_1 != 0
      break
    end
    origin[i+1] = origin_i_plus_1
  end
  return origin.join
end

p decode "12221112222221112221111111112221111"

