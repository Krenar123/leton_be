module Api
  module V1
    module Suppliers
      class SupplierInvoicesController < ApplicationController
        def index
          supplier = Supplier.find_by!(ref: params[:supplier_ref])
          render json: InvoiceSerializer.new(supplier.invoices)
        end
      end
    end
  end
end
