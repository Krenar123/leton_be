module Api
  module V1
    module Clients
      class ClientsController < ApplicationController
        include CreatedByAssignable

        def index
          clients = Client.includes(:projects, :invoices).order(created_at: :desc)
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

        def update
          client = Client.find_by!(ref: params[:ref])
          if client.update(client_params)
            render json: ClientSerializer.new(client).serializable_hash
          else
            render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        def client_params
          params.require(:client).permit(:company, :contact_name, :phone, :email, :address, :website, :industry, :status)
        end
      end
    end
  end
end
