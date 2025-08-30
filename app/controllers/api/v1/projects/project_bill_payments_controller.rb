# app/controllers/api/v1/projects/bill_payments_controller.rb
module Api
  module V1
    module Projects
      class ProjectBillPaymentsController < ApplicationController
        before_action :set_project
        before_action :set_bill

        def create
          pay = @bill.payments.build(payment_params)
          pay.created_by = current_user
          pay.ref = SecureRandom.hex(16) if pay.ref.blank?

          if pay.save
            # Optionally auto-advance bill status
            if @bill.outstanding <= 0
              @bill.update(status: :paid) # you could add paid_date if you add that column
            elsif @bill.paid_total > 0 && @bill.outstanding > 0
              @bill.update(status: :partially_paid)
            end

            render json: pay.as_json, status: :created
          else
            render json: { errors: pay.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_project
          @project = Project.find_by!(ref: params[:project_ref])
        end

        def set_bill
          @bill = @project.bills.find_by!(ref: params[:bill_ref])
        end

        def payment_params
          params.require(:payment).permit(:amount, :payment_method, :payment_date, :reference_number, :notes, :ref)
        end
      end
    end
  end
end
