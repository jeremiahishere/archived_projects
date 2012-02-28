# A queue that will not accept data it has already contained in the past
class UniqueQueue 
  def initialize
    @queue = Array.new
    @history = Array.new
  end
  
  def push_if_not_duplicate(data)
    if !@history.include?(data)
      @queue.push(data)
      @history.push(data)
    end
  end

  def pop_first
    f = @queue.first
    @queue.delete_at(0)
    return f
  end

  def size
    @queue.size
  end

  def to_s
    @queue.inspect
  end

  def history
    @history
  end
end
