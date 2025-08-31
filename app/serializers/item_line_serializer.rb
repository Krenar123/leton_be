# app/serializers/item_line_serializer.rb
class ItemLineSerializer
  include JSONAPI::Serializer

  attributes :ref, :project_id, :parent_id, :item_line, :level, :contractor,
             :unit, :quantity, :unit_price, :estimated_cost, :actual_cost,
             :estimated_revenue, :actual_revenue, :start_date, :due_date,
             :status, :depends_on_id, :cost_code, :parent_cost_code,
             :created_at, :updated_at

  attribute :supplier do |obj|
    if obj.supplier
      {
        id: obj.supplier.id,
        ref: obj.supplier.ref,
        company: obj.supplier.company
      }
    end
  end

  #
  # Helper: IDs for this node + all descendants (works with your get_children_ids)
  #
  def self.ids_for(obj)
    Array(obj.get_children_ids.presence || obj.id)
  end

  def self.leaf?(obj)
    Array(obj.get_children_ids).blank?
  end

  #
  # INVOICED = sum of invoice_lines.amount for this line and all its children
  #
  attribute :invoiced do |obj|
    ids = ids_for(obj)

    InvoiceLine
      .joins(:invoice)
      .where(item_line_id: ids, invoices: { project_id: obj.project_id })
      .sum(:amount)
  end

  #
  # PAID = allocate invoice header payments to this line set pro-rata
  #        share = (sum of this line set's invoice_line amounts on that invoice) / (invoice lines total)
  #        paid contribution = invoice.paid_total * share
  #
  attribute :paid do |obj|
    ids = ids_for(obj)

    invoices = Invoice
      .joins(:invoice_lines)
      .where(project_id: obj.project_id, invoice_lines: { item_line_id: ids })
      .distinct
      .includes(:payments, :invoice_lines)

    invoices.sum do |inv|
      total_lines = inv.invoice_lines.sum { |l| l.amount.to_d }
      next 0.to_d if total_lines.zero?

      subset_sum = inv.invoice_lines.select { |l| ids.include?(l.item_line_id) }
                                    .sum { |l| l.amount.to_d }

      (inv.paid_total.to_d) * (subset_sum / total_lines)
    end
  end

  #
  # BILLED = sum of bill_lines.amount for this line and all its children
  #
  attribute :billed do |obj|
    ids = ids_for(obj)

    BillLine
      .joins(:bill)
      .where(item_line_id: ids, bills: { project_id: obj.project_id })
      .sum(:amount)
  end

  #
  # PAYMENTS (for bills) = allocate bill header payments to this line set pro-rata
  #
  attribute :payments do |obj|
    ids = ids_for(obj)

    if leaf?(obj)
      # equal split on each bill that includes THIS item line
      bills = Bill
        .joins(:bill_lines)
        .where(project_id: obj.project_id, bill_lines: { item_line_id: obj.id })
        .distinct
        .includes(:payments, :bill_lines)

      bills.sum do |bill|
        line_count = bill.bill_lines.count
        next 0.to_d if line_count.zero?
        bill.paid_total.to_d / line_count
      end
    else
      # pro-rata for subtree (your original logic)
      bills = Bill
        .joins(:bill_lines)
        .where(project_id: obj.project_id, bill_lines: { item_line_id: ids })
        .distinct
        .includes(:payments, :bill_lines)

      bills.sum do |bill|
        total_lines = bill.bill_lines.sum { |l| l.amount.to_d }
        next 0.to_d if total_lines.zero?

        subset_sum = bill.bill_lines.select { |l| ids.include?(l.item_line_id) }
                                    .sum   { |l| l.amount.to_d }

        (bill.paid_total.to_d) * (subset_sum / total_lines)
      end
    end
  end
end
