class Junction
  attr_accessor :duct_length, :children

  def initialize(duct_length)
    @duct_length = duct_length
    @children = []
  end
  
  def subsystem_length
    return duct_length if children.empty?
    #return duct_length + children.reduce(0) { |memo, obj| memo + obj.subsystem_length }
    return duct_length + children.map(&:subsystem_length).reduce(:+)
  end

  def longest_path_length
    return duct_length if children.empty?
    return duct_length + children.map(&:longest_path_length).max
  end
end

def estimate_time_out from_junctions, to_junctions, duct_lengths
  all_ducts = { 0 => Junction.new(0) }
  from_junctions.zip(to_junctions, duct_lengths) { |from_key, to_key, length|
    all_ducts[from_key] ||= Junction.new(0)
    from = all_ducts[from_key]

    all_ducts[to_key] ||= Junction.new(length)
    to = all_ducts[to_key]
    to.duct_length = length

    from.children << to
  }

  return all_ducts[0].subsystem_length * 2 - all_ducts[0].longest_path_length
end

p estimate_time_out [0], [1], [10] #=> 10
p estimate_time_out [1,0,0], [2,1,3], [10,10,10] #=> 40
p estimate_time_out [0,0,0,1,4], [1,3,4,2,5], [10,10,100,10,5] #=> 165
p estimate_time_out [0,0,0,1,4,4,6,7,7,7,20],[1,3,4,2,5,6,7,20,9,10,31],[10,10,100,10,5,1,1,100,1,1,5] #=> 281
p estimate_time_out [0,0,0,0,0], [1,2,3,4,5], [100,200,300,400,500] #=> 2500
