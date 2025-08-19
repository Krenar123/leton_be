class InvoiceSerializer
  include JSONAPI::Serializer
  
  attributes :ref, :invoice_number, :amount, :tax_amount, :total_amount,
             :issue_date, :due_date, :status, :payment_date,
             :created_at, :updated_at

  belongs_to :project
  belongs_to :client 
end
