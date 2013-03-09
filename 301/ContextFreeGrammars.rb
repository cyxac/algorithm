def countParsingTrees rules, seed, word
    @rules = process_rules(rules)
    @word = word
    @memo_r = {}
    @memo_s = {}
    num_trees = count_trees_by_seed(0, word.size-1, seed)
    return -1 if num_trees > 1000000000
    num_trees
end

def count_trees_by_rule i, j, rule, k
    return @memo_r[[i,j,rule,k]] if @memo_r.has_key?([i,j,rule,k])

    return 1 if (i == j+1 && k == rule.size)
    return 0 if (i >= j + 1 || k >= rule.size) 
    
    res = 0
    if rule[k] == rule[k].downcase
        if rule[k] == @word[i]
            res = count_trees_by_rule(i+1,j,rule,k+1)
        else 
            res = 0
        end
    else
        chars_left = rule.size - k -1
        max = j - chars_left
        (i..max).each do |l|
            res += count_trees_by_seed(i,l,rule[k]) * count_trees_by_rule(l+1,j,rule,k+1)
        end
    end
    @memo_r[[i,j,rule,k]] = res
    return res
end

def count_trees_by_seed i, j, s
    return @memo_s[[i,j,s]] if @memo_s.has_key?([i,j,s])
#    p i, j, s
    return 0 if not @rules.has_key? s
    num_trees = @rules[s].reduce(0) do |sum, rule|
        sum += count_trees_by_rule(i, j, rule, 0)
    end
    @memo_s[[i,j,s]] = num_trees
    num_trees
end

def process_rules rules
    output = {}
    rules.each do |str|
        nonterminal, exps = str.split("::=")
        if output.has_key? nonterminal.strip
            output[nonterminal.strip].concat(exps.split("|").map do |exp| 
                exp.strip()
            end)
        else
            output[nonterminal.strip] = exps.split("|").map do |exp| 
                exp.strip()
            end
        end
    end
    output
end

p countParsingTrees(["A ::= BD",
                     "B ::= bB | b | Bb",
                     "D ::= dD",
                     "D ::= d"],
                     "A", "bdd")
p countParsingTrees(["A ::= BD",
                     "B ::= bB | b | Bb",
                     "D ::= dD",
                     "D ::= d"],
                     "A", "bbd")
p countParsingTrees(["A ::= BD",
                     "B ::= bB | b | Bb",
                     "D ::= dD",
                     "D ::= d"],
                    'A',
                    "ddbb")
p countParsingTrees(["B ::= topcoder | topcoder", "B ::= topcoder"],
                    'B',
                    "topcoder")
p countParsingTrees(["A ::= BCD",
                     "Z ::= z",
                     "B ::= Cz | Dz | Zz",
                     "C ::= Bz | Dz",
                     "D ::= Cz | Bz"], 'X', "zzz")
 
 p countParsingTrees(["B ::= bB | bB | bB | bB | b"],'B',"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
