class ItemLine < ApplicationRecord
  belongs_to :project
  belongs_to :parent, class_name: 'ItemLine', optional: true
  belongs_to :depends_on, class_name: 'ItemLine', optional: true
  belongs_to :created_by, class_name: 'User'
  belongs_to :supplier, optional: true

  enum :status, { not_started: 0, in_progress: 1, completed: 2, on_hold: 3 }

  validates :item_line, :level, presence: true

  before_validation :assign_cost_codes, on: :create

  def assign_cost_codes
    return if cost_code.present? # Skip if manually set
  
    if level == 1 || parent_id.nil?
      # Top-level category
      existing_top_level = project.item_lines.where(level: 1)
      next_number = existing_top_level.count + 1
      self.cost_code = next_number.to_s
    else
      # Subcategory or item line
      parent = project.item_lines.find_by(id: parent_id)
      return self.cost_code = "UNASSIGNED" if parent.nil? || parent.cost_code.blank?
  
      # Count siblings with the same parent
      sibling_count = project.item_lines.where(parent_id: parent_id).count
      self.cost_code = "#{parent.cost_code}.#{sibling_count + 1}"
    end
  end

  def get_children_ids
    project.item_lines
       .where("cost_code LIKE ?", "#{cost_code}.%")
       .pluck(:id)
  end
end
