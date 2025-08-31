module Api
  module V1
    module Projects
      class ProjectBillsController < ApplicationController
        before_action :set_project

        def index
          bills = @project.bills.includes(bill_lines: :item_line).order(created_at: :desc)
          render json: bills.as_json(
            only: [:ref, :bill_number, :amount, :tax_amount, :total_amount,
                   :issue_date, :due_date, :status, :payment_date, :created_at],
            methods: [:paid_total, :outstanding, :lines_total],
            include: {
              bill_lines: {
                only: [:id, :amount],
                include: {
                  item_line: { only: [:id, :ref], methods: [:item_line] }
                }
              }
            }
          )
        end

        def create
          ids = Array(params.dig(:bill, :item_line_ids)).map(&:to_i).uniq
          raise ActionController::ParameterMissing, "item_line_ids" if ids.blank?

          amount = BigDecimal(params[:bill][:amount].to_s)
          raise ActionController::ParameterMissing, "amount" if amount <= 0

          # Validate all selected item_lines share the same supplier
          supplier_ids = ItemLine.where(id: ids).pluck(:supplier_id).compact.uniq
          if supplier_ids.size > 1
            return render json: { errors: ["Selected item lines belong to different suppliers"] }, status: :unprocessable_entity
          end
          supplier_id = supplier_ids.first

          split = amount / ids.size

          bill = nil

          Bill.transaction do
            bill = @project.bills.build(bill_header_params)
            bill.supplier_id = supplier_id
            bill.created_by = current_user

            bill.total_amount ||= bill.amount.presence || amount
            bill.amount ||= amount

            bill.save!

            ids.each do |item_line_id|
              bill.bill_lines.create!(item_line_id:, amount: split)
            end
          end

          render json: bill.as_json, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: bill&.errors&.full_messages || [e.message] }, status: :unprocessable_entity
        end

        private

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        def bill_header_params
          params.require(:bill).permit(
            :bill_number, :amount, :tax_amount, :total_amount,
            :issue_date, :due_date, :status, :payment_date, :ref
          )
        end
      end
    end
  end
end
