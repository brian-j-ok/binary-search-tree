# frozen_string_literal: true

# Node class with variable for the value and left and right child nodes
class Node
  include Comparable

  attr_accessor :value, :left_child, :right_child

  def initialize(value = nil, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end
end
