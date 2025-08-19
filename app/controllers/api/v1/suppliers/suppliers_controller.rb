module Api
  module V1
    module Suppliers
      class SuppliersController < ApplicationController
        def index
          suppliers = Supplier.all
          render json: SupplierSerializer.new(suppliers)
        end

        def show
          supplier = Supplier.find_by!(ref: params[:ref])
          render json: SupplierSerializer.new(supplier)
        end
      end
    end
  end
end
