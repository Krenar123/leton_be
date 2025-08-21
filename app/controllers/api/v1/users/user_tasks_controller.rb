# app/controllers/api/v1/users/user_tasks_controller.rb
module Api
  module V1
    module Users
      class UserTasksController < ApplicationController
        def index
          user = User.find_by!(ref: params[:user_ref])
          tasks = Task.where(assigned_to_id: user.id).order(created_at: :desc)
          render json: TaskSerializer.new(tasks).serializable_hash
        end
      end
    end
  end
end
