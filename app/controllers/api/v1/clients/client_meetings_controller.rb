module Api
  module V1
    module Clients
      class ClientMeetingsController < ApplicationController
        def index
          client = Client.find_by!(ref: params[:client_ref])
          render json: MeetingSerializer.new(client.meetings)
        end
      end
    end
  end
end