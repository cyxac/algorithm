class PriorityQueue1:
    """Array-based priority queue implementation."""
    def __init__(self):
        """Initially empty priority queue."""
        self.queue = []
        self.min_index = None
    
    def __len__(self):
        # Number of elements in the queue.
        return len(self.queue)
    
    def append(self, key):
        """Inserts an element in the priority queue."""
        if key is None:
            raise ValueError('Cannot insert None in the queue')
        self.queue.append(key)
        self.min_index = None
    
    def min(self):
        """The smallest element in the queue."""
        if len(self.queue) == 0:
            return None
        self._find_min()
        return self.queue[self.min_index]
    
    def pop(self):
        """Removes the minimum element in the queue.
    
        Returns:
            The value of the removed element.
        """
        if len(self.queue) == 0:
            return None
        self._find_min()
        popped_key = self.queue.pop(self.min_index)
        self.min_index = None
        return popped_key
    
    def _find_min(self):
        # Computes the index of the minimum element in the queue.
        #
        # This method may crash if called when the queue is empty.
        if self.min_index is not None:
            return
        min = self.queue[0]
        self.min_index = 0
        for i in xrange(1, len(self.queue)):
            key = self.queue[i]
            if key < min:
                min = key
                self.min_index = i

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