module Api
  module V1
    module Suppliers
      class SupplierProjectsController < ApplicationController
        def index
          supplier = Supplier.find_by!(ref: params[:supplier_ref])
          render json: ProjectSerializer.new(supplier.projects)
        end
      end
    end
  end
end
