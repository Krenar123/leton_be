module Api
  module V1
    module Clients
      class ClientInvoicesController < ApplicationController
        def index
          client = Client.find_by!(ref: params[:client_ref])
          render json: InvoiceSerializer.new(client.invoices)
        end
      end
    end
  end
end
