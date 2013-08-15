require "benchmark"
require_relative '..\\97si\\priority_queue'

n = 50
# x.to_s(2).size-1 is Math.log2(x).floor
# Benchmark.bm do |x|
#   x.report("log2") { n.times { Math.log2 64 } }
#   x.report("binary size") { 64.to_s(2).size - 1 }
# end

# a = [0]*n
# Benchmark.bm do |x|
#   x.report("unshift") { n.times {a.unshift(1)} }
#   x.report("shift") { n.times {a.shift}}
# end

array = [*(1..n)]
q = PriorityQueue.new {|a,b| [a,b].max}
Benchmark.bm do |x|
  x.report("<<") { n.times {|i| q << array[i]}}
  x.report("build") { PriorityQueue.new(array) {|a,b| [a,b].max} }
end