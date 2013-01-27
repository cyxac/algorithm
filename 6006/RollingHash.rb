class RollingHash
    def initialize base
        @base = base
        @hash = 0
        @magic = 1
        @p = 23 #random large prime >= size of pattern, but less than word size
        @inverse_base = @base**(@p-2) % p
    end
    
    def hash
        @hash
    end
    
    def append val
        @hash = (@hash*base + val) % @p
        @magic = @magic * @base % @p
    end
    
    def skip val
        @hash = (@hash - @magic*val) % @p
        @magic = @magic * @inverse_base % p
        # modulo arithmethic for: @magic = @magic / @base % @p
    end
end