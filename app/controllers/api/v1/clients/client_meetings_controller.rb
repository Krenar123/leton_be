module Api
  module V1
    module Clients
      class ClientMeetingsController < ApplicationController
        include CreatedByAssignable
        
        def index
          client = Client.find_by!(ref: params[:client_ref])
          render json: MeetingSerializer.new(client.meetings)
        end

        def create
          client = Client.find_by!(ref: params[:client_ref])

          # project is required by Meeting (belongs_to :project)
          # project = Project.find_by!(ref: meeting_params[:project_ref])

          meeting = Meeting.new(meeting_params)
          meeting.organizer = current_user

          if meeting.save
            MeetingParticipant.create!(meeting: meeting, client: client, user: current_user)
            render json: MeetingSerializer.new(meeting).serializable_hash, status: :created
          else
            render json: { errors: meeting.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def meeting_params
          # FE will send { meeting: { title, description, meeting_date, duration_minutes, location, meeting_type, status, project_ref } }
          params.require(:meeting).permit(
            :title, :description, :meeting_date, :duration_minutes,
            :location, :meeting_type, :status, :project_ref
          )
        end
      end
    end
  end
end