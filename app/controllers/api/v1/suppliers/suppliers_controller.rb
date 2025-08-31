module Api
  module V1
    module Suppliers
      class SuppliersController < ApplicationController
        def index
          suppliers = Supplier
            .left_joins(bills: :payments)
            .left_joins(:item_lines)
            .select(
              'suppliers.*',

              # projects from items and bills
              'COUNT(DISTINCT item_lines.project_id) AS projects_from_items',
              'COUNT(DISTINCT bills.project_id)      AS projects_from_bills',

              # money rollups
              # prefer total_amount if present, else amount + tax_amount
              # Postgres COALESCE on each row then SUM across rows:
              'COALESCE(SUM(COALESCE(bills.total_amount, (bills.amount + bills.tax_amount))), 0) AS total_value_sum',
              'COALESCE(SUM(payments.amount), 0) AS total_paid_sum',

              # dates from bills (fallbacks handled later)
              'MIN(bills.issue_date) AS first_bill_date',
              'MAX(bills.issue_date) AS last_bill_date',

              # current projects (active via bills or item lines)
              # we’ll compute counts in Ruby using precomputed flags
              # but we also precompute flags here to stay 1-pass:
              "SUM(CASE WHEN bills.status IN (1,2) THEN 1 ELSE 0 END) AS active_bill_rows",      # issued, partially_paid
              "SUM(CASE WHEN item_lines.status IN (0,1) THEN 1 ELSE 0 END) AS active_item_rows"  # planned, in_progress
            )
            .group('suppliers.id')
            
          render json: SupplierSerializer.new(suppliers)
        end

        def show
          supplier = Supplier.find_by!(ref: params[:ref])
          # reuse the same aggregates but for one supplier to populate the details page
          aggregates = Supplier
            .where(id: supplier.id)
            .left_joins(bills: :payments)
            .left_joins(:item_lines)
            .select(
              'suppliers.id',

              'COUNT(DISTINCT item_lines.project_id) AS projects_from_items',
              'COUNT(DISTINCT bills.project_id)      AS projects_from_bills',
              'COALESCE(SUM(COALESCE(bills.total_amount, (bills.amount + bills.tax_amount))), 0) AS total_value_sum',
              'COALESCE(SUM(payments.amount), 0) AS total_paid_sum',
              'MIN(bills.issue_date) AS first_bill_date',
              'MAX(bills.issue_date) AS last_bill_date',
              "SUM(CASE WHEN bills.status IN (1,2) THEN 1 ELSE 0 END) AS active_bill_rows",
              "SUM(CASE WHEN item_lines.status IN (0,1) THEN 1 ELSE 0 END) AS active_item_rows"
            )
            .group('suppliers.id')
            .first

          render json: SupplierSerializer.new(supplier, params: { aggregates: aggregates })
        end
      end
    end
  end
end
