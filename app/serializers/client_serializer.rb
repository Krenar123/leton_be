# app/serializers/client_serializer.rb
class ClientSerializer
  include JSONAPI::Serializer

  set_type :client
  set_id   :ref
  set_key_transform :camel_lower

  # simple passthrough attributes (must exist on the model)
  attributes :company, :contact_name, :email, :phone, :address, :website, :industry, :status

  # derived attributes
  attribute :current_projects do |obj|
    if Project.defined_enums["status"]&.key?("active")
      obj.projects.where(status: Project.statuses[:active]).count
    else
      obj.projects.where("end_date IS NULL OR end_date >= ?", Date.current).count
    end
  end

  attribute :total_projects do |obj|
    obj.projects.count
  end

  attribute :total_value do |obj|
    obj.invoices.sum(:total_amount).to_f
  end

  attribute :total_paid do |obj|
    paid_scope =
      if Invoice.defined_enums["status"]&.key?("paid")
        obj.invoices.where(status: Invoice.statuses[:paid])
      else
        obj.invoices.where.not(payment_date: nil)
      end
    paid_scope.sum(:total_amount).to_f
  end

  attribute :total_outstanding do |obj|
    (obj.invoices.sum(:total_amount).to_f - (
      if Invoice.defined_enums["status"]&.key?("paid")
        obj.invoices.where(status: Invoice.statuses[:paid]).sum(:total_amount).to_f
      else
        obj.invoices.where.not(payment_date: nil).sum(:total_amount).to_f
      end
    )).clamp(0.0, Float::INFINITY)
  end

  attribute :first_project do |obj|
    obj.projects.minimum(:start_date)&.to_s
  end

  attribute :last_project do |obj|
    obj.projects.maximum(:end_date)&.to_s
  end

  attribute :profitability do |obj|
    total = obj.invoices.sum(:total_amount).to_f
    next 0.0 if total.zero?
    paid = if Invoice.defined_enums["status"]&.key?("paid")
             obj.invoices.where(status: Invoice.statuses[:paid]).sum(:total_amount).to_f
           else
             obj.invoices.where.not(payment_date: nil).sum(:total_amount).to_f
           end
    ((paid / total) * 100.0).round(2)
  end
end
