# app/controllers/api/v1/projects/project_invoices_controller.rb
module Api
  module V1
    module Projects
      class ProjectInvoicesController < ApplicationController
        before_action :set_project

        def index
          invoices = @project.invoices.order(created_at: :desc)
          render json: invoices.as_json(only: [:ref, :invoice_number, :amount, :tax_amount, :total_amount, :issue_date, :due_date, :status, :payment_date],
                                        methods: [:paid_total, :outstanding],
                                        include: { item_line: { only: [:id, :ref], methods: [:item_line] } })
        end

        def create
          inv = @project.invoices.build(invoice_params)
          inv.client_id = @project.client_id
          inv.created_by = current_user
          # If total_amount not given, default to amount
          inv.total_amount ||= inv.amount

          if inv.save
            render json: inv.as_json, status: :created
          else
            puts inv.errors.full_messages 
            render json: { errors: inv.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        def invoice_params
          # Minimal fields required: item_line_id + amount; the rest optional
          params.require(:invoice).permit(
            :invoice_number, :amount, :tax_amount, :total_amount,
            :issue_date, :due_date, :status, :payment_date, :item_line_id, :ref
          )
        end
      end
    end
  end
end
