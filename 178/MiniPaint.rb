def least_bad picture, max_strokes
    min = {}
    -1.upto(max_strokes) do |s|
        min[[picture.size, 0, "B", s]] = 0
        min[[picture.size, 0, "W", s]] = 0
    end
    
    (picture.size-1).downto(0) do |i|
        (picture[0].size-1).downto(0) do |j|
            min[[i, j, "B", -1]] = picture.size*picture[0].size - (i*picture[0].size + j)
            min[[i, j, "W", -1]] = min[[i, j, "B", -1]]
        end
    end
    
    (picture.size-1).downto(0) do |i|
        (picture[0].size-1).downto(0) do |j|
            0.upto(max_strokes) do |s|
                b = picture[i][j] == "B" ? 0 : 1
                w = picture[i][j] == "W" ? 0 : 1
                if j != picture[0].size - 1 and j != 0
                    min[[i,j,"B",s]] = [b + min[[i, j+1, "B", s]], w + min[[i,j+1, "W", s-1]]].min
                    min[[i,j,"W",s]] = [w + min[[i, j+1, "W", s]], b + min[[i,j+1, "B", s-1]]].min
                elsif j == 0 and j != picture[0].size - 1
                    if s > 0
                        min[[i,j,"B",s]] = [b + min[[i, j+1, "B", s-1]], w + min[[i,j+1, "W", s-1]]].min
                        min[[i,j,"W",s]] = min[[i, j, "B", s]]
                    else
                        min[[i,j,"B",s]] = min[[i, j, "B", -1]]
                        min[[i,j,"W",s]] = min[[i, j, "W", -1]]
                    end
                else
                    min[[i,j,"B",s]] = [b + min[[i+1, 0, "B", s]], w + min[[i+1,0, "W", s-1]]].min
                    min[[i,j,"W",s]] = [w + min[[i+1, 0, "W", s]], b + min[[i+1,0, "B", s-1]]].min
                end
            end
        end
    end
    
    min[[0, 0, "B", max_strokes]]
end

p least_bad [
"BBBBBBBBBBBBBBB",
"WWWWWWWWWWWWWWW",
"WWWWWWWWWWWWWWW",
"WWWWWBBBBBWWWWW"], 6

p least_bad [
"BBBBBBBBBBBBBBB",
"WWWWWWWWWWWWWWW",
"WWWWWWWWWWWWWWW",
"WWWWWBBBBBWWWWW"], 4

p least_bad [
"BBBBBBBBBBBBBBB",
"WWWWWWWWWWWWWWW",
"WWWWWWWWWWWWWWW",
"WWWWWBBBBBWWWWW"], 0

p least_bad [
"BWBWBWBWBWBWBWBWBWBWBWBWBWBWBW",
"BWBWBWBWBWBWBWBWBWBWBWBWBWBWBW",
"BWBWBWBWBWBWBWBWBWBWBWBWBWBWBW",
"BWBWBWBWBWBWBWBWBWBWBWBWBWBWBW",
"BWBWBWBWBWBWBWBWBWBWBWBWBWBWBW",
"BWBWBWBWBWBWBWBWBWBWBWBWBWBWBW"], 100

p least_bad ["B"], 1