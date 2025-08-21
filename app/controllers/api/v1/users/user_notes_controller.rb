# app/controllers/api/v1/users/user_notes_controller.rb
module Api
  module V1
    module Users
      class UserNotesController < ApplicationController
        def index
          user = User.find_by!(ref: params[:user_ref])
          notes = Note.where(user_id: user.id).order(updated_at: :desc)
          render json: NoteSerializer.new(notes).serializable_hash
        end
      end
    end
  end
end
