module Api
  module V1
    module Clients
      class ClientProjectsController < ApplicationController
        def index
          client = Client.find_by!(ref: params[:client_ref])
          render json: ProjectSerializer.new(client.projects)
        end
      end
    end
  end
end
