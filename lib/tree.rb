require 'pp'
require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(input_arr)
    @tree_arr = input_arr
    @tree_arr.uniq!.sort!
    pp @tree_arr
    build_tree(@tree_arr)
  end

  def build_tree(build_arr, start_arr = 0, end_arr = build_arr.size - 1)
    return nil if start_arr > end_arr

    mid_arr = (start_arr + end_arr) / 2
    node = Node.new(build_arr[mid_arr])
    @root ||= node

    node.left_child = build_tree(build_arr, start_arr, mid_arr - 1)
    node.right_child = build_tree(build_arr, mid_arr + 1, end_arr)

    node
  end

  def insert(input_value, node = @root)
    return if node.nil?

    if input_value < node.value
      node.left_child.nil? ? node.left_child = Node.new(input_value) : insert(input_value, node.left_child)
    else
      node.right_child.nil? ? node.right_child = Node.new(input_value) : insert(input_value, node.right_child)
    end
  end

  def delete(input_value, node = @root)
    return nil if node.nil?

    if input_value < node.value
      node.left_child = delete(input_value, node.left_child)
    elsif input_value > node.value
      node.right_child = delete(input_value, node.right_child)
    else
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      # TODO FIX ENDLESS LOOP IF THE NODE HAS TWO CHILDREN
      replace_node = node.left_child until node.left_child.nil?
      node.value = replace_node.value
      node.right_child = delete(replace_node.value, node.right_child)
    end
    node
  end

  def find(input_value, node = @root)
    return nil if node.nil?

    if input_value < node.value
      find(input_value, node.left_child)
    elsif input_value > node.value
      find(input_value, node.right_child)
    elsif input_value == node.value
      node
    else
      nil
    end
  end

  # TODO Add functionality to yield to provided block, if given return the array
  def level_order(node = @root)
    return if node.nil?

    queue = [node]
    output_arr = []
    until queue.empty?
      current_node = queue[0]
      output_arr << current_node.value
      queue << current_node.left_child unless current_node.left_child.nil?
      queue << current_node.right_child unless current_node.right_child.nil?
      queue.delete_at(0)
    end
    output_arr
  end

  def inorder(node = @root, output_arr = [])
    return if node.nil?

    preorder(node.left_child, output_arr)
    output_arr.push(node.value)
    preorder(node.right_child, output_arr)
    output_arr
  end

  def preorder(node = @root, output_arr = [])
    return if node.nil?

    output_arr.push(node.value)
    preorder(node.left_child, output_arr)
    preorder(node.right_child, output_arr)
    output_arr
  end

  def postorder(node = @root, output_arr = [])
    return if node.nil?

    preorder(node.left_child, output_arr)
    preorder(node.right_child, output_arr)
    output_arr.push(node.value)
    output_arr
  end

  def height(node = @root)
    return 0 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)

    left_height > right_height ? left_height + 1 : right_height + 1
  end

  def depth(node = @root)
    return 0 if node == @root

    height(@root) - height(node)
  end

  def balanced?(node = @root)
    return true if node.nil?

    return true if balanced?(node.left_child) && balanced?(node.right_child) && (height(node.left_child) - height(node.right_child)).abs <= 1

    false
  end

  def rebalance
    arr = level_order
    pp arr
    arr.sort!
    pp arr
    build_tree(arr)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# tree.insert(20)
tree.pretty_print
# tree.delete(20)
# tree.pretty_print
# p tree.find(4).value
pp tree.level_order
pp tree.inorder
pp tree.preorder
pp tree.postorder
puts tree.height
puts tree.depth
puts tree.depth(tree.find(9))
puts tree.balanced?
tree.insert(10)
tree.insert(50)
tree.insert(69)
tree.pretty_print
tree.rebalance
tree.pretty_print