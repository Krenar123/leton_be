module Api
  module V1
    module Suppliers
      class SupplierBillsController < ApplicationController
        def index
          supplier = Supplier.find_by!(ref: params[:supplier_ref])
          render json: BillSerializer.new(supplier.bills)
        end
      end
    end
  end
end
