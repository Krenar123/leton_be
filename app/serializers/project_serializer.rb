# app/serializers/project_serializer.rb
class ProjectSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :ref, :name, :description, :status,
             :start_date, :end_date, :budget,
             :created_at, :updated_at, :location

  attribute :client do |project|
    project.client&.company
  end

  attribute :value do |project|
    project.budget.to_f
  end

  # Open receivables = invoices outstanding (sent + partial)
  attribute :openInvoicesOutstanding do |project|
    total = project.invoices # sent, partial
                 .sum("COALESCE(total_amount, amount, 0)").to_d
    paid  = Payment.joins("INNER JOIN invoices
                            ON invoices.id = payments.payable_id
                           AND payments.payable_type = 'Invoice'")
                   .where(invoices: { project_id: project.id })
                   .sum(:amount).to_d
    out = total - paid
    out.negative? ? 0.to_d : out
  end

  # Open payables = bills outstanding (issued + partially_paid)
  attribute :openBillsOutstanding do |project|
    total = project.bills # issued, partially_paid
                 .sum("COALESCE(total_amount, amount, 0)").to_d
    paid  = Payment.joins("INNER JOIN bills
                            ON bills.id = payments.payable_id
                           AND payments.payable_type = 'Bill'")
                   .where(bills: { project_id: project.id })
                   .sum(:amount).to_d
    out = total - paid
    out.negative? ? 0.to_d : out
  end

  # Simple profitability proxy (can refine later)
  attribute :profitability do |project|
    total_invoiced = project.invoices.sum("COALESCE(total_amount, amount, 0)")&.to_d || 0.to_d
    total_billed   = project.bills.sum("COALESCE(total_amount, amount, 0)")&.to_d || 0.to_d
  
    result =
      if total_invoiced.zero?
        0
      else
        ((total_invoiced - total_billed) / total_invoiced * 100).round(2)
      end
  
    result.to_f
  end
end
