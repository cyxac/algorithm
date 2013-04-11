def sort_by_odds input
  input = input.map do |rule|
    name_and_spec = rule.split ": "
    spec = name_and_spec[1].split ' '
    choices, blanks = spec[0].to_i, spec[1].to_i
    valid_tickets = 0
    if spec[2] == 'T' && spec [3] == 'T'
      valid_tickets = combination choices, blanks
    elsif spec[2] == 'F' && spec[3] == 'T'
      valid_tickets = fact(choices)/fact(choices - blanks)
    elsif spec[2] == 'T' && spec[3] == 'F'
        #Combination with repetition(like donuts choosing example)
      valid_tickets = combination choices+blanks-1, blanks
    elsif spec[2] == 'F' && spec[3] == 'F'
      valid_tickets = choices**blanks
    end

    [name_and_spec[0], valid_tickets]
  end.
    sort_by { |e| [e[1], e[0]] }.
    map { |e| e[0] }
end

def fact n
  (1..n).reduce(1, :*)
end

def combination n, r
  fact(n)/(fact(r)*fact(n-r))
end

p sort_by_odds [
  "PICK ANY TWO: 10 2 F F",
  "PICK TWO IN ORDER: 10 2 T F",
  "PICK TWO DIFFERENT: 10 2 F T",
  "PICK TWO LIMITED: 10 2 T T" ]

p sort_by_odds [
  "INDIGO: 93 8 T F",
  "ORANGE: 29 8 F T",
  "VIOLET: 76 6 F F",
  "BLUE: 100 8 T T",
  "RED: 99 8 T T",
  "GREEN: 78 6 F T",
  "YELLOW: 75 6 F F" ]
  
p sort_by_odds []