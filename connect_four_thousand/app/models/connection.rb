class Connection < ActiveRecord::Base
  belongs_to :graph
  belongs_to :start_node, :class_name => "Node", :foreign_key => :start_node_id
  belongs_to :end_node, :class_name => "Node", :foreign_key => :end_node_id

  validates_presence_of :start_node_id, :end_node_id

  # this doesn't work
  # keeping for now but is not being used
  def self.ordered_by_name
    sort_by(&:name)
  end

  def name
    return self.start_node.name + " to " + self.end_node.name
  end
end
