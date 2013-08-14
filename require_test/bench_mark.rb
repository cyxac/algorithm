require "benchmark"

n = 500000

# x.to_s(2).size-1 is Math.log2(x).floor
Benchmark.bm do |x|
  x.report("log2") { n.times { Math.log2 64 } }
  x.report("binary size") { n.times {64.to_s(2).size - 1} }
end

a = Array.new(100) do 0 end
b = {}
a.each_with_index do |v, i| b[i] = v end
Benchmark.bm do |x|
  x.report("Array") { n.times {|i| a[i % 100] } }
  x.report("Hash") { n.times {|i| b[i % 100] } }
end