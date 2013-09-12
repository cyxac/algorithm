# http://poj.org/problem?id=1936

require 'stringio'

def solve str
  io = StringIO.new str
  while line = io.gets
    s, t = *line.split
    i = 0
    s.each_char do |c|
      s = s[i..-1]
      k = kmp(s, c)
      if k.nil?
        puts "No"
        i = false
        break
      else
        i = k+1
      end
    end
    puts "Yes" if !i
  end
end

inputstr = 
"sequence subsequence
person compression
VERDI vivaVittorioEmanueleReDiItalia
caseDoesMatter CaseDoesMatter"

solve inputstr