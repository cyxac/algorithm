require "benchmark"

n = 500000
p Math.log2 64
p 64.to_s(2).size-1
# x.to_s(2).size-1 is Math.log2(x).floor
Benchmark.bm do |x|
  x.report("log2") { n.times { Math.log2 64 } }
  x.report("binary size") { 64.to_s(2).size - 1 }
end