# app/serializers/item_line_serializer.rb
class ItemLineSerializer
  include JSONAPI::Serializer

  attributes :id, :ref, :item_line, :cost_code,
             :level,
             :parent_id,
             :estimated_cost,
             :actual_cost,
             :estimated_revenue,
             :actual_revenue,
             :start_date,
             :due_date,
             :status,
             :unit,
             :quantity,
             :unit_price,
             :contractor,
             :depends_on
end
