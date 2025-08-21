# app/controllers/api/v1/users/user_objectives_controller.rb
module Api
  module V1
    module Users
      class UserObjectivesController < ApplicationController
        def index
          user = User.find_by!(ref: params[:user_ref])
          objectives = Objective.where(assigned_to_id: user.id).order(created_at: :desc)
          render json: ObjectiveSerializer.new(objectives).serializable_hash
        end
      end
    end
  end
end
