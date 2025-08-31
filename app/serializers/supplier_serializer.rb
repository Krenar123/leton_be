# app/serializers/supplier_serializer.rb
class SupplierSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :ref, :company, :contact_name, :email, :phone, :address, :website, :category, :status

  attribute :currentProjects do |s, params|
    ag = params&.dig(:aggregates)
    if ag && ag.id == s.id
      # mark a project as “current” if it has any active bill or active item line rows
      # We approximate currentProjects as number of distinct active projects.
      # With only row-level flags available, we’ll fall back to a simpler boolean → count 1 if any active rows exist.
      ((ag.active_bill_rows.to_i > 0) || (ag.active_item_rows.to_i > 0)) ? total_projects_from(ag) : 0
    else
      # In index: we only have counts, not distinct of “active only” — show a softer signal:
      ((s.read_attribute(:active_bill_rows).to_i > 0) || (s.read_attribute(:active_item_rows).to_i > 0)) ? total_projects_from(s) : 0
    end
  end

  attribute :totalProjects do |s, params|
    ag = params&.dig(:aggregates)
    ag ? total_projects_from(ag) : total_projects_from(s)
  end

  attribute :totalValue do |s, params|
    ag = params&.dig(:aggregates)
    (ag ? ag.read_attribute(:total_value_sum) : s.read_attribute(:total_value_sum)).to_d
  end

  attribute :totalPaid do |s, params|
    ag = params&.dig(:aggregates)
    (ag ? ag.read_attribute(:total_paid_sum) : s.read_attribute(:total_paid_sum)).to_d
  end

  attribute :totalOutstanding do |s, params|
    tv = (params&.dig(:aggregates) ? params[:aggregates].read_attribute(:total_value_sum) : s.read_attribute(:total_value_sum)).to_d
    tp = (params&.dig(:aggregates) ? params[:aggregates].read_attribute(:total_paid_sum)  : s.read_attribute(:total_paid_sum)).to_d
    out = tv - tp
    out.negative? ? 0.to_d : out
  end

  attribute :firstProject do |s, params|
    first_bill = (params&.dig(:aggregates) ? params[:aggregates].read_attribute(:first_bill_date) : s.read_attribute(:first_bill_date))
    # Fallback: earliest project start the supplier touched (via item lines or bills)
    if first_bill.present?
      first_bill
    else
      # fallback needs a quick query; do it only in show (params present)
      if params&.dig(:aggregates)
        first_from_items = s.item_lines.joins(:project).minimum('projects.start_date')
        first_from_bills = s.bills.joins(:project).minimum('projects.start_date')
        [first_from_items, first_from_bills].compact.min
      end
    end
  end

  attribute :lastProject do |s, params|
    last_bill = (params&.dig(:aggregates) ? params[:aggregates].read_attribute(:last_bill_date) : s.read_attribute(:last_bill_date))
    if last_bill.present?
      last_bill
    else
      if params&.dig(:aggregates)
        last_from_items = s.item_lines.joins(:project).maximum('projects.end_date')
        last_from_bills = s.bills.joins(:project).maximum('projects.end_date')
        [last_from_items, last_from_bills].compact.max
      end
    end
  end

  attribute :profitability do |_s|
    # Not defined yet for vendors; keep 0 (or nil) so FE renders fine.
    0
  end

  def self.total_projects_from(source)
    if source.is_a?(Supplier)
      # 2 queries, union in Ruby; no incompatible joins involved
      ids_from_items = ItemLine.where(supplier_id: source.id).distinct.pluck(:project_id)
      ids_from_bills = Bill.where(supplier_id: source.id).distinct.pluck(:project_id)
      (ids_from_items | ids_from_bills).compact.size
    else
      # index path (using pre-aggregated columns)
      [source.read_attribute(:projects_from_items).to_i,
       source.read_attribute(:projects_from_bills).to_i].max
    end
  end
end
