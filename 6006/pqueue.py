class PriorityQueue:
    """Heap-based priority queue"""
    def __init__(self):
        self.queue = []

    def __len__(self):
        return len(self.queue)
    
    def _parent_(self, i):
        return (i - 1)//2

    def _left_(self, i):
        return i*2 + 1

    def _right_(self, i):
        return i*2 + 2

    def min_heapify(self, i):
        l = self._left_(i)
        r = self._right_(i)
        if l < len(self.queue) and self.queue[l] < self.queue[i]:
            smallest = l
        else:
            smallest = i
        if r < len(self.queue) and self.queue[r] < self.queue[smallest]:
            smallest = r
        if smallest != i:
            self.queue[i], self.queue[smallest] = self.queue[smallest], self.queue[i]
            self.min_heapify(smallest)

    def append(self, key):
        if key is None:
            raise ValueError('Cannot insert None in the queue')
        self.queue.append(key)
        i = len(self.queue) - 1
        while i > 0 and self.queue[self._parent_(i)] > self.queue[i]:
            self.queue[self._parent_(i)], self.queue[i] = self.queue[i], self.queue[self._parent_(i)]
            i = self._parent_(i)

    def pop(self):
        if len(self.queue) == 0:
            return None
        self.queue[0], self.queue[-1] = self.queue[-1], self.queue[0]
        pop = self.queue.pop()
        self.min_heapify(0)
        return pop

    def min(self):
        if len(self.queue) == 0:
            return None
        return self.queue[0]