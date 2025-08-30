# app/controllers/api/v1/projects/project_bills_controller.rb
module Api
  module V1
    module Projects
      class ProjectBillsController < ApplicationController
        before_action :set_project

        def index
          bills = @project.bills.order(created_at: :desc)
          render json: bills.as_json(only: [:ref, :bill_number, :amount, :tax_amount, :total_amount, :issue_date, :due_date, :status, :payment_date],
                                        methods: [:paid_total, :outstanding],
                                        include: { item_line: { only: [:id, :ref], methods: [:item_line] } })
        end

        def create
          inv = @project.bills.build(bill_params)
          supplier = ItemLine.find_by(id: bill_params[:item_line_id])&.supplier
          inv.supplier_id = supplier.id
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

        def bill_params
          # Minimal fields required: item_line_id + amount; the rest optional
          params.require(:bill).permit(
            :bill_number, :amount, :tax_amount, :total_amount,
            :issue_date, :due_date, :status, :payment_date, :item_line_id, :ref
          )
        end
      end
    end
  end
end
