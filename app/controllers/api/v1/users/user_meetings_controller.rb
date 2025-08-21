# app/controllers/api/v1/users/user_meetings_controller.rb
module Api
  module V1
    module Users
      class UserMeetingsController < ApplicationController
        def index
          user = User.find_by!(ref: params[:user_ref])

          meetings = Meeting.left_joins(:meeting_participants)
                            .where("meetings.organizer_id = :uid OR meeting_participants.user_id = :uid", uid: user.id)
                            .distinct
                            .order(meeting_date: :desc)

          render json: MeetingSerializer.new(meetings).serializable_hash
        end
      end
    end
  end
end
