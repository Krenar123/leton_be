# app/controllers/api/v1/projects/project_meetings_controller.rb
module Api
  module V1
    module Projects
      class ProjectMeetingsController < ApplicationController
        before_action :set_project
        before_action :set_meeting, only: [:update, :destroy]

        # GET /api/v1/projects/:ref/meetings
        def index
          meetings = @project.meetings.order(meeting_date: :asc)
          render json: MeetingSerializer.new(meetings)
        end

        # POST /api/v1/projects/:ref/meetings
        def create
          meeting = @project.meetings.new(meeting_params)
          meeting.ref ||= SecureRandom.hex(10)
          # Optional: set organizer if you have current_user
          meeting.organizer ||= current_user if respond_to?(:current_user, true)

          if meeting.save
            MeetingParticipant.create!(meeting: meeting, client: client, user: current_user)
            render json: { data: serialize(meeting) }, status: :created
          else
            render json: { message: meeting.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/projects/:ref/meetings/:ref
        def update
          if @meeting.update(meeting_params)
            render json: { data: serialize(@meeting) }
          else
            render json: { message: @meeting.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/projects/:ref/meetings/:ref
        def destroy
          @meeting.destroy
          head :no_content
        end

        private

        def set_project
          @project = ::Project.find_by!(ref: params[:project_ref])
        end

        def set_meeting
          @meeting = @project.meetings.find_by!(ref: params[:ref])
        end

        # Accept either a single ISO datetime (meeting_date) OR day+time from FE
        def meeting_params
          p = params.require(:meeting).permit(
            :title, :description, :location,
            :meeting_date,        # preferred single datetime
            :duration_minutes, :meeting_type, :status,
            :day, :time           # optional fallback from FE
          )

          if p[:meeting_date].blank? && p[:day].present? && p[:time].present?
            # Combine YYYY-MM-DD + HH:mm into a timezone-aware datetime
            p[:meeting_date] = Time.zone.parse("#{p[:day]} #{p[:time]}")
          end

          p.except(:day, :time)
        end

        # Keep API snake_case; include convenient day/time for FE
        def serialize(m)
          {
            id: m.ref,
            type: "meeting",
            attributes: {
              ref: m.ref,
              title: m.title,
              description: m.description,
              location: m.location,
              meeting_date: m.meeting_date&.iso8601,
              day: m.meeting_date&.to_date&.to_s,
              time: m.meeting_date&.strftime("%H:%M"),
              duration_minutes: m.duration_minutes,
              meeting_type: m.meeting_type, # enum value as string via as_json if you prefer
              status: m.status              # enum value as string via as_json if you prefer
            }
          }
        end
      end
    end
  end
end
