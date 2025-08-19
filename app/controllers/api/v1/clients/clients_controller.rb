module Api
  module V1
    module Clients
      class ClientsController < ApplicationController
        include CreatedByAssignable

        def index
          clients = Client.all
          render json: ClientSerializer.new(clients)
        end

        def show
          client = Client.find_by!(ref: params[:ref])
          render json: ClientSerializer.new(client)
        end

        def create
          client = Client.new(client_params)
          assign_created_by(client)
          if client.save
            render json: ClientSerializer.new(client), status: :created
          else
            render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        def client_params
          params.require(:client).permit(:company, :contact_name, :phone, :email)
        end
      end
    end
  end
end
