class Array

  # Cycles through an array with a set of parameters for painless
  # alternate row highlighting
  # <% myarray.cycle do |item,css| -%>
  #  <div style='<%= css %>'> <%= item.name %> </div>
  # <% end -%>
  def cycle(pattern = %w( odd even ))
    self.each_with_index { |o,i| yield(o, pattern[i % pattern.size]) }
  end

  def randomize
    arr = self.dup
    arr.collect { arr.slice!(rand(arr.length)) }
  end

  def randomize!
    arr = self.dup
    result = arr.collect { arr.slice!(rand(arr.length)) }
    self.replace(result)
  end
end
