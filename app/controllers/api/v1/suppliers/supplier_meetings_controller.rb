module Api
  module V1
    module Suppliers
      class SupplierMeetingsController < ApplicationController
        def index
          supplier = Supplier.find_by!(ref: params[:supplier_ref])
          render json: MeetingSerializer.new(supplier.meetings)
        end
      end
    end
  end
end
