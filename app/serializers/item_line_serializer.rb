# app/serializers/item_line_serializer.rb
class ItemLineSerializer
  include JSONAPI::Serializer

  attributes :ref, :project_id, :parent_id, :item_line, :level, :contractor,
             :unit, :quantity, :unit_price, :estimated_cost, :actual_cost,
             :estimated_revenue, :actual_revenue, :start_date, :due_date,
             :status, :depends_on_id, :cost_code, :parent_cost_code, :created_at, :updated_at

  attribute :supplier do |obj|
    if obj.supplier
      {
        id: obj.supplier.id,
        ref: obj.supplier.ref,
        company: obj.supplier.company
      }
    end
  end

  attribute :invoiced do |obj|
    ids = obj.get_children_ids.present? ? obj.get_children_ids : obj.id
    
    obj.project.invoices.where(item_line_id: ids).sum("COALESCE(total_amount, amount, 0)")
  end

  attribute :paid do |obj|
    ids = Array(obj.get_children_ids.presence || obj.id)
  
    Payment
      .joins("INNER JOIN invoices
              ON invoices.id = payments.payable_id
             AND payments.payable_type = 'Invoice'")
      .where(invoices: { item_line_id: ids })
      .sum(:amount)
  end

  attribute :billed do |obj|
    ids = obj.get_children_ids.present? ? obj.get_children_ids : obj.id
    
    obj.project.bills.where(item_line_id: ids).sum("COALESCE(total_amount, amount, 0)")
  end

  attribute :payments do |obj|
    ids = Array(obj.get_children_ids.presence || obj.id)
  
    Payment
      .joins("INNER JOIN bills
              ON bills.id = payments.payable_id
             AND payments.payable_type = 'Bill'")
      .where(bills: { item_line_id: ids })
      .sum(:amount)
  end
end
