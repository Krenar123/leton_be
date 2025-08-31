module Api
  module V1
    module Projects
      class ProjectInvoicesController < ApplicationController
        before_action :set_project

        def index
          invoices = @project.invoices.includes(invoice_lines: :item_line).order(created_at: :desc)
          render json: invoices.as_json(
            only: [:ref, :invoice_number, :amount, :tax_amount, :total_amount,
                   :issue_date, :due_date, :status, :payment_date, :created_at],
            methods: [:paid_total, :outstanding, :lines_total],
            include: {
              invoice_lines: {
                only: [:id, :amount],
                include: {
                  item_line: { only: [:id, :ref], methods: [:item_line] }
                }
              }
            }
          )
        end

        def create
          ids = Array(params.dig(:invoice, :item_line_ids)).map(&:to_i).uniq
          raise ActionController::ParameterMissing, "item_line_ids" if ids.blank?

          amount = BigDecimal(params[:invoice][:amount].to_s)
          raise ActionController::ParameterMissing, "amount" if amount <= 0

          split = amount / ids.size

          inv = nil

          Invoice.transaction do
            inv = @project.invoices.build(invoice_header_params)
            inv.client_id = @project.client_id
            inv.created_by = current_user

            # If total_amount not given, use header amount (or lines sum)
            inv.total_amount ||= inv.amount.presence || amount
            inv.amount ||= amount # keep header gross for convenience

            inv.save!

            ids.each do |item_line_id|
              inv.invoice_lines.create!(item_line_id:, amount: split)
            end
          end

          render json: inv.as_json, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: inv&.errors&.full_messages || [e.message] }, status: :unprocessable_entity
        end

        private

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        # Header fields only
        def invoice_header_params
          params.require(:invoice).permit(
            :invoice_number, :amount, :tax_amount, :total_amount,
            :issue_date, :due_date, :status, :payment_date, :ref
          )
        end
      end
    end
  end
end
