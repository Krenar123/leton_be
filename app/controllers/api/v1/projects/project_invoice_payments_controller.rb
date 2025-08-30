# app/controllers/api/v1/projects/invoice_payments_controller.rb
module Api
  module V1
    module Projects
      class ProjectInvoicePaymentsController < ApplicationController
        before_action :set_project
        before_action :set_invoice

        def create
          pay = @invoice.payments.build(payment_params)
          pay.created_by = current_user
          pay.ref = SecureRandom.hex(16) if pay.ref.blank?

          if pay.save
            # Optionally auto-advance invoice status
            if @invoice.outstanding <= 0
              @invoice.update(status: :paid, payment_date: pay.payment_date)
            elsif @invoice.paid_total > 0 && @invoice.sent?
              @invoice.update(status: :partial)
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

        def set_invoice
          # invoice route param is :ref (because we set param: :ref in routes)
          @invoice = @project.invoices.find_by!(ref: params[:invoice_ref])
        end

        def payment_params
          params.require(:payment).permit(:amount, :payment_method, :payment_date, :reference_number, :notes, :ref)
        end
      end
    end
  end
end
