class VendingMachine
    attr_accessor :prices, :display_col, :total_use, :last_purchase_time
    
    def initialize(prices)
        @prices = prices
        @display_col = 0
        @total_use = 0
        @last_purchase_time = 0
    end
    
    def display_expensive_column
        move find_expensive_column
    end
    
    def move(to_col)
        distance = (to_col - @display_col).abs
        @total_use += [distance, prices[0].size - distance].min
        @display_col = to_col
    end
    
    def purchase(row, column, time)
        display_expensive_column if (time - @last_purchase_time) >= 5
        @prices[row][column] = 0
        move column
        @last_purchase_time = time
    end
    
    def find_expensive_column
        # Could get it in one iteration,
        # but transpose is O(m*n), so this is not too bad on complexity.
        @prices.transpose.each_with_index.reduce([0, 0]) {|memo, col_and_index| 
            col, index = col_and_index
            sum = col.reduce(0, :+)
            sum > memo[0] ? [sum, index] : memo
        }[1]
    end
end

def motor_use prices, purchases
    prices = prices.map {|str| str.split(' ').map(&:to_i)}
    purchases = purchases.map {|str| str.split(/,|:/).map(&:to_i)}
    
    vending_machine = VendingMachine.new(prices)
    vending_machine.display_expensive_column
    
    purchases.each {|row, col, time|
        return -1 if prices[row][col] == 0
        
        vending_machine.purchase row, col, time
    }
    
    vending_machine.display_expensive_column 
    return vending_machine.total_use
end

puts motor_use ["100 100 100"], ["0,0:0", "0,2:5", "0,1:10"] #=> 4
puts motor_use ["100 200 300 400 500 600"], ["0,2:0", "0,3:5", "0,1:10", "0,4:15"] #=> 17
puts motor_use ["100 200 300 400 500 600"], ["0,2:0", "0,3:4", "0,1:8", "0,4:12"] #=> 11
puts motor_use ["100 100 100"], ["0,0:10", "0,0:11"] #=> -1
puts motor_use ["100 200 300", "600 500 400"], ["0,0:0", "1,1:10", "1,2:20", "0,1:21", "1,0:22", "0,2:35"] #=> 6